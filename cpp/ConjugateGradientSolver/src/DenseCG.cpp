#include <assert.h>
#include <iostream>
#include <limits>

#include "mkl.h"

#include "utilities.hpp"
#include "MKLMatrix.hpp"
#include "DenseCG.h"

using namespace std;


DenseCG::
DenseCG(int max_elements, int n_restart) :
  n_restart(n_restart)
{
  this->max_elements = max_elements;
  d = static_cast<float *>(mkl_malloc(max_elements * sizeof(float), 64));
  q = static_cast<float *>(mkl_malloc(max_elements * sizeof(float), 64));
  r = static_cast<float *>(mkl_malloc(max_elements * sizeof(float), 64));
  temp1 = static_cast<float *>(mkl_malloc(max_elements * sizeof(float), 64));
  temp2 = static_cast<float *>(mkl_malloc(max_elements * sizeof(float), 64));
  b_normal = static_cast<float *>(mkl_malloc(max_elements * sizeof(float), 64));
  a_d = static_cast<float *>(mkl_malloc(max_elements * sizeof(float), 64));

  for (int i=0;i<max_elements;++i) d[i] = -42;
  for (int i=0;i<max_elements;++i) q[i] = -42;
  for (int i=0;i<max_elements;++i) r[i] = -42;
  for (int i=0;i<max_elements;++i) temp1[i] = -42;
  for (int i=0;i<max_elements;++i) temp2[i] = -42;
  for (int i=0;i<max_elements;++i) b_normal[i] = -42;
  for (int i=0;i<max_elements;++i) a_d[i] = -42;
}


DenseCG::
~DenseCG(void)
{
  mkl_free(d);
  mkl_free(q);
  mkl_free(r);
  mkl_free(temp1);
  mkl_free(temp2);
  mkl_free(b_normal);
  mkl_free(a_d);
}


void DenseCG::
setA(float * mat_A, int n_rows, int n_cols, int step_bytes)
{
  this->mat_A = mat_A;
  this->n_rows = n_rows;
  this->n_cols = n_cols;
  if (n_rows == n_cols)
  {
    this->n_elements = n_rows;
  }
  else
  {
    // Set n_elements to a guard value so that the solve method is not accidentally used on a non-square matrix
    this->n_elements = 0;
  }
  this->step_bytes_A = step_bytes;
}


void DenseCG::
setA(MKLMatrix<float> & matrix)
{
  mat_A = matrix._buffer;
  n_rows = matrix._nRows;
  n_cols = matrix._nCols;
  step_bytes_A = n_cols * sizeof(float);
  if (n_rows == n_cols)
  {
    this->n_elements = n_rows;
  }
  else
  {
    // Set n_elements to a guard value so that the solve method is not accidentally used on a non-square matrix
    this->n_elements = 0;
  }
}

void DenseCG::
setB(float * b, int n_rows)
{
  this->b = b;
  assert(this->n_rows == n_rows);
}


int DenseCG::
solve(float * est_x, int i_max, float epsilon)
{
  assert (n_elements != 0);

  int col_stride = sizeof(float);
  int vec_stride = max_elements * col_stride;
  IppStatus status;

  // temp = Ax
  status = ippmMul_mv_32f(mat_A, step_bytes_A, col_stride, n_elements, n_elements,
                          est_x, col_stride, n_elements,
                          temp1, col_stride);
  check_ipp_status(status, __FILE__, __LINE__);

  // r = b - temp
  status = ippmSub_vv_32f(b, col_stride, temp1, col_stride, r, col_stride, n_elements);
  check_ipp_status(status, __FILE__, __LINE__);

  // d = r
  status = ippmCopy_va_32f_SS(r, vec_stride, col_stride, d, vec_stride, col_stride, n_elements, 1);
  check_ipp_status(status, __FILE__, __LINE__);

  // delta_new = r^T * r
  float delta_new;
  status = ippmDotProduct_vv_32f(r, col_stride, r, col_stride, & delta_new, n_elements);
  check_ipp_status(status, __FILE__, __LINE__);

  float delta_0 = delta_new;
  int i = 0;
  float epsilon_squared = epsilon * epsilon;
  while (i < i_max && delta_new > epsilon_squared * delta_0)
  {
    // q = Ad
    status = ippmMul_mv_32f(mat_A, step_bytes_A, col_stride, n_elements, n_elements,
                            d, col_stride, n_elements,
                            q, col_stride);
    check_ipp_status(status, __FILE__, __LINE__);

    // d_dot_q = d^T * q
    float d_dot_q;
    status = ippmDotProduct_vv_32f(d, col_stride, q, col_stride, & d_dot_q, n_elements);
    check_ipp_status(status, __FILE__, __LINE__);

    // If d_dot_q is so small that the division produces an effectively infinite result exit from the loop
    float alpha = delta_new / d_dot_q;
    // TODO: unit test this path
    if (! _finite(alpha))
    {
      cerr << "infinite alpha" << endl;
      break;
    }

    // temp = alpha d
    status = ippmMul_vc_32f(d, col_stride, alpha, temp1, col_stride, n_elements);
    check_ipp_status(status, __FILE__, __LINE__);

    // temp2 = x + temp
    status = ippmAdd_vv_32f(est_x, col_stride, temp1, col_stride, temp2, col_stride, n_elements);
    check_ipp_status(status, __FILE__, __LINE__);

    // x = temp2 ... since IPP doesn't support in-place operations
    status = ippmCopy_va_32f_SS(temp2, vec_stride, col_stride, est_x, vec_stride, col_stride, n_elements, 1);
    check_ipp_status(status, __FILE__, __LINE__);

    ++i;

    // if we have exceed modulo(n_restart) iterations recalculate the residual
    if (i % n_restart)
    {
      // temp = alpha * q
      status = ippmMul_vc_32f(q, col_stride, alpha, temp1, col_stride, n_elements);
      check_ipp_status(status, __FILE__, __LINE__);

      // temp2 = r - temp
      status = ippmSub_vv_32f(r, col_stride, temp1, col_stride, temp2, col_stride, n_elements);
      check_ipp_status(status, __FILE__, __LINE__);

      // r = temp2
      status = ippmCopy_va_32f_SS(temp2, vec_stride, col_stride, r, vec_stride, col_stride, n_elements, 1);
      check_ipp_status(status, __FILE__, __LINE__);
    }
    else
    {
      // temp = Ax
      status = ippmMul_mv_32f(mat_A, step_bytes_A, col_stride, n_elements, n_elements,
                              est_x, col_stride, n_elements,
                              temp1, col_stride);
      check_ipp_status(status, __FILE__, __LINE__);
      // r = b - temp
      status = ippmSub_vv_32f(b, col_stride, temp1, col_stride, r, col_stride, n_elements);
      check_ipp_status(status, __FILE__, __LINE__);
    }
    float delta_old = delta_new;

    // delta_new = r^T r
    status = ippmDotProduct_vv_32f(r, col_stride, r, col_stride, & delta_new, n_elements);
    check_ipp_status(status, __FILE__, __LINE__);

    float beta = delta_new / delta_old;
    // TODO: unit test this path
    if (! _finite(beta))
    {
      cerr << "infinite beta" << endl;
      break;
    }

    // temp = beta * d
    status = ippmMul_vc_32f(d, col_stride, beta, temp1, col_stride, n_elements);
    check_ipp_status(status, __FILE__, __LINE__);

    // d = r + temp
    status = ippmAdd_vv_32f(r, col_stride, temp1, col_stride, d, col_stride, n_elements);
    check_ipp_status(status, __FILE__, __LINE__);

  }

  return i;
}

//////////////////////////////////////////////////////////////////////////
// Conjugate gradient solver for the normal equations
//////////////////////////////////////////////////////////////////////////
int DenseCG::
solve_normal_eq_ipp(float * est_x, int i_max, float epsilon = sqrt(numeric_limits<float>::min()))
{
  int col_stride = sizeof(float);
  int col_bytes = col_stride * n_cols;
  int vec_stride = max_elements * col_stride;
  
  IppStatus status;

  // temp = Ax
  status = ippmMul_mv_32f(mat_A, step_bytes_A, col_stride, n_cols, n_rows,
                          est_x, col_stride, n_cols,
                          temp1, col_stride);
  check_ipp_status(status, __FILE__, __LINE__);

  // temp2 = A^T temp1
  status = ippmMul_tv_32f(mat_A, step_bytes_A, col_stride, n_cols, n_rows,
                          temp1, col_stride, n_rows,
                          temp2, col_stride);
  check_ipp_status(status, __FILE__, __LINE__);

  // Compute the normal equations right hand side A^Tb
  status = ippmMul_tv_32f(mat_A, step_bytes_A, col_stride, n_cols, n_rows,
    b, col_stride, n_rows,
    b_normal, col_stride);
  check_ipp_status(status, __FILE__, __LINE__);

  // r = b_normal - temp2
  status = ippmSub_vv_32f(b_normal, col_stride, temp2, col_stride, r, col_stride, n_cols);
  check_ipp_status(status, __FILE__, __LINE__);

  // d = r
  status = ippmCopy_va_32f_SS(r, vec_stride, col_stride, d, vec_stride, col_stride, n_cols, 1);
  check_ipp_status(status, __FILE__, __LINE__);
  //memcpy(d, r, col_bytes);

  // delta_new = r^T * r
  float delta_new;
  status = ippmDotProduct_vv_32f(r, col_stride, r, col_stride, & delta_new, n_cols);
  check_ipp_status(status, __FILE__, __LINE__);

  float delta_0 = delta_new;
  int i = 0;
  float epsilon_squared = epsilon * epsilon;
  while (i < i_max && delta_new > epsilon_squared * delta_0)
  {
    // ad = Ad
    status = ippmMul_mv_32f(mat_A, step_bytes_A, col_stride, n_cols, n_rows,
                            d, col_stride, n_cols,
                            a_d, col_stride);
    check_ipp_status(status, __FILE__, __LINE__);

    // q = A^T ad
    status = ippmMul_tv_32f(mat_A, step_bytes_A, col_stride, n_cols, n_rows,
                            a_d, col_stride, n_rows,
                            q, col_stride);
    check_ipp_status(status, __FILE__, __LINE__);
    
    // ad_dot_ad = (Ad)^T  Ad
    float ad_dot_ad;
    status = ippmDotProduct_vv_32f(a_d, col_stride, a_d, col_stride, & ad_dot_ad, n_rows);
    check_ipp_status(status, __FILE__, __LINE__);

    // If ad_dot_ad is so small that the division produces an effectively infinite result exit from the loop
    float alpha = delta_new / ad_dot_ad;
    // TODO: unit test this path
    if (! _finite(alpha))
    {
      cerr << "infinite alpha" << endl;
      break;
    }

    // temp = alpha d
    status = ippmMul_vc_32f(d, col_stride, alpha, temp1, col_stride, n_cols);
    check_ipp_status(status, __FILE__, __LINE__);

    // temp2 = x + temp
    status = ippmAdd_vv_32f(est_x, col_stride, temp1, col_stride, temp2, col_stride, n_cols);
    check_ipp_status(status, __FILE__, __LINE__);

    // x = temp2 ... since IPP doesn't support in-place operations
    status = ippmCopy_va_32f_SS(temp2, vec_stride, col_stride, est_x, vec_stride, col_stride, n_cols, 1);
    check_ipp_status(status, __FILE__, __LINE__);
    //memcpy(est_x, temp2, col_bytes);

    ++i;

    // if we have exceed modulo(n_restart) iterations recalculate the residual
    if (i % n_restart)
    {
      // temp = alpha * q
      status = ippmMul_vc_32f(q, col_stride, alpha, temp1, col_stride, n_cols);
      check_ipp_status(status, __FILE__, __LINE__);

      // temp2 = r - temp
      status = ippmSub_vv_32f(r, col_stride, temp1, col_stride, temp2, col_stride, n_cols);
      check_ipp_status(status, __FILE__, __LINE__);

      // r = temp2
      status = ippmCopy_va_32f_SS(temp2, vec_stride, col_stride, r, vec_stride, col_stride, n_cols, 1);
      check_ipp_status(status, __FILE__, __LINE__);
      //memcpy(r, temp2, col_bytes);
    }
    else
    {
      // temp = Ax
      status = ippmMul_mv_32f(mat_A, step_bytes_A, col_stride, n_cols, n_rows,
                              est_x, col_stride, n_cols,
                              temp1, col_stride);
      check_ipp_status(status, __FILE__, __LINE__);

      // temp2 = A^T temp
      status = ippmMul_tv_32f(mat_A, step_bytes_A, col_stride, n_cols, n_rows,
                              temp1, col_stride, n_rows,
                              temp2, col_stride);
      check_ipp_status(status, __FILE__, __LINE__);

      // r = b_normal - temp2
      status = ippmSub_vv_32f(b_normal, col_stride, temp2, col_stride, r, col_stride, n_cols);
      check_ipp_status(status, __FILE__, __LINE__);
    }
    float delta_old = delta_new;

    // delta_new = r^T r
    status = ippmDotProduct_vv_32f(r, col_stride, r, col_stride, & delta_new, n_cols);
    check_ipp_status(status, __FILE__, __LINE__);

    float beta = delta_new / delta_old;
    // TODO: unit test this path
    if (! _finite(beta))
    {
      cerr << "infinite beta" << endl;
      break;
    }

    // temp = beta * d
    status = ippmMul_vc_32f(d, col_stride, beta, temp1, col_stride, n_cols);
    check_ipp_status(status, __FILE__, __LINE__);

    // d = r + temp
    status = ippmAdd_vv_32f(r, col_stride, temp1, col_stride, d, col_stride, n_cols);
    check_ipp_status(status, __FILE__, __LINE__);
  }

  return i;
}


int DenseCG::
solve_normal_eq_blas(float * est_x, int i_max, float epsilon)
{
  int col_stride = sizeof(float);
  int col_bytes = col_stride * n_cols;
  int vec_stride = max_elements * col_stride;

  // temp = Ax
  cblas_sgemv(CblasRowMajor, CblasNoTrans, n_rows, n_cols, 1.0F, mat_A, n_cols, est_x, 1, 0.0F, temp1, 1);

  // temp2 = A^T temp1
  cblas_sgemv(CblasRowMajor, CblasTrans, n_rows, n_cols, 1.0F, mat_A, n_cols, temp1, 1, 0.0F, temp2, 1);

  // Compute the normal equations right hand side A^Tb
  cblas_sgemv(CblasRowMajor, CblasTrans, n_rows, n_cols, 1.0F, mat_A, n_cols, b, 1, 0.0F, b_normal, 1);
  //print_array(b_normal, n_cols, "b_normal");

  // r = b_normal - temp2
  vsSub(n_cols, b_normal, temp2, r);
  //print_array(r, n_cols, "r");

  // d = r
  cblas_scopy(n_cols, r, 1, d, 1);

  // delta_new = r^T * r
  float delta_new;
  delta_new = cblas_sdot(n_cols, r, 1, r, 1);
  float delta_0 = delta_new;
  int i = 0;
  float epsilon_squared = epsilon * epsilon;
  while (i < i_max && delta_new > epsilon_squared * delta_0)
  {
    // ad = Ad
    cblas_sgemv(CblasRowMajor, CblasNoTrans, n_rows, n_cols, 1.0F, mat_A, n_cols, d, 1, 0.0F, a_d, 1);
    //print_array(a_d, n_rows, "ad");

    // q = A^T ad
    cblas_sgemv(CblasRowMajor, CblasTrans, n_rows, n_cols, 1.0F, mat_A, n_cols, a_d, 1, 0.0F, q, 1);
    //print_array(q, n_cols, "q");

    // ad_dot_ad = (Ad)^T  Ad
    float ad_dot_ad;
    ad_dot_ad = cblas_sdot(n_rows, a_d, 1, a_d, 1);
    //printf("ad_dot_ad: %f\n", ad_dot_ad);

    // If ad_dot_ad is so small that the division produces an effectively infinite result exit from the loop
    float alpha = delta_new / ad_dot_ad;
    //printf("alpha: %f\n", alpha);
    // TODO: unit test this path
    if (! _finite(alpha))
    {
      cerr << "infinite alpha" << endl;
      break;
    }

    // x = x + alpha d
    cblas_saxpy(n_cols, alpha, d, 1, est_x, 1);
    //print_array(est_x, n_cols, "x");
    ++i;

    // if we have exceed modulo(n_restart) iterations recalculate the residual
    if (i % n_restart)
    {
      // r = r - alpha * q
      cblas_saxpy(n_cols, -1.0F*alpha, q, 1, r, 1);
      //print_array(r, n_cols, "r");
    }
    else
    {
      // temp = Ax
      cblas_sgemv(CblasRowMajor, CblasNoTrans, n_rows, n_cols, 1.0F, mat_A, n_cols, est_x, 1, 0.0F, temp1, 1);

      // temp2 = A^T temp
      cblas_sgemv(CblasRowMajor, CblasTrans, n_rows, n_cols, 1.0F, mat_A, n_cols, temp1, 1, 0.0F, temp2, 1);

      // r = b_normal - temp2
      vsSub(n_cols, b_normal, temp2, r);
    }
    float delta_old = delta_new;

    // delta_new = r^T r
    delta_new = cblas_sdot(n_cols, r, 1, r, 1);

    float beta = delta_new / delta_old;
    // TODO: unit test this path
    if (! _finite(beta))
    {
      cerr << "infinite beta" << endl;
      break;
    }

    // d = r + beta * d
    cblas_saxpby(n_cols, 1.0, r, 1, beta, d, 1);
  }

  return i;
}
