#include "RowToeplitzCG.h"
#include <iostream>
#include <limits>
#include <string.h>

#include <ipp.h>
#include <mkl.h>

#include "sptAssert.h"

#ifdef INSTRUMENT_RECONSTRUCTION
#include "IRPLogger.h"
#endif

using namespace std;


RowToeplitzCG::
RowToeplitzCG(int nRowsMax, int nImpulseMax, int nRestart) :
  _nRowsMax(nRowsMax),
  _nImpulseMax(nImpulseMax),
  _nRestart(nRestart)
{
  sptAssert(nRowsMax > 0);
  sptAssert(nRowsMax > nImpulseMax);
  sptAssert(nRestart > 0);

  int nColumnsMax = _nRowsMax + _nImpulseMax - 1;

  // column dimension vectors for intermediate results
  int const cacheLineAlignment = 64;
  _d = allocateMKLFloatArray(nColumnsMax, cacheLineAlignment);
  _q = allocateMKLFloatArray(nColumnsMax, cacheLineAlignment);
  _r = allocateMKLFloatArray(nColumnsMax, cacheLineAlignment);
  _bNormal = allocateMKLFloatArray(nColumnsMax, cacheLineAlignment);
  _temp1 = allocateMKLFloatArray(nColumnsMax, cacheLineAlignment);

  // A large vector to handle the ends of the convolution vector
  int nLargeVec = nColumnsMax + _nImpulseMax - 1;
  _temp2 = allocateMKLFloatArray(nLargeVec, cacheLineAlignment);

#ifdef INSTRUMENT_RECONSTRUCTION
  _IRPLogger = IRPLogger::getInstance();
  sptAssert(_IRPLogger);
#endif
}


RowToeplitzCG::
~RowToeplitzCG(void)
{
  mkl_free(_d);
  mkl_free(_q);
  mkl_free(_r);
  mkl_free(_bNormal);
  mkl_free(_temp1);

  mkl_free(_temp2);
}


int RowToeplitzCG::solveNormalEquations(const float * toeplitzRow,
                                        int nToeplitzElements,
                                        int nRows,
                                        const float * b,
                                        float * xEstimate,
                                        int iMax,
                                        float epsilon)
{
  // Initialize the number of columns based on the number of rows in the matrix (nRows) plus the number of Toeplitz
  // elements in each row (nToeplitzElements) - 1
  const int nColumns = nToeplitzElements + nRows - 1;
  const int rowConvolutionOffset = nToeplitzElements - 1;
  // assumption:: the row is an even function about it's center so that we don't have to reverse it for the row toeplitz
  // matrix-vector multiplies implemented by convolution

  updateResidual(toeplitzRow, nToeplitzElements, nRows, xEstimate, nColumns, b);

  //print_array(r, nColumns, "r");

  // d = r
  cblas_scopy(nColumns, _r, 1, _d, 1);

  // delta_new = r^T * r
  float deltaNew = cblas_sdot(nColumns, _r, 1, _r, 1);;

  float delta_0 = deltaNew;
  int i = 0;
  float epsilonSquared = epsilon * epsilon;
  while (deltaNew > epsilonSquared * delta_0)
  {
    // Ad = _temp2[nToeplitzElements - 1 : nRows + nToeplitzElements - 1]
    ippsConv_32f(toeplitzRow, nToeplitzElements, _d, nColumns, _temp2);
    _Ad = _temp2 + rowConvolutionOffset;

    // AdDotAd = (Ad)^T  Ad
    float AdDotAd = cblas_sdot(nRows, _Ad, 1, _Ad, 1);

    // If AdDotAd is so small that the division produces an effectively infinite result exit from the loop
    float alpha = deltaNew / AdDotAd;

    // TODO: unit test this path
    if (! _finite(alpha))
    {
      cerr << "infinite alpha" << endl;
      break;
    }

    // x = x + alpha d
    cblas_saxpy(nColumns, alpha, _d, 1, xEstimate, 1);

    // If we have done the max number of iterations, return since the x estimate is updated and we don't need to do the
    // rest of the calculations before we'd exit the while loop
    ++i;
    if (i == iMax)
    {
      break;
    }

    // For most iterations we estimate the next residual from
    // r = r - alpha A^T Ad
    // but every modulo(nRestart) iterations recalculate the residual using the full
    // r = A^T(b - Ax)
    if (i % _nRestart)
    {
      // q = A^T Ad
      ippsConv_32f(toeplitzRow, nToeplitzElements, _Ad, nRows, _q);

      // r = r - alpha * q
      cblas_saxpy(nColumns, -1.0F * alpha, _q, 1, _r, 1);
    }
    else
    {
      updateResidual(toeplitzRow, nToeplitzElements, nRows, xEstimate, nColumns, b);
    }

    float deltaOld = deltaNew;

    // delta_new = r^T r
    deltaNew = cblas_sdot(nColumns, _r, 1, _r, 1);

    float beta = deltaNew / deltaOld;
    // TODO: unit test this path
    if (! _finite(beta))
    {
      cerr << "infinite beta" << endl;
      break;
    }

    // d = r + beta * d
    cblas_saxpby(nColumns, 1.0, _r, 1, beta, _d, 1);
  }

  return i;
}


// TODO: this needs to be unit tested
void RowToeplitzCG::updateResidual(const float * row,
                                   int nRowElements,
                                   int nRows,
                                   float * xEstimate,
                                   int nColumns,
                                   const float * b)
{
  // temp2[nRowElements - 1:] = Ax
  ippsConv_32f(row, nRowElements, xEstimate, nColumns, _temp2);

  // temp1 = b - temp2
  vsSub(nRows, b, _temp2 + nRowElements - 1, _temp1);
  // Optimization suggestion from Beh
  // Beh:: since VML supports in-place operation,
  // consider removing temp1 and executing temp2 = b - temp2 instead.
  // This can save one buffer.
  // see link for VML in-place operation support:
  // http://software.intel.com/sites/products/documentation/hpc/mkl/mklman/index.htm#GUID-59EC4B87-29C8-4FB4-B57C-D269E6364954.htm

  // r = A^T temp1
  ippsConv_32f(row, nRowElements, _temp1, nRows, _r);
}

float * RowToeplitzCG::allocateMKLFloatArray(int nElements, int const cacheLineAlignment)
{
  void * pointer = MKL_malloc(nElements * sizeof(float), cacheLineAlignment);
  sptAssert(pointer != NULL);
  return static_cast<float *>(pointer);
}
