#pragma once
#include <new>
#include "mkl.h"

#ifdef INSTRUMENT_RECONSTRUCTION
class IRPLogger;
#endif

template <typename T>
class MKLMatrix
{
  public:
    MKLMatrix(void);
    MKLMatrix(int nRows, int nCols);
    ~MKLMatrix(void);

    // Resize will change the number of rows and columns that the matrix represents.  It will use the existing memory
    // buffer if it is large enough, or attempt to allocate a new one if it is not.
    void resize(int nRows, int nCols);
    void zeros();
    void fill_row_toeplitz(const T * row, int n_row_elements, int n_rows, int n_cols);

    void multiply(T * vec, T * result);

    int _nRows;
    int _nCols;

    // The number of elements of type T currently allocated by buffer
    int _nAlloc;
    T * _buffer;

  private:
    void allocate();

#ifdef INSTRUMENT_RECONSTRUCTION
    IRPLogger * _IRPLogger;
#endif
};


template <typename T>
MKLMatrix<T>::MKLMatrix(void)
{
#ifdef INSTRUMENT_RECONSTRUCTION
  _IRPLogger = IRPLogger::getInstance();
#endif

  _nRows = 0;
  _nCols = 0;
  _nAlloc = 0;
  _buffer = 0;
}


template <typename T>
MKLMatrix<T>::MKLMatrix(int nRows, int nCols) :
  _nRows(nRows),
  _nCols(nCols),
  _buffer(0)
{
#ifdef INSTRUMENT_RECONSTRUCTION
  _IRPLogger = IRPLogger::getInstance();
  sptAssert(_IRPLogger);
#endif

  allocate();
}


template <typename T>
void MKLMatrix<T>::allocate()
{
  if (_buffer != 0)
  {
    mkl_free(_buffer);
  }

  // Use 64 byte alignment to match the cache line size of Intel processors
  _nAlloc = _nRows * _nCols;
  _buffer = (T *) mkl_malloc(_nAlloc * sizeof(T), 64);

  if (_buffer == 0)
  {
    _nAlloc = 0;
    throw std::bad_alloc();
  }
}


template <typename T>
void MKLMatrix<T>::resize(int nRows, int nCols)
{
  _nRows = nRows;
  _nCols = nCols;
  if (_nRows * _nCols > _nAlloc)
  {
    allocate();
  }
}


template <typename T>
void MKLMatrix<T>::zeros()
{
  int nElem = _nRows * _nCols;
  for (int i = 0; i < nElem; ++i)
  {
    _buffer[i] = 0;
  }
}


template <typename T>
MKLMatrix<T>::~MKLMatrix(void)
{
  if (_buffer != 0)
  {
    mkl_free(_buffer);
  }
}

template <typename T> void MKLMatrix<T>::
fill_row_toeplitz(const T * row, int n_row_elements, int n_rows, int n_cols)
{
  this->zeros();
  for (int i_row = 0; i_row < n_rows; i_row++)
  {
    int row_start_offset = i_row * (1 + n_cols);
    T * mat_row = _buffer + row_start_offset;
    memcpy(mat_row, row, n_row_elements * sizeof(float));
  }
}


template <>
inline void MKLMatrix<float>::multiply(float * vec, float * result)
{
  cblas_sgemv(CblasRowMajor, CblasNoTrans, _nRows, _nCols, 1.0F, _buffer, _nCols, vec, 1, 0.0F, result, 1);
}