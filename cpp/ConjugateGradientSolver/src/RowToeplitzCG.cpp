#include "RowToeplitzCG.h"
#include <iostream>
#include <limits>
#include <string.h>

#include "utilities.hpp"
#include "ipp.h"
#include "mkl.h"

using namespace std;

RowToeplitzCG::
RowToeplitzCG(int nrm, int nim, int n_restart) :
  n_rows_max(nrm),
  n_impulse_max(nim),
  n_restart(n_restart)
{
  int n_cols_max = n_rows_max + n_impulse_max - 1;

  // column dimension vectors
  d = static_cast<float *>(mkl_malloc(n_cols_max * sizeof(float), 64));
  q = static_cast<float *>(mkl_malloc(n_cols_max * sizeof(float), 64));
  r = static_cast<float *>(mkl_malloc(n_cols_max * sizeof(float), 64));
  b_normal = static_cast<float *>(mkl_malloc(n_cols_max * sizeof(float), 64));
  temp1 = static_cast<float *>(mkl_malloc(n_cols_max * sizeof(float), 64));

  // A large vector to handle the ends of the convolution vector
  int n_large_vec = n_cols_max + n_impulse_max - 1;
  temp2 = static_cast<float *>(mkl_malloc(n_large_vec * sizeof(float), 64));

  // RJG only for testing memory bounds
  for (int i = 0; i < n_cols_max; ++i) d[i] = -42;
  for (int i = 0; i < n_cols_max; ++i) q[i] = -42;
  for (int i = 0; i < n_cols_max; ++i) r[i] = -42;
  for (int i = 0; i < n_cols_max; ++i) temp1[i] = -42;
  for (int i = 0; i < n_cols_max; ++i) b_normal[i] = -42;

  for (int i = 0; i < n_large_vec; ++i) temp2[i] = -42;
}


RowToeplitzCG::
~RowToeplitzCG(void)
{
  mkl_free(d);
  mkl_free(q);
  mkl_free(r);
  mkl_free(b_normal);
  mkl_free(temp1);

  mkl_free(temp2);
}

int RowToeplitzCG::solve_normal_eq(const float * row,
                                   int n_row_elements,
                                   int n_rows,
                                   const float * b,
                                   float * est_x,
                                   int i_max,
                                   float epsilon)
{
  const int n_cols = n_row_elements + n_rows - 1;
  const int row_convolution_offset = n_row_elements - 1;
  // assumption:: the row is an even function about it's center so that we don't have to reverse it for the row toeplitz
  // matrix-vector multiplies implemented by convolution
  updateResidual(row, n_row_elements, n_rows, est_x, n_cols, b);

  print_array(r, n_cols, "r");

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
    // a_d = Ad,   a_d = temp2[n_row_elements - 1 : n_rows + n_row_elements - 1]
    print_array(row, n_row_elements, "row");
    print_array(d, n_cols, "d");
    ippsConv_32f(row, n_row_elements, d, n_cols, temp2);
    print_array(temp2, n_rows_max + 2 * n_impulse_max - 2, "temp2"); 
    a_d = temp2 + row_convolution_offset;
    print_array(a_d, n_rows, "a_d");

    // q = A^T ad
    ippsConv_32f(row, n_row_elements, a_d, n_rows, q);
    print_array(q, n_cols, "q");

    // ad_dot_ad = (Ad)^T  Ad
    float ad_dot_ad;
    ad_dot_ad = cblas_sdot(n_rows, a_d, 1, a_d, 1);
    printf("ad_dot_ad: %f\n", ad_dot_ad);

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
    print_array(est_x, n_cols, "x");
    ++i;

    // if we have exceed modulo(n_restart) iterations recalculate the residual
    if (i % n_restart)
    {
      // r = r - alpha * q
      cblas_saxpy(n_cols, -1.0F * alpha, q, 1, r, 1);
      print_array(r, n_cols, "r");
    }
    else
    {
      updateResidual(row, n_row_elements, n_rows, est_x, n_cols, b);
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

void RowToeplitzCG::updateResidual(const float * row, 
                                   int n_row_elements, 
                                   int n_rows, 
                                   float * est_x, 
                                   int n_cols, 
                                   const float * b)
{
  // temp2[n_row_elements - 1:] = Ax
  ippsConv_32f(row, n_row_elements, est_x, n_cols, temp2);

  // temp1 = b - temp2
  vsSub(n_cols, b, temp2 + n_row_elements - 1, temp1);

  // r = A^T temp1
  ippsConv_32f(row, n_row_elements, temp1, n_rows, r);
}
