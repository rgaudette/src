#pragma once
#include <cmath>
#include <cstdio>
#include <iostream>
#include <limits>
#include <sstream>

#include "ipp.h"

#define NOMINMAX
#define WIN32_LEAN_AND_MEAN   // Exclude rarely-used stuff from Windows headers
#define VC_EXTRALEAN    // Exclude rarely-used stuff from Windows headers
#include <Windows.h>

using namespace std;


template <typename T>
static void print_array(T * vector, int length, char * label="", int max_elements = 0)
{
  printf("%s: ", label);
  for (int i = 0; i < length; ++i)
  {
    printf("%0.8f, ", vector[i]);
  }
  printf("\n");
};


template <typename T>
static void print_matrix(T * matrix, int n_rows, int n_cols, int max_elements = 0)
{
  if (max_elements)
  {
    int max_half = max_elements / 2;
    for (int i = 0; i < max_half; ++i)
    {
      for (int j = 0; j < max_half; ++j)
      {
        printf("%0.2f, ", matrix[i * n_cols + j]);
      }
      printf("...");
      for (int j = n_cols - max_half; j < n_cols; ++j)
      {
        printf("%0.2f, ", matrix[i * n_cols + j]);
      }
      printf("\n");
    }
    printf(":\n");

    for (int i = n_rows - max_half; i < n_rows; ++i)
    {
      for (int j = 0; j < max_half; ++j)
      {
        printf("%0.2f, ", matrix[i * n_cols + j]);
      }
      printf("...");
      for (int j = n_cols - max_half - 1 ; j < n_cols; ++j)
      {
        printf("%0.2f, ", matrix[i * n_cols + j]);
      }
      printf("\n");
    }
    printf("\n");
  }
  else
  {
    for (int i = 0; i < n_rows; ++i)
    {
      for (int j = 0; j < n_cols; ++j)
      {
        printf("%0.2f, ", matrix[i * n_cols + j]);
      }
      printf("\n");
    }
  }
  printf("\n");
};

template <typename T>
static bool all_equal(const T * array1, int length1,
                      const T * array2, int length2,
                      T precision = numeric_limits<T>::min())
{
  if (length1 != length2) return false;

  bool state = true;
  for (int i = 0; i < length1; ++i)
  {
    T abs_diff = abs(array1[i] - array2[i]) / array1[i];
    state &= abs_diff < precision;
  }
  return state;
};


// Return the current performance timer reading
static LARGE_INTEGER get_performance_timer_time()
{
  LARGE_INTEGER start;
  BOOL ret_val = QueryPerformanceCounter(& start);

  if (ret_val == 0)
  {
    DWORD last_error = GetLastError();
    stringstream msg;
    msg << "Could not query the Performance Counter: error code " << last_error << endl
        << "File: " << __FILE__ << endl
        << "Line: " << __LINE__;
    cerr << msg.str() << endl;
    throw exception(msg.str().c_str());
  }
  return start;
};

static double get_performance_timer_elapsed_seconds(LARGE_INTEGER start)
{
  LARGE_INTEGER stop;
  BOOL ret_val = QueryPerformanceCounter(& stop);

  if (ret_val == 0)
  {
    DWORD last_error = GetLastError();
    stringstream msg;
    msg << "Could not query the Performance Counter: error code " << last_error << endl
        << "File: " << __FILE__ << endl
        << "Line: " << __LINE__;
    cerr << msg.str() << endl;
    throw exception(msg.str().c_str());
  }

  LONGLONG  elapsed_counts = stop.QuadPart - start.QuadPart;

  LARGE_INTEGER frequency;
  ret_val = QueryPerformanceFrequency(& frequency);
  if (ret_val == 0)
  {
    DWORD last_error = GetLastError();
    stringstream msg;
    msg << "Could not query the Performance Frequency: error code " << last_error << endl
        << "File: " << __FILE__ << endl
        << "Line: " << __LINE__;
    cerr << msg.str() << endl;
    throw exception(msg.str().c_str());
  }

  double elapsed_secs = static_cast<double>(elapsed_counts) / frequency.QuadPart;
  return elapsed_secs;
};


static void check_ipp_status(int status, char * file, int line)
{
  if (status == ippStsOk) return;

  cerr << "IPP status not OK " << status << endl;
  cerr << "File: " << file << endl;
  cerr << "Line: " << line << endl;
};


template <typename T>
static void uniform_random_vector(T * vec, int n_elements)
{
  for (int i_element = 0; i_element < n_elements; i_element++)
  {
    vec[i_element] = static_cast<T>(rand()) / (static_cast<T>(RAND_MAX) + 1.0F) * 2.0F - 1.0F;
  }
};

template <typename T>
static void random_matrix(T * matrix, int stride_1, int stride_2, int n_rows, int n_cols)
{
  for (int i_row = 0; i_row < n_rows; i_row++)
  {
    for (int i_col = 0; i_col < n_cols; i_col++)
    {
      matrix[i_col + i_row * n_cols] = static_cast<T>(rand()) / (static_cast<T>(RAND_MAX) + 1.0F) * 2.0F - 1.0F;
    }
  }
};

template <typename T>
static void random_convolution_operatator(T * matrix, int stride_1, int stride_2, int n_rows, int n_cols)
{
  for (int i_row = 0; i_row < n_rows; i_row++)
  {
    for (int i_col = 0; i_col < n_cols; i_col++)
    {
      matrix[i_col + i_row * n_cols] = static_cast<T>(rand()) / (static_cast<T>(RAND_MAX) + 1.0F) * 2.0F - 1.0F;
    }
  }
};

// How to templatize these functions
static void random_symmetric_positive_definite_matrix(Ipp32f * matrix, int stride_1, int stride_2, int n_elem)
{
  int local_stride_2 = sizeof(Ipp32f);
  int local_stride_1 = n_elem * local_stride_2;
  Ipp32f * random_mat = new Ipp32f[n_elem * n_elem];

  random_matrix(random_mat, stride_1, stride_2, n_elem, n_elem);
  //cout << "Random matrix" << endl;
  //print_matrix(random_matrix, n_elem, n_elem);

  IppStatus status;

  // matrix = A^T * A
  status = ippmMul_tm_32f(random_mat, local_stride_1, local_stride_2, n_elem, n_elem,
                          random_mat, local_stride_1, local_stride_2, n_elem, n_elem,
                          matrix, stride_1, stride_2);
  check_ipp_status(status, __FILE__, __LINE__);
  //cout << "Product" << endl;
  //print_matrix(matrix, n_elem, n_elem);
};


template <typename T>
static void random_symmetric_vector(T * vec, int n_elements)
{
  int n_half = n_elements / 2;
  for (int i = 0; i < n_half; i++)
  {
    vec[i] = static_cast<T>(rand()) / (static_cast<T>(RAND_MAX) + 1.0F) * 2.0F - 1.0F;
    vec[n_elements - i - 1] = vec[i];
  }
  if (n_elements % 2)
  {
    vec[n_half] = static_cast<T>(rand()) / (static_cast<T>(RAND_MAX) + 1.0F) * 2.0F - 1.0F;
  }
};


static void multiply(Ipp32f * A, int stride_1, int stride_2, int n_rows, int n_cols, Ipp32f * x, Ipp32f * b)
{
  IppStatus status = ippmMul_mv_32f(A, stride_1, stride_2, n_cols, n_rows,
                                    x, stride_2, n_cols,
                                    b, stride_2);
  check_ipp_status(status, __FILE__, __LINE__);
};



static Ipp32f rms_error(Ipp32f * x, Ipp32f * y, int stride_2, int n_elem)
{
  // d = x - y
  Ipp32f * d = new Ipp32f[n_elem];
  IppStatus status;
  status = ippmSub_vv_32f(x, stride_2, y, stride_2, d, stride_2, n_elem);
  check_ipp_status(status, __FILE__, __LINE__);

  Ipp32f sum_squared = 0.0F;
  for (int i = 0; i < n_elem; ++i)
  {
    sum_squared += d[i] * d[i];
  }
  delete[] d;

  return sqrt(sum_squared / n_elem);
};

// Compute the residual sqrt(||Ax - b||)
// Assumes A, x and b are correctly sized
static Ipp32f residual(Ipp32f * A, int stride_1, int stride_2, int n_rows, int n_cols, Ipp32f * x,  Ipp32f * b)
{
  IppStatus status;

  // temp = Ax
  Ipp32f * temp = new Ipp32f[n_rows];
  status = ippmMul_mv_32f(A, stride_1, stride_2, n_cols, n_rows,
                          x, stride_2, n_cols,
                          temp, stride_2);
  check_ipp_status(status, __FILE__, __LINE__);

  // r = b - temp
  Ipp32f * r = new Ipp32f[n_rows];
  status = ippmSub_vv_32f(b, stride_2, temp, stride_2, r, stride_2, n_rows);
  check_ipp_status(status, __FILE__, __LINE__);

  Ipp32f r_norm_squared;
  status = ippmDotProduct_vv_32f(r, stride_2, r, stride_2, & r_norm_squared, n_rows);
  check_ipp_status(status, __FILE__, __LINE__);

  delete[] r;
  delete[] temp;
  return sqrt(r_norm_squared);
};
