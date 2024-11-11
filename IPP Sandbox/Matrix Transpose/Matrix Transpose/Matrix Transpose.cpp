#include "ipp.h"

#include <cstdio>
#include <iostream>

using namespace std;

void print_matrix(float * matrix, int n_rows, int n_cols)
{
  for (int i = 0; i < n_rows; ++i)
  {
    for (int j = 0; j < n_cols; ++j)
    {
      printf("%f, ", matrix[i * n_cols + j]);
    }
    printf("\n");
  }
}

int main(int argc, char * argv[])
{
  int n_elem = 3;
  Ipp32f * identity = new Ipp32f[n_elem * n_elem];
  size_t stride_2 = sizeof(Ipp32f);
  size_t stride_1 = n_elem * stride_2;
  size_t stride_0 = n_elem * stride_1;
  IppStatus status;
  status = ippmLoadIdentity_ma_32f(identity, stride_0, stride_1, stride_2, n_elem, n_elem, 1);

  cout << "Identity: " << endl;
  print_matrix(identity, n_elem, n_elem);
  cout << endl;

  Ipp32f * indexed = new Ipp32f[n_elem * n_elem];

  for (int i = 0; i < n_elem * n_elem; ++i)
  {
    indexed[i] = i;
  }

  cout << "indexed: " << endl;
  print_matrix(indexed, n_elem, n_elem);
  cout << endl;

  Ipp32f * product = new Ipp32f[n_elem * n_elem];

  status = ippmMul_mm_32f(indexed, stride_1, stride_2, n_elem, n_elem,
                          identity, stride_1, stride_2, n_elem, n_elem,
                          product, stride_1, stride_2);

  cout << "product: " << endl;
  print_matrix(product, n_elem, n_elem);
  cout << endl;

  Ipp32f * transposed_product = new Ipp32f[n_elem * n_elem];

  status = ippmMul_tm_32f(indexed, stride_1, stride_2, n_elem, n_elem,
    identity, stride_1, stride_2, n_elem, n_elem,
    transposed_product, stride_1, stride_2);

  cout << "transposed_product: " << endl;
  print_matrix(transposed_product, n_elem, n_elem);
  cout << endl;


  return 0;
}

