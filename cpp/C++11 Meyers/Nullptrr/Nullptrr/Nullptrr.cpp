// An example of the nullptr keyword, usefull both for code clarity and ensuring that an overloaded function
// requiring a pointer gets called

#include "stdafx.h"

using namespace std;


// Overload a function with calls from both an pointer and an int
void func(void * ptr)
{
  cout << "called from with pointer at: " << ptr << endl;
}


void func(int val)
{
  cout << "called from with integer at: " << val << endl;
}


int main(int argc, char * argv[])
{
  int * np = nullptr;
  func(np);
  func(0);
  func(NULL);

	return 0;
}
