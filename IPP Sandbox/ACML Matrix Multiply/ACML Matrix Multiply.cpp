#include <iostream>
//#include <boost/numeric/ublas/matrix.hpp>
//#include <boost/numeric/ublas/io.hpp>

#include "ipp.h"
#include "acml.h"

#include "utilities.hpp"
#include "matlib.c"

using namespace std;

int main(int argc, char * argv[])
{
  ippStaticInit();

  int ne = 256;
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

  int acml_major;
  int acml_minor;
  int acml_patch;
  int acml_build;
  acmlversion(& acml_major, & acml_minor, & acml_patch, & acml_build);
  cout << "ACML: " << acml_major << "." << acml_minor << "." << acml_patch << "-" << acml_build << endl;
  int m = n_rows;
  int n = n_rows;
  int k = n_cols;
  float alpha = 1.0F;
  float beta = 0.0F;
  // Reset Z
  for (int i = 0; i < n_elem; ++i) 
    ipp_mat_z[i] = 0.0F;

  start = get_performance_timer_time();
  sgemm('T', 'T', m, n, k, alpha, ipp_mat_x, m, ipp_mat_y, k, beta, ipp_mat_z, m);
  secs = get_performance_timer_elapsed_seconds(start);
  cout << "ACML matrix mult elapsed time: " << secs * 1000.0 << " ms" << endl;

  cout << "ACML X" << endl;
  print_matrix(ipp_mat_x, n_rows, n_cols, 4);

  cout << "ACML Y" << endl;
  print_matrix(ipp_mat_y, n_rows, n_cols, 4);

  cout << "ACML Z" << endl;
  print_matrix(ipp_mat_z, n_rows, n_cols, 4);

  return 0;
}

