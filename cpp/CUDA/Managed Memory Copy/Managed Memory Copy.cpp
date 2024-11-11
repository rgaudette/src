#include <iostream>
#include "cuda_runtime.h"
#include "helper_cuda.h"


int main(int argc, char ** argv)
{
  using T = float;
  using namespace std;
  int n_volume = 4;
  T * buffer_0;
  T * buffer_1;
  size_t bytes = 0;
  bytes += size_t(n_volume) * sizeof(T);
  cout << "Attempting to allocate buffer_0: " << size_t(n_volume) * sizeof(T)
    << " bytes, total: " << bytes << endl;
  checkCudaErrors(cudaMallocManaged((void **)& buffer_0, n_volume * sizeof(T)));
  printf("buffer_0: %p\n", buffer_0);

  cout << "Attempting to allocate buffer_1: " << size_t(n_volume) * sizeof(T)
    << " bytes, total: " << bytes << endl;
  checkCudaErrors(cudaMallocManaged((void **)& buffer_1, n_volume * sizeof(T)));
  printf("buffer_1: %p\n", buffer_1);

  for (int idx = 0; idx < n_volume; ++idx)
  {
    buffer_0[idx] = idx;
  }

  checkCudaErrors(cudaMemcpy(buffer_1, buffer_0, n_volume * sizeof(T), cudaMemcpyDefault));

  for (int idx = 0; idx < n_volume; ++idx)
  {
    cout << buffer_1[idx] << endl;
  }
}