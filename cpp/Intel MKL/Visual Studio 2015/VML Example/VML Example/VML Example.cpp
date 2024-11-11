#include <mkl.h>
#include <iostream>

using namespace std;

int main(int argc, char * argv[])
{
  float * v1 = new float[128];
  float * v2 = new float[128];
  float * vT = new float[128];
  vsSub(128, v1, v2, vT);

  size_t zero_bytes = 0;
  void * empty_alloc = mkl_malloc(zero_bytes, 64);
  cout << "empty alloc: " << empty_alloc << endl;

  size_t huge_bytes = 1 << 40;
  void * huge_alloc = mkl_malloc(huge_bytes, 64);
  cout << "huge_alloc: " << huge_alloc << endl;

  return 0;
}
