#include <iostream>
#include "ipp.h"

#include "utilities.hpp"

using namespace std;

int main(int argc, char * argv[])
{
  Ipp32f v1[] = {1.0, 2.0, 3.0};
  int n1 = 3;

  Ipp32f v2[] = {1.0, 2.0, 3.0, 4.0, 5.0};
  int n2 =  5;

  int n3 = n1 + n2 - 1;
  Ipp32f * v3 = new Ipp32f[n3];
  ippsSet_32f(-1.0F, v3, 5 + 3 - 1);

  print_array(v1, n1);
  print_array(v2, n2);

  IppStatus status;

  ippsConv_32f(v1, n1, v2, n2, v3);
  cout << "full convolution" << endl;
  print_array(v3, n3);

  ippsSet_32f(-1.0F, v3, 5 + 3 - 1);
  int bias = 0;
  ippsConvBiased_32f(v1, n1, v2, n2, v3, n3, bias);
  cout << "biased convolution, bias = " << bias << endl;
  print_array(v3, n3);

  ippsSet_32f(-1.0F, v3, 5 + 3 - 1);
  bias = 1;
  ippsConvBiased_32f(v1, n1, v2, n2, v3, n3, bias);
  cout << "biased convolution, bias = " << bias << endl;
  print_array(v3, n3);

  ippsSet_32f(-1.0F, v3, 5 + 3 - 1);
  bias = 2;
  ippsConvBiased_32f(v1, n1, v2, n2, v3, n3, bias);
  cout << "biased convolution, bias = " << bias << endl;
  print_array(v3, n3);

  ippsSet_32f(-1.0F, v3, 5 + 3 - 1);
  bias = 3;
  ippsConvBiased_32f(v1, n1, v2, n2, v3, n3, bias);
  cout << "biased convolution, bias = " << bias << endl;
  print_array(v3, n3);

  ippsSet_32f(-1.0F, v3, 5 + 3 - 1);
  bias = 4;
  ippsConvBiased_32f(v1, n1, v2, n2, v3, n3, bias);
  cout << "biased convolution, bias = " << bias << endl;
  print_array(v3, n3);

  ippsSet_32f(-1.0F, v3, 5 + 3 - 1);
  bias = 5;
  ippsConvBiased_32f(v1, n1, v2, n2, v3, n3, bias);
  cout << "biased convolution, bias = " << bias << endl;
  print_array(v3, n3);

  return 0;
}

