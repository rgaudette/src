// Return Value Optimization.cpp : Defines the entry point for the console application.
//
#include <iostream>

using namespace std;

struct AType {
  int an_int;
  AType(int arg) : an_int(arg) { };
  AType(AType const & arg) 
  { 
    this->an_int = arg.an_int;
    cout << "making a copy" << endl;
  }
  ~AType()
  {
    cout << "destroying AType" << endl;
  }
};

AType a_func(void)
{
  cout << "In a_func" << endl;
  AType a_type(3);
  return a_type;
}

void another_func(void)
{
  cout << "In another_func" << endl;
  AType returned_value = a_func();

}
int main(int argc, char * argv[])
{
  another_func();

	return 0;
}

