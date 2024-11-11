#include <iostream>
#include <cmath>
//#include <boost/numeric/ublas/matrix.hpp>
//#include <boost/numeric/ublas/io.hpp>

#include "ipp.h"
#include "mkl.h"

#include "utilities.hpp"
#include "matlib.c"

using namespace std;
//using namespace boost::numeric::ublas;

int main(int argc, char * argv[])
{
  ippStaticInit();

  int ne = 512;
  int n_rows = ne;
  int n_cols = ne;
  int n_elem = n_rows * n_cols;
  // Create a pair of large random matrices in each library
  unsigned int seed = 1;
  int stride2 = sizeof(float);
  int stride1 = n_cols * stride2;

  LARGE_INTEGER start;
  double secs;

  Ipp32f * ipp_mat_x = ippsMalloc_32f(n_rows * n_cols);
  Ipp32f * ipp_mat_y = ippsMalloc_32f(n_rows * n_cols);
  Ipp32f * ipp_mat_z = ippsMalloc_32f(n_rows * n_cols);

  //for (int i = 0; i < n_elem; ++i) 
  //  ipp_mat_x[i] = i;

  //for (int i = 0; i < n_elem; ++i) 
  //  ipp_mat_y[i] = i + 1.0F;

  srand(1);
  random_matrix(ipp_mat_x, stride1, stride2, n_rows, n_cols);
  random_matrix(ipp_mat_y, stride1, stride2, n_rows, n_cols);
  //ippsRandUniform_Direct_32f(ipp_mat_x, n_rows * n_cols, -1.0F, 1.0F, & seed);
  //ippsRandUniform_Direct_32f(ipp_mat_y, n_rows * n_cols, -1.0F, 1.0F, & seed);

  start = get_performance_timer_time();
  ippmMul_mm_32f(ipp_mat_x, stride1, stride2, n_cols, n_rows,
                 ipp_mat_y, stride1, stride2, n_cols, n_rows,
                 ipp_mat_z, stride1, stride2);
  secs = get_performance_timer_elapsed_seconds(start);
  cout << "IPP matrix mult elapsed time: " << secs * 1000.0 << " ms" << endl;

  cout << "IPP X" << endl;
  print_matrix(ipp_mat_x, n_rows, n_cols, 4);

  cout << "IPP Y" << endl;
  print_matrix(ipp_mat_y, n_rows, n_cols, 4);

  cout << "IPP Z" << endl;
  print_matrix(ipp_mat_z, n_rows, n_cols, 4);

  //matrix<float> boost_max_x(n_rows, n_cols);
  //matrix<float> boost_max_y(n_rows, n_cols);
  //matrix<float> boost_max_z(n_rows, n_cols);

  //for (unsigned i = 0; i < boost_max_x.size1(); ++ i)
  //{
  //  for (unsigned j = 0; j < boost_max_x.size2(); ++ j)
  //  {
  //    boost_max_x(i, j) = ipp_mat_x[i * n_cols + j];
  //    boost_max_y(i, j) = ipp_mat_y[i * n_cols + j];
  //  }
  //}

  //start = get_performance_timer_time();
  //boost_max_z = prod(boost_max_x, boost_max_y);
  //secs = get_performance_timer_elapsed_seconds(start);
  //cout << "boost matrix mult elapsed time: " << secs * 1000.0 << " ms" << endl;

  int m = n_rows;
  int n = n_rows;
  int k = n_cols;
  float alpha = 1.0F;
  float beta = 0.0F;
  // Reset Z
  for (int i = 0; i < n_elem; ++i) 
    ipp_mat_z[i] = 0.0F;

  start = get_performance_timer_time();
  cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, 
    alpha, 
    ipp_mat_x, n_cols, 
    ipp_mat_y, n_cols, 
    beta, ipp_mat_z, n_cols);
  secs = get_performance_timer_elapsed_seconds(start);
  cout << "MKL matrix mult elapsed time: " << secs * 1000.0 << " ms" << endl;

  cout << "MKL Z" << endl;
  print_matrix(ipp_mat_z, n_rows, n_cols, 4);

  Matrix matlib_x;
  MatAlloc(& matlib_x, n_rows, n_cols);
  for (int i = 0; i < n_elem; ++i) 
    matlib_x.array[0][i] = ipp_mat_x[i];
  Matrix matlib_y;
  MatAlloc(& matlib_y, n_rows, n_cols);
  for (int i = 0; i < n_elem; ++i) 
    matlib_y.array[0][i] = ipp_mat_y[i];

  Matrix matlib_z;
  MatAlloc(& matlib_z, n_rows, n_cols);

  start = get_performance_timer_time();
  MatMult(matlib_x, matlib_y, matlib_z);
  secs = get_performance_timer_elapsed_seconds(start);
  cout << "MatLib matrix mult elapsed time: " << secs * 1000.0 << " ms" << endl;
  cout << "MatLib Z" << endl;
  print_matrix(matlib_z.array[0], n_rows, n_cols, 4);

  return 0;
}

