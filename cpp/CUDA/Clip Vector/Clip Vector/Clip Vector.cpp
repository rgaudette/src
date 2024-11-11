
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <cstdlib>
#include <stdio.h>
#include "Clip Vector.cuh"

int main()
{
  const int n_elements = 100 * 1024 * 1024;
  float * vector = new float[n_elements];
  for (int i = 0; i < n_elements; ++i)
  {
    vector[i] = (float)rand() / RAND_MAX;
  }
  float low = 0.2;
  float high = 0.4;

//  for (int i = 0; i < n_elements; ++i)
//  {
//    printf("%f, ", vector[i]);
//  }
//  printf("\n");

  clip_vector(vector, n_elements, low, high);

  for (int i = 0; i < n_elements; ++i)
  {
    if (vector[i] < low)
    {
      printf("%d %f\n", i, vector[i]);
    }
    if (vector[i] > high)
    {
      printf("%d %f\n", i, vector[i]);
    }
  }
  printf("\n");


  for (int i = 0; i < n_elements; ++i)
  {
    vector[i] = (float)rand() / RAND_MAX;
  }

  clip_vector_nc(vector, n_elements, low, high);

  for (int i = 0; i < n_elements; ++i)
  {
    if (vector[i] < low)
    {
      printf("%d %f\n", i, vector[i]);
    }
    if (vector[i] > high)
    {
      printf("%d %f\n", i, vector[i]);
    }
  }
  printf("\n");


//  for (int i = 0; i < n_elements; ++i)
//  {
//    vector[i] = (float)rand() / RAND_MAX;
//  }
//
//  clip_vector2(vector, n_elements, low, high);
//
//  for (int i = 0; i < n_elements; ++i)
//  {
//    if(vector[i] < low)
//    {
//      printf("%d %f\n", i, vector[i]);
//    }
//    if (vector[i] > high)
//    {
//      printf("%d %f\n", i, vector[i]);
//    }
//  }
//  printf("\n");
//
//  // cudaDeviceReset must be called before exiting in order for profiling and
//  // tracing tools such as Nsight and Visual Profiler to show complete traces.
//  cudaError_t cudaStatus = cudaDeviceReset();
//  if (cudaStatus != cudaSuccess)
//  {
//    fprintf(stderr, "cudaDeviceReset failed!");
//    return 1;
//  }

  return 0;
}

