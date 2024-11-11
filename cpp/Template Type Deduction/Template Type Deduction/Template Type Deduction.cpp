// Template Type Deduction.cpp : Defines the entry point for the console application.
//

#include "MyFunctionTemplate.h"


int main()
{
  float val = 1.0;
  func<double>(val);

  // IF the argument list does not specify
  float rv = templated_return_type<float>(val);

  return 0;
}

