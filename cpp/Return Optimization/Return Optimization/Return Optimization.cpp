#include <cstdio>
#include <vector>

using namespace std;


vector<int> vector_return(int n)
{
  // This is created on the stack can it be returned without copying it
  vector<int> v;
  for (int i = 0; i < n; i++)
  {
    v.push_back(i);
  }
  printf("vector_return vector address: %p\n", &v);
  printf("vector_return vector data address: %p\n", v.data());

  return v;
}


struct my_struct
{
  vector<int> v;
};


my_struct my_struct_return(int n)
{
  // This is created on the stack can it be returned without copying it

  my_struct ms;
  for (int i = 0; i < n; i++)
  {
    ms.v.push_back(i);
  }
  printf("my_struct address: %p\n", & ms);
  printf("vector_return vector address: %p\n", & ms.v);
  printf("vector_return vector data address: %p\n", ms.v.data());

  return ms;
}


int main()
{
  auto vr = vector_return(100000);
  printf("main vector address: %p\n", &vr);
  printf("main vector data address: %p\n", vr.data());

  auto msr = my_struct_return(100000);
  printf("my_struct address: %p\n", &msr);
  printf("vector_return vector address: %p\n", &msr.v);
  printf("vector_return vector data address: %p\n", msr.v.data());
}

