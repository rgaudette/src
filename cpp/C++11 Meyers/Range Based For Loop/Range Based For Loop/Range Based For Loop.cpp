// Range Based For Loop.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

using namespace std;

template <typename T>
void container_print(T container)
{
  cout << "[ ";
  for (auto e : container)
  {
    cout << e << ", ";
  }
  cout << "]" << endl;
}


int main(int argc, char * argv[])
{
  vector<int> v1{ 1, 2, 3};

  container_print(v1);

  // neat, better than the java simplified for loop, at least the value of the elements can be changed
  // is there any way to get indices, customize stepping, or get an iterator???
  for (auto & e : v1)
  {
    ++e;
  }

  container_print(v1);

  return 0;
}
