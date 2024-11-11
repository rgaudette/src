// Memory allocate examples with new & delete
//
#include <cstdio>
#include <iostream>

using namespace std;

struct MyClass
{
  MyClass()
  {
    printf("MyClass at: %p created created\n", this);
  }

  ~MyClass()
  {
    printf("MyClass at: %p destroyed\n", this);
  }
};


int main(int argc, char* argv[])

{
  int * pointer;

  // Using the default debug configuration this will cause a run time error
#ifndef _DEBUG
  printf("Unallocated Pointer : %p\n", pointer);
#endif


	printf("Allocating and deleting with delete[] an array of ints\n");
  pointer = new int[10];
  printf("Allocated pointer : %p\n", pointer);
  delete[] pointer;
  printf("Deleted pointer : %p\n", pointer);
  pointer = NULL;
  printf("Nulled pointer : %p\n", pointer);

  printf("Allocating and deleting with delete an array of ints\n");
  pointer = new int[10];
  printf("Allocated pointer : %p\n", pointer);
  delete pointer;
  printf("Deleted pointer : %p\n", pointer);

  // Single instance of MyClass
  printf("Creating and destroying with delete[] a single instance of MyClass\n");
  MyClass * my_instance = new MyClass;
  delete my_instance;

  // This will cause a debug assertion but will run fine, leaking memory in the Release configuration
  printf("Creating and destroying with delete an array of instances of MyClass\n");
  int n_instances = 3;
  MyClass * my_class = new MyClass[n_instances];
  delete my_class;

  return 0;
}

