#include <iostream>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include "cusparse.h"

#include "helper_cuda.h"

int main()
{
  using namespace std;
  using precision = float;

  // Create the 0 based general matrix descriptor
  cusparseHandle_t cuSparse_handle;
  checkCudaErrors(cusparseCreate(&cuSparse_handle));
  cusparseMatDescr_t descriptor_general_0;
  checkCudaErrors(cusparseCreateMatDescr(&descriptor_general_0));
  checkCudaErrors(cusparseSetMatType(descriptor_general_0, CUSPARSE_MATRIX_TYPE_GENERAL));
  checkCudaErrors(cusparseSetMatIndexBase(descriptor_general_0, CUSPARSE_INDEX_BASE_ZERO));
  checkCudaErrors(cusparseSetPointerMode(cuSparse_handle, CUSPARSE_POINTER_MODE_HOST));

  // Create a square sparse CSR matrix representation on the CUDA device
  int square_n_rows = 3;
  int square_n_columns = 3;
  int square_nnz = 9;

  precision * square_values;
  int * square_column_idx;
  int * square_row_ptr;
  checkCudaErrors(cudaMallocManaged((void **)& square_values, square_nnz * sizeof(precision)));
  checkCudaErrors(cudaMallocManaged((void **)& square_column_idx, square_nnz * sizeof(int)));
  for (int idx = 0; idx < square_nnz; ++idx)
  {
    square_values[idx] = precision(idx);
    square_column_idx[idx] = idx % square_n_columns;
  }

  checkCudaErrors(cudaMallocManaged((void **)& square_row_ptr, (square_n_rows + 1) * sizeof(int)));
  for (int idx = 0; idx < square_n_rows; ++idx)
  {
    square_row_ptr[idx] = idx * square_n_columns;
  }
  square_row_ptr[square_n_rows] = square_n_rows * square_n_columns;

  precision * square_transpose_values;
  int * square_transpose_column_idx;
  int * square_transpose_row_ptr;
  checkCudaErrors(cudaMallocManaged((void **)& square_transpose_values, square_nnz * sizeof(precision)));
  checkCudaErrors(cudaMallocManaged((void **)& square_transpose_column_idx, square_nnz * sizeof(int)));
  checkCudaErrors(cudaMallocManaged((void **)& square_transpose_row_ptr, (square_n_rows + 1) * sizeof(int)));

  // Compute the transpose of A placing the result in A_T
  checkCudaErrors(cusparseScsr2csc(cuSparse_handle,
                                   square_n_rows,
                                   square_n_columns,
                                   square_nnz,
                                   square_values,
                                   square_row_ptr,
                                   square_column_idx,
                                   square_transpose_values,
                                   square_transpose_column_idx,
                                   square_transpose_row_ptr,
                                   cusparseAction_t::CUSPARSE_ACTION_NUMERIC,
                                   cusparseIndexBase_t::CUSPARSE_INDEX_BASE_ZERO));
  checkCudaErrors(cudaDeviceSynchronize());

  cout << "square transpose values:" << endl;
  for (int idx = 0; idx < square_nnz; ++idx)
  {
    cout << square_transpose_values[idx] << " ";
  }
  cout << endl;

  cout << "square transpose column indices:" << endl;
  for (int idx = 0; idx < square_nnz; ++idx)
  {
    cout << square_transpose_column_idx[idx] << " ";
  }
  cout << endl;

  cout << "square transpose row ptrs:" << endl;
  for (int idx = 0; idx < square_n_columns + 1; ++idx)
  {
    cout << square_transpose_row_ptr[idx] << " ";
  }
  cout << endl;

  // Create a wide sparse CSR matrix representation on the CUDA device
  int wide_n_rows = 3;
  int wide_n_columns = 4;
  int wide_nnz = 12;

  precision * wide_values;
  int * wide_column_idx;
  int * wide_row_ptr;
  checkCudaErrors(cudaMallocManaged((void **)& wide_values, wide_nnz * sizeof(precision)));
  checkCudaErrors(cudaMallocManaged((void **)& wide_column_idx, wide_nnz * sizeof(int)));
  for (int idx = 0; idx < wide_nnz; ++idx)
  {
    wide_values[idx] = precision(idx);
    wide_column_idx[idx] = idx % wide_n_columns;
  }

  checkCudaErrors(cudaMallocManaged((void **)& wide_row_ptr, (wide_n_rows + 1) * sizeof(int)));
  for (int idx = 0; idx < wide_n_rows; ++idx)
  {
    wide_row_ptr[idx] = idx * wide_n_columns;
  }
  wide_row_ptr[wide_n_rows] = wide_n_rows * wide_n_columns;

  precision * wide_transpose_values;
  int * wide_transpose_column_idx;
  int * wide_transpose_row_ptr;
  checkCudaErrors(cudaMallocManaged((void **)& wide_transpose_values, wide_nnz * sizeof(precision)));
  checkCudaErrors(cudaMallocManaged((void **)& wide_transpose_column_idx, wide_nnz * sizeof(int)));
  checkCudaErrors(cudaMallocManaged((void **)& wide_transpose_row_ptr, (wide_n_rows + 1) * sizeof(int)));

  // Compute the transpose of A placing the result in A_T
  checkCudaErrors(cusparseScsr2csc(cuSparse_handle,
                                   wide_n_rows,
                                   wide_n_columns,
                                   wide_nnz,
                                   wide_values,
                                   wide_row_ptr,
                                   wide_column_idx,
                                   wide_transpose_values,
                                   wide_transpose_column_idx,
                                   wide_transpose_row_ptr,
                                   cusparseAction_t::CUSPARSE_ACTION_NUMERIC,
                                   cusparseIndexBase_t::CUSPARSE_INDEX_BASE_ZERO));
  checkCudaErrors(cudaDeviceSynchronize());

  cout << "wide transpose values:" << endl;
  for (int idx = 0; idx < wide_nnz; ++idx)
  {
    cout << wide_transpose_values[idx] << " ";
  }
  cout << endl;

  cout << "wide transpose column indices:" << endl;
  for (int idx = 0; idx < wide_nnz; ++idx)
  {
    cout << wide_transpose_column_idx[idx] << " ";
  }
  cout << endl;

  cout << "wide transpose row ptrs:" << endl;
  for (int idx = 0; idx < wide_n_columns + 1; ++idx)
  {
    cout << wide_transpose_row_ptr[idx] << " ";
  }
  cout << endl;

  // Create a tall sparse CSR matrix representation on the CUDA device
  int tall_n_rows = 4;
  int tall_n_columns = 3;
  int tall_nnz = 12;

  precision * tall_values;
  int * tall_column_idx;
  int * tall_row_ptr;
  checkCudaErrors(cudaMallocManaged((void **)& tall_values, tall_nnz * sizeof(precision)));
  checkCudaErrors(cudaMallocManaged((void **)& tall_column_idx, tall_nnz * sizeof(int)));
  for (int idx = 0; idx < tall_nnz; ++idx)
  {
    tall_values[idx] = precision(idx);
    tall_column_idx[idx] = idx % tall_n_columns;
  }

  checkCudaErrors(cudaMallocManaged((void **)& tall_row_ptr, (tall_n_rows + 1) * sizeof(int)));
  for (int idx = 0; idx < tall_n_rows; ++idx)
  {
    tall_row_ptr[idx] = idx * tall_n_columns;
  }
  tall_row_ptr[tall_n_rows] = tall_n_rows * tall_n_columns;

  precision * tall_transpose_values;
  int * tall_transpose_column_idx;
  int * tall_transpose_row_ptr;
  checkCudaErrors(cudaMallocManaged((void **)& tall_transpose_values, tall_nnz * sizeof(precision)));
  checkCudaErrors(cudaMallocManaged((void **)& tall_transpose_column_idx, tall_nnz * sizeof(int)));
  checkCudaErrors(cudaMallocManaged((void **)& tall_transpose_row_ptr, (tall_n_rows + 1) * sizeof(int)));

  // Compute the transpose of A placing the result in A_T
  checkCudaErrors(cusparseScsr2csc(cuSparse_handle,
                                   tall_n_rows,
                                   tall_n_columns,
                                   tall_nnz,
                                   tall_values,
                                   tall_row_ptr,
                                   tall_column_idx,
                                   tall_transpose_values,
                                   tall_transpose_column_idx,
                                   tall_transpose_row_ptr,
                                   cusparseAction_t::CUSPARSE_ACTION_NUMERIC,
                                   cusparseIndexBase_t::CUSPARSE_INDEX_BASE_ZERO));
  checkCudaErrors(cudaDeviceSynchronize());

  cout << "tall transpose values:" << endl;
  for (int idx = 0; idx < tall_nnz; ++idx)
  {
    cout << tall_transpose_values[idx] << " ";
  }
  cout << endl;

  cout << "tall transpose column indices:" << endl;
  for (int idx = 0; idx < tall_nnz; ++idx)
  {
    cout << tall_transpose_column_idx[idx] << " ";
  }
  cout << endl;

  cout << "tall transpose row ptrs:" << endl;
  for (int idx = 0; idx < tall_n_columns + 1; ++idx)
  {
    cout << tall_transpose_row_ptr[idx] << " ";
  }
  cout << endl;

  return 0;
}

