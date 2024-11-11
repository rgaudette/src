#include <iostream>
#include <sstream>
#include <eh.h>
#include <windows.h>
#include "mkl.h"

using namespace std;

class SE_Exception
{
private:
  unsigned int nSE;
public:
  SE_Exception() {}
  SE_Exception( unsigned int n ) : nSE( n ) {}
  ~SE_Exception() {}
  unsigned int getSeNumber() { return nSE; }
};

void sehToCppException(unsigned int exceptionValue, EXCEPTION_POINTERS * pExp)
{
  std::stringstream exception_value_str;
  exception_value_str << "Exception value: ";
  exception_value_str << "0x" << std::hex << exceptionValue;
  std::cerr << exception_value_str.str() << std::endl;
  std::cerr << "Address: " << pExp->ExceptionRecord->ExceptionAddress << std::endl;
  throw SE_Exception();
}

float read_past_end(float * array, int length)
{
  float sum = 0.0F;
  for (int i = 0; i <= length*10000; i++)
  {
    sum += array[i];
  }
  return sum;
}


int main(int argc, char * argv[])
{

  int nColumns = 100;
  float alpha = 2.3F;
  float * x = new float[nColumns];
  for (int i = 0; i < nColumns; i++)
  {
    x[i] = 1.0F;
  }

  // The try appears necessary, without it the translator does not get called.
  //_set_se_translator(sehToCppException);
  try
  {
    float * value_at_zero = 0;
    std::cout << "value at zero: " << (* value_at_zero) << endl;
 	  float ret = read_past_end(x, nColumns);
	  std::cout << "sum: " << ret << std::endl;
  }
  catch (SE_Exception* e)
  {
  	cerr << "caught SE_Exception" << endl;
  }
  
  
  float * y = new float[nColumns];
  for (int i = 0; i < nColumns + 1; i++)
  {
    y[i] = 2.0F;
  }

  // x = x + alpha d
  cblas_saxpy(nColumns, alpha, x, 1, y, 1);
 	//eturn 0;
}

