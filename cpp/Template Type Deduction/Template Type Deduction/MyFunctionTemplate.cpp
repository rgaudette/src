#pragma once

#include <iostream>

template <typename T>
void func(T arg)
{
  std::cout << arg << std::endl;
}

template void func<double>(double arg);

template <typename T>
T templated_return_type(double val)
{
  // Convert the value the specified type
  return T(val);
}

template float templated_return_type<float>(double val);
template double templated_return_type<double>(double val);
