
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <memory>
#include <stdio.h>
#include <vector>
#include "mkl_spblas.h"

using namespace std;

cudaError_t addWithCuda(int * c, const int * a, const int * b, unsigned int size);

__global__ void addKernel(int * c, const int * a, const int * b)
{
  int i = threadIdx.x;
  c[i] = a[i] + b[i];
}


template <typename T>
struct CompressedCoordinateSparseMatrix
{
  int m;
  int n;
  unique_ptr<vector<T>> data;
  unique_ptr<vector<int>> row_index;
  unique_ptr<vector<int>> column_index;

  CompressedCoordinateSparseMatrix(int m, int n, int n_non_zero_hint) :
    m(m),
    n(n),
    data(new vector<T>(n_non_zero_hint)),
    row_index(new vector<int>(n_non_zero_hint)),
    column_index(new vector<int>(n_non_zero_hint))
  {

  }

  ~CompressedCoordinateSparseMatrix()
  {
  }

  void add(int row, int column, T value)
  {
    data->push_back(value);
    row_index->push_back(row);
    column_index->push_back(column);
  }

  int get_nnz()
  {
    return static_cast<int>(data->size());
  }

};


void print_mkl_error(sparse_status_t status)
{
  switch (status)
  {
    case SPARSE_STATUS_NOT_INITIALIZED:
      printf("SPARSE_STATUS_NOT_INITIALIZED\n");
      break;
    case SPARSE_STATUS_ALLOC_FAILED:
      printf("SPARSE_STATUS_ALLOC_FAILED\n");
      break;
    case SPARSE_STATUS_INVALID_VALUE:
      printf("SPARSE_STATUS_INVALID_VALUE\n");
      break;
    case SPARSE_STATUS_EXECUTION_FAILED:
      printf("SPARSE_STATUS_EXECUTION_FAILED\n");
      break;
    case SPARSE_STATUS_INTERNAL_ERROR:
      printf("SPARSE_STATUS_INTERNAL_ERROR\n");
      break;
    case SPARSE_STATUS_NOT_SUPPORTED:
      printf("SPARSE_STATUS_NOT_SUPPORTED\n");
      break;
    default:
      printf("Unknown MKL error: %d\n", status);
  }

}


int main()
{
  // Create a simple sparse identity matrix
  auto coo_eye = CompressedCoordinateSparseMatrix<float>(5, 5, 5);
  coo_eye.add(0, 0, 1.0F);
  coo_eye.add(1, 1, 1.0F);
  coo_eye.add(2, 2, 1.0F);
  coo_eye.add(3, 3, 1.0F);
  coo_eye.add(4, 4, 1.0F);

  sparse_status_t status;
  sparse_matrix_t A;
  status = mkl_sparse_s_create_coo(& A,
                                   SPARSE_INDEX_BASE_ZERO,
                                   coo_eye.m,
                                   coo_eye.n,
                                   coo_eye.get_nnz(),
                                   & (*coo_eye.row_index.get())[0],
                                   & (*coo_eye.column_index.get())[0],
                                   & (*coo_eye.data.get())[0]);

  if (status == SPARSE_STATUS_SUCCESS)
  {
    printf("Created MKL sparse COO array\n");
  }
  else
  {
    print_mkl_error(status);
    exit(-1);
  }

  // Convert the array to CSR
  sparse_matrix_t A_csr;
  status = mkl_sparse_convert_csr(A, SPARSE_OPERATION_NON_TRANSPOSE, &A_csr);
  if (status == SPARSE_STATUS_SUCCESS)
  {
    printf("Created MKL sparse CSR array\n");
  }
  else
  {
    print_mkl_error(status);
    exit(-1);
  }

  sparse_index_base_t index_base;
  int n_rows;
  int n_cols;
  int * rows_start;
  int * rows_end;
  int * col_indx;
  float * values;
  status = mkl_sparse_s_export_csr(A_csr,
                                   & index_base,
                                   & n_rows,
                                   & n_cols,
                                   & rows_start,
                                   & rows_end,
                                   & col_indx,
                                   & values);

  if (status == SPARSE_STATUS_SUCCESS)
  {
    printf("Exported MKL sparse CSR array\n");
  }
  else
  {
    print_mkl_error(status);
    exit(-1);
  }
  if (index_base != SPARSE_INDEX_BASE_ZERO)
  {
    printf("Warning 1 based indexing returned, expected 0 based.\n");
  }

  printf("%d x %d\n", n_rows, n_cols);
  printf("rows_start: ");
  for (int i = 0; i < n_rows; i++)
  {
    printf("%d, ", rows_start[i]);
  }
  printf("\n");

  printf("rows_end: ");
  for (int i = 0; i < n_rows; i++)
  {
    printf("%d, ", rows_end[i]);
  }
  printf("\n");

  int nnz = rows_end[n_rows - 1] - rows_start[0];

  printf("col_idx: ");
  for (int i = 0; i < nnz; i++)
  {
    printf("%d, ", col_indx[i]);
  }
  printf("\n");

  printf("values: ");
  for (int i = 0; i < nnz; i++)
  {
    printf("%f, ", values[i]);
  }
  printf("\n");


  // Allocate the necessary elements of a Compressed Sparse
  const int arraySize = 5;
  const int a[arraySize] = { 1, 2, 3, 4, 5 };
  const int b[arraySize] = { 10, 20, 30, 40, 50 };
  int c[arraySize] = { 0 };

  // Add vectors in parallel.
  cudaError_t cudaStatus = addWithCuda(c, a, b, arraySize);
  if (cudaStatus != cudaSuccess)
  {
    fprintf(stderr, "addWithCuda failed!");
    return 1;
  }

  printf("{1,2,3,4,5} + {10,20,30,40,50} = {%d,%d,%d,%d,%d}\n",
         c[0], c[1], c[2], c[3], c[4]);

  // cudaDeviceReset must be called before exiting in order for profiling and
  // tracing tools such as Nsight and Visual Profiler to show complete traces.
  cudaStatus = cudaDeviceReset();
  if (cudaStatus != cudaSuccess)
  {
    fprintf(stderr, "cudaDeviceReset failed!");
    return 1;
  }

  return 0;
}


// Helper function for using CUDA to add vectors in parallel.
cudaError_t addWithCuda(int * c, const int * a, const int * b, unsigned int size)
{
  int * dev_a = 0;
  int * dev_b = 0;
  int * dev_c = 0;
  cudaError_t cudaStatus;

  // Choose which GPU to run on, change this on a multi-GPU system.
  cudaStatus = cudaSetDevice(0);
  if (cudaStatus != cudaSuccess)
  {
    fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
    goto Error;
  }

  // Allocate GPU buffers for three vectors (two input, one output)    .
  cudaStatus = cudaMalloc((void **)&dev_c, size * sizeof(int));
  if (cudaStatus != cudaSuccess)
  {
    fprintf(stderr, "cudaMalloc failed!");
    goto Error;
  }

  cudaStatus = cudaMalloc((void **)&dev_a, size * sizeof(int));
  if (cudaStatus != cudaSuccess)
  {
    fprintf(stderr, "cudaMalloc failed!");
    goto Error;
  }

  cudaStatus = cudaMalloc((void **)&dev_b, size * sizeof(int));
  if (cudaStatus != cudaSuccess)
  {
    fprintf(stderr, "cudaMalloc failed!");
    goto Error;
  }

  // Copy input vectors from host memory to GPU buffers.
  cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
  if (cudaStatus != cudaSuccess)
  {
    fprintf(stderr, "cudaMemcpy failed!");
    goto Error;
  }

  cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
  if (cudaStatus != cudaSuccess)
  {
    fprintf(stderr, "cudaMemcpy failed!");
    goto Error;
  }

  // Launch a kernel on the GPU with one thread for each element.
  addKernel <<< 1, size>>>(dev_c, dev_a, dev_b);

  // Check for any errors launching the kernel
  cudaStatus = cudaGetLastError();
  if (cudaStatus != cudaSuccess)
  {
    fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
    goto Error;
  }

  // cudaDeviceSynchronize waits for the kernel to finish, and returns
  // any errors encountered during the launch.
  cudaStatus = cudaDeviceSynchronize();
  if (cudaStatus != cudaSuccess)
  {
    fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
    goto Error;
  }

  // Copy output vector from GPU buffer to host memory.
  cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);
  if (cudaStatus != cudaSuccess)
  {
    fprintf(stderr, "cudaMemcpy failed!");
    goto Error;
  }

Error:
  cudaFree(dev_c);
  cudaFree(dev_a);
  cudaFree(dev_b);

  return cudaStatus;
}
