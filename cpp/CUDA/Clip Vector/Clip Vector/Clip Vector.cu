#define _WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <Windows.h>

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda_profiler_api.h"

#include "Clip Vector.cuh"
#include <cstdio>

//template <typename float, typename int>

__global__ void clip_vector_kernel(float * vector, int n_elements, float low, float high)
{
  int idx = threadIdx.x + blockIdx.x * blockDim.x;
  if(idx < n_elements)
  {
    if (vector[idx] < low)
    {
      vector[idx] = low;
    }
    if (vector[idx] > high)
    {
      vector[idx] = high;
    }
  }
}


//template <typename float, typename int>
void clip_vector(float * vector, int n_elements, float low, float high)
{
  cudaError_t cuda_status;

  // Uncomment to use the nvidia profiler, also the profiler stop call down below
  cudaProfilerStart();

  // Allocate memory on the device
  float * d_vector;
  cuda_status = cudaMalloc((void **) & d_vector, n_elements * sizeof(float));
  if (cuda_status != cudaSuccess)
  {
    fprintf(stderr, "cudaMalloc returned error code %d before launching clip_vector_kernel!\n", cuda_status);
  }

  cuda_status = cudaMemcpy(d_vector,
                           vector,
                           n_elements * sizeof(float),
                           cudaMemcpyHostToDevice);
  if (cuda_status != cudaSuccess)
  {
    fprintf(stderr, "cudaMemcpy returned error code %d before launching clip_vector_kernel!\n", cuda_status);
  }

  // Launch a kernel on the GPU with one thread for each element.
  int n_threads_per_block = 256;
  int n_blocks = n_elements / n_threads_per_block;
  if (n_blocks * n_threads_per_block < n_elements)
  {
    n_blocks++;
  }
  LARGE_INTEGER start_time;
  QueryPerformanceCounter(&start_time);

  clip_vector_kernel<<<n_blocks, n_threads_per_block >>>(d_vector, n_elements, low, high);

  // cudaDeviceSynchronize waits for the kernel to finish, and returns
  // any errors encountered during the launch.
  cuda_status = cudaDeviceSynchronize();
  if (cuda_status != cudaSuccess)
  {
    fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching clip_vector_kernel!\n", cuda_status);
  }

  LARGE_INTEGER stop_time;
  QueryPerformanceCounter(&stop_time);
  LARGE_INTEGER frequency;
  QueryPerformanceFrequency(&frequency);
  auto period = stop_time.QuadPart - start_time.QuadPart;
  double period_secs = static_cast<double>(period) / frequency.QuadPart;
  printf("computation time (secs): %e\n", period_secs);

  cuda_status = cudaMemcpy(vector,
                           d_vector,
                           n_elements * sizeof(float),
                           cudaMemcpyDeviceToHost);
  if (cuda_status != cudaSuccess)
  {
    fprintf(stderr, "cudaMemcpy returned error code %d before launching clip_vector_kernel!\n", cuda_status);
  }

  // Uncomment to use the nvidia profiler
  cudaProfilerStop();
}


__global__ void clip_vector_nc_kernel(float * vector, int n_elements, float low, float high)
{
  int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if (vector[idx] < low)
    {
      vector[idx] = low;
    }
    if (vector[idx] > high)
    {
      vector[idx] = high;
    }
}


//template <typename float, typename int>
void clip_vector_nc(float * vector, int n_elements, float low, float high)
{
  cudaError_t cuda_status;

  // Uncomment to use the nvidia profiler, also the profiler stop call down below
  cudaProfilerStart();

  // Allocate memory on the device
  float * d_vector;
  cuda_status = cudaMalloc((void **)& d_vector, n_elements * sizeof(float));
  if (cuda_status != cudaSuccess)
  {
    fprintf(stderr, "cudaMalloc returned error code %d before launching clip_vector_kernel!\n", cuda_status);
  }

  cuda_status = cudaMemcpy(d_vector,
                           vector,
                           n_elements * sizeof(float),
                           cudaMemcpyHostToDevice);
  if (cuda_status != cudaSuccess)
  {
    fprintf(stderr, "cudaMemcpy returned error code %d before launching clip_vector_kernel!\n", cuda_status);
  }

  // Launch a kernel on the GPU with one thread for each element.
  int n_threads_per_block = 256;
  int n_blocks = n_elements / n_threads_per_block;
  if (n_blocks * n_threads_per_block < n_elements)
  {
    n_blocks++;
  }
  LARGE_INTEGER start_time;
  QueryPerformanceCounter(&start_time);

  clip_vector_nc_kernel << <n_blocks, n_threads_per_block >> >(d_vector, n_elements, low, high);

  // cudaDeviceSynchronize waits for the kernel to finish, and returns
  // any errors encountered during the launch.
  cuda_status = cudaDeviceSynchronize();
  if (cuda_status != cudaSuccess)
  {
    fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching clip_vector_kernel!\n", cuda_status);
  }

  LARGE_INTEGER stop_time;
  QueryPerformanceCounter(&stop_time);
  LARGE_INTEGER frequency;
  QueryPerformanceFrequency(&frequency);
  auto period = stop_time.QuadPart - start_time.QuadPart;
  double period_secs = static_cast<double>(period) / frequency.QuadPart;
  printf("computation time (secs): %e\n", period_secs);

  cuda_status = cudaMemcpy(vector,
                           d_vector,
                           n_elements * sizeof(float),
                           cudaMemcpyDeviceToHost);
  if (cuda_status != cudaSuccess)
  {
    fprintf(stderr, "cudaMemcpy returned error code %d before launching clip_vector_kernel!\n", cuda_status);
  }

  // Uncomment to use the nvidia profiler
  cudaProfilerStop();
}

//template <typename float, typename int>
__global__ void clip_vector_kernel2(float * vector, int n_elements, float low, float high)
{
  int idx_start = blockIdx.x * blockDim.x;
  int idx_stop = idx_start + blockDim.x;
  for (int idx = idx_start; idx < idx_stop; ++idx)
  {
    if (vector[idx] < low)
    {
      vector[idx] = low;
    }
    if (vector[idx] > high)
    {
      vector[idx] = high;
    }
  }
}


//template <typename float, typename int>
void clip_vector2(float * vector, int n_elements, float low, float high)
{
  cudaError_t cuda_status;

  // Uncomment to use the nvidia profiler, also the profiler stop call down below
  cudaProfilerStart();

  // Allocate memory on the device
  float * d_vector;
  cuda_status = cudaMalloc((void **)& d_vector, n_elements * sizeof(float));
  if (cuda_status != cudaSuccess)
  {
    fprintf(stderr, "cudaMalloc returned error code %d before launching clip_vector_kernel!\n", cuda_status);
  }

  cuda_status = cudaMemcpy(d_vector,
                           vector,
                           n_elements * sizeof(float),
                           cudaMemcpyHostToDevice);
  if (cuda_status != cudaSuccess)
  {
    fprintf(stderr, "cudaMemcpy returned error code %d before launching clip_vector_kernel!\n", cuda_status);
  }

  // Launch a kernel on the GPU with one thread for each element.
  int n_threads_per_block = 256;
  int n_blocks = n_elements / n_threads_per_block;
  if (n_blocks * n_threads_per_block < n_elements)
  {
    n_blocks++;
  }
  LARGE_INTEGER start_time;
  QueryPerformanceCounter(&start_time);

  clip_vector_kernel2<<<n_blocks, n_threads_per_block >>>(d_vector, n_elements, low, high);

  // cudaDeviceSynchronize waits for the kernel to finish, and returns
  // any errors encountered during the launch.
  cuda_status = cudaDeviceSynchronize();
  if (cuda_status != cudaSuccess)
  {
    fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching clip_vector_kernel!\n", cuda_status);
  }

  LARGE_INTEGER stop_time;
  QueryPerformanceCounter(&stop_time);
  LARGE_INTEGER frequency;
  QueryPerformanceFrequency(&frequency);
  auto period = stop_time.QuadPart - start_time.QuadPart;
  double period_secs = static_cast<double>(period) / frequency.QuadPart;
  printf("computation time (secs): %e\n", period_secs);

  cuda_status = cudaMemcpy(vector,
                           d_vector,
                           n_elements * sizeof(float),
                           cudaMemcpyDeviceToHost);
  if (cuda_status != cudaSuccess)
  {
    fprintf(stderr, "cudaMemcpy returned error code %d before launching clip_vector_kernel!\n", cuda_status);
  }
  // Uncomment to use the nvidia profiler
  cudaProfilerStop();
}

//template void clip_vector<float, int>(float * vector, int n_elements, float low, float high);
//template void clip_vector<float, __int64>(float * vector, __int64 n_elements, float low, float high);
//template void clip_vector2<float, int>(float * vector, int n_elements, float low, float high);
//template void clip_vector2<float, __int64>(float * vector, __int64 n_elements, float low, float high);
