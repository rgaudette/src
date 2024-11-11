#include <vector>

#include "ipp.h"
#include "mkl.h"

#define _VARIADIC_MAX 10
#include "gtest/gtest.h"

#include "utilities.hpp"
#include "DenseCG.h"
#include "RowToeplitzCG.h"
#include "MKLMatrix.hpp"

using namespace std;


class Test_DenseCG : public ::testing::Test
{
  protected:
    float * matrix;
    float * observations;
    float * estimate;
    float * true_value;

    Test_DenseCG()
    {
      // Initialized the common memory pointers as NULL so we know whether to clean them up in the destructor
      matrix = NULL;
      observations = NULL;
      estimate = NULL;
      true_value = NULL;
    }

    virtual void SetUp()
    {
    }

    virtual void TearDown()
    {
      if (matrix) ippsFree(matrix);
      if (observations) ippsFree(observations);
      if (estimate) ippsFree(estimate);
      if (true_value) ippsFree(true_value);
    }

};


float * mkl_allocate(int n_elements, int alignment_bytes = 64, char * name = "unspecified array")
{
  float * pointer = static_cast<float *>(mkl_malloc(n_elements * sizeof(float), 64));
  if (pointer == NULL)
  {
    fprintf(stderr, "Failed allocation for %s", name);
  }
  return pointer;
}

void zero_array(float * pointer, int length)
{
  for (int i = 0; i < length; i++)
  {
    pointer[i] = 0.0F;
  }
}


TEST_F(Test_DenseCG, test_identity)
{
  int n_rows = 100;
  int n_cols = 100;

  matrix = ippsMalloc_32f(n_rows * n_cols);
  int stride_2 = sizeof(float);
  int stride_1 = n_cols * stride_2;
  int stride_0 = n_rows * stride_1;

  IppStatus status;
  status = ippmLoadIdentity_ma_32f(matrix, stride_0, stride_1, stride_2, n_cols, n_rows, 1);
  ASSERT_EQ(ippStsOk, status);

  observations = ippsMalloc_32f(n_rows);
  for (int i = 0; i < n_rows; ++i)
    observations[i] = 1.0F;

  estimate = ippsMalloc_32f(n_cols);
  for (int i = 0; i < n_cols; ++i)
    estimate[i] = 0.0F;

  DenseCG dense_CG(n_rows);
  dense_CG.setA(matrix, n_rows, n_cols, stride_1);
  dense_CG.setB(observations, n_rows);
  int n_iterations = dense_CG.solve(estimate, 1000, 1E-5F);

  ASSERT_TRUE(all_equal(estimate, n_cols, observations, n_rows));
}


//TEST_F(Test_DenseCG, correct_estimate)
//{
//  int n_rows = 10;
//  int n_cols = 10;
//
//  matrix = ippsMalloc_32f(n_rows * n_cols);
//  int stride_2 = sizeof(float);
//  int stride_1 = n_cols * stride_2;
//  int stride_0 = n_rows * stride_1;
//
//  IppStatus status;
//  status = ippmLoadIdentity_ma_32f(matrix, stride_0, stride_1, stride_2, n_cols, n_rows, 1);
//  ASSERT_EQ(ippStsOk, status);
//
//  estimate = ippsMalloc_32f(n_cols);
//  true_value = ippsMalloc_32f(n_cols);
//  for (int i = 0; i < n_cols; ++i)
//  {
//    estimate[i] = 1.0F;
//    true_value[i] = 1.0F;
//  }
//
//  observations = ippsMalloc_32f(n_rows);
//  multiply(matrix, stride_1, stride_2, n_rows, n_cols, true_value, observations);
//
//  DenseCG dense_CG(n_rows);
//  dense_CG.setA(matrix, n_rows, n_cols, stride_1);
//  dense_CG.setB(observations, n_rows);
//  int n_iterations = dense_CG.solve(estimate, 1000, 1E-5F);
//
//  ASSERT_TRUE(all_equal(estimate, n_cols, true_value, n_cols));
//}
//
//
//TEST_F(Test_DenseCG, close_estimate)
//{
//  int n_rows = 10;
//  int n_cols = 10;
//
//  matrix = ippsMalloc_32f(n_rows * n_cols);
//  IppStatus status;
//  int stride_2 = sizeof(float);
//  int stride_1 = n_cols * stride_2;
//  int stride_0 = n_rows * stride_1;
//
//  status = ippmLoadIdentity_ma_32f(matrix, stride_0, stride_1, stride_2, n_cols, n_rows, 1);
//  ASSERT_EQ(ippStsOk, status);
//
//  estimate = ippsMalloc_32f(n_cols);
//  true_value = ippsMalloc_32f(n_cols);
//  for (int i = 0; i < n_cols; ++i)
//  {
//    estimate[i] = 1.0F;
//    true_value[i] = 1.0F;
//  }
//  estimate[0] = -1.0F;
//  estimate[1] = 0.5F;
//  observations = ippsMalloc_32f(n_rows);
//  multiply(matrix, stride_1, stride_2, n_rows, n_cols, true_value, observations);
//
//  DenseCG dense_CG(n_rows);
//  dense_CG.setA(matrix, n_rows, n_cols, stride_1);
//  dense_CG.setB(observations, n_rows);
//  int n_iterations = dense_CG.solve(estimate, 1000, 1.0E-6F);
//
//  ASSERT_TRUE(all_equal(estimate, n_cols, true_value, n_cols));
//}
//
//
//TEST_F(Test_DenseCG, random_SPD)
//{
//  // More than 25 elements and the algorithm does not converge, is that a consequence of floats or the singular value
//  // spectrum of a random SPD matrix?
//  int n_elem = 25;
//  int max_iterations = 100;
//  float cg_espilon = 1.0E-7F;
//  // Works under 32 bit
//  //float equals_precision = 2.0E-4F;
//  // Works under 64 bit
//  float equals_precision = 3.0E-4F;
//
//  matrix = ippsMalloc_32f(n_elem * n_elem);
//  int stride_2 = sizeof(float);
//  int stride_1 = n_elem * stride_2;
//
//  srand(1);
//  random_symmetric_positive_definite_matrix(matrix, stride_1, stride_2, n_elem);
//
//  estimate = ippsMalloc_32f(n_elem);
//  true_value = ippsMalloc_32f(n_elem);
//  for (int i = 0; i < n_elem; ++i)
//  {
//    estimate[i] = 0.0F;
//    //true_value[i] = static_cast<float>(rand()) / (static_cast<float>(RAND_MAX) + 1.0F);
//    true_value[i] = 1.0F;
//  }
//
//  observations = ippsMalloc_32f(n_elem);
//  multiply(matrix, stride_1, stride_2, n_elem, n_elem, true_value, observations);
//
//  DenseCG dense_CG(n_elem);
//  dense_CG.setA(matrix, n_elem, n_elem, stride_1);
//  dense_CG.setB(observations, n_elem);
//  int n_iterations = dense_CG.solve(estimate, max_iterations, cg_espilon);
//
//  ASSERT_TRUE(all_equal(estimate, n_elem, true_value, n_elem, equals_precision))
//      << "Ran for " << n_iterations << " iterations" << endl
//      << "Residual " << residual(matrix, stride_1, stride_2, n_elem, n_elem, estimate, observations) << endl
//      << "rms error " << rms_error(estimate, true_value, stride_2, n_elem) << endl;
//}
//
//TEST_F(Test_DenseCG, solve_random_small)
//{
//  // Use a highly overdetermined matrix so that we are likely to get a good numerically conditioned set of normal
//  // equations
//  int n_rows = 20;
//  int n_cols = 10;
//  int max_iterations = 1000;
//  // Do not make the convergence criteria too small otherwise it will bounce around the solution and
//  float cg_espilon = 1.0E-6F;
//  // Works under 32 bit, IPP 5.1
//  //float equals_precision = 6.0E-6F;
//  // Works under 64 bit IPP 5.1
//  //float equals_precision = 6.8E-6F;
//  float equals_precision = 2.0E-5F;
//  int n_loops = 2000;
//
//  matrix = ippsMalloc_32f(n_rows * n_cols);
//  estimate = ippsMalloc_32f(n_cols);
//  true_value = ippsMalloc_32f(n_cols);
//  observations = ippsMalloc_32f(n_rows);
//
//  int stride_2 = sizeof(float);
//  int stride_1 = n_cols * stride_2;
//
//  srand(1);
//  for (int iter = 0; iter < n_loops; ++iter)
//  {
//    random_matrix(matrix, stride_1, stride_2, n_rows, n_cols);
//
//    for (int i = 0; i < n_cols; ++i)
//    {
//      estimate[i] = 0.0F;
//      //true_value[i] = static_cast<float>(rand()) / (static_cast<float>(RAND_MAX) + 1.0F);
//      true_value[i] = 1.0F;
//    }
//
//    multiply(matrix, stride_1, stride_2, n_rows, n_cols, true_value, observations);
//
//    DenseCG dense_CG(std::max(n_cols, n_rows));
//    dense_CG.setA(matrix, n_rows, n_cols, stride_1);
//    dense_CG.setB(observations, n_rows);
//    int n_iterations = dense_CG.solve_normal_eq_blas(estimate, max_iterations, cg_espilon);
//
//    bool is_close = all_equal(true_value, n_cols, estimate, n_cols, equals_precision);
//    if (! is_close)
//    {
//      print_array(estimate, n_cols);
//      float resid = residual(matrix, stride_1, stride_2, n_rows, n_cols, estimate, observations);
//      float rms_err = rms_error(estimate, true_value, stride_2, n_cols);
//      FAIL()
//          << "system number: " << iter  << endl
//          << "Ran for " << n_iterations << " iterations" << endl
//          << "Residual " << resid << endl
//          << "rms error " << rms_err << endl;
//    }
//  }
//}
//
//TEST_F(Test_DenseCG, solve_random_small_underdetermined)
//{
//  int n_rows = 3;
//  int n_cols = 5;
//  float * fwd_op = (float *) mkl_malloc(n_rows * n_cols * sizeof(float), 64);
//  fwd_op[0] = 1.0;
//  fwd_op[1] = 2.0;
//  fwd_op[2] = 3.0;
//  fwd_op[3] = 0.0;
//  fwd_op[4] = 0.0;
//  fwd_op[5] = 0.0;
//  fwd_op[6] = 1.0;
//  fwd_op[7] = 2.0;
//  fwd_op[8] = 3.0;
//  fwd_op[9] = 0.0;
//  fwd_op[10] = 0.0;
//  fwd_op[11] = 0.0;
//  fwd_op[12] = 1.0;
//  fwd_op[13] = 2.0;
//  fwd_op[14] = 3.0;
//
//  float * obs = (float *) mkl_malloc(n_rows * sizeof(float), 64);
//  obs[0] = 1.0;
//  obs[1] = 2.0;
//  obs[2] = 3.0;
//
//  float * est = (float *) mkl_malloc(n_cols * sizeof(float), 64);
//  est[0] = 1.0;
//  est[1] = 1.0;
//  est[2] = 2.0;
//  est[3] = 3.0;
//  est[4] = 3.0;
//
//  DenseCG dense_CG(n_rows, 50);
//  dense_CG.setA(fwd_op, n_rows, n_cols, n_cols * sizeof(float));
//  dense_CG.setB(obs, n_rows);
//  int n_iterations = dense_CG.solve_normal_eq_blas(est, 10, 1.0E-6F);
//  cout << "iterations: " << n_iterations << endl;
//  for(int i = 0; i < n_cols; i++)
//  {
//    cout << est[i] << endl;
//  }
//  ASSERT_TRUE(true);
//}
//
//TEST_F(Test_DenseCG, profile_large_system_few_iterations)
//{
//  int n_cols = 512;
//  int n_rows = n_cols + 40;
//
//  int n_image_rows = n_cols;
//
//  int max_iterations = 3;
//  float cg_espilon = 1.0E-6F;
//  float equals_precision = 100.0;
//
//  matrix = ippsMalloc_32f(n_rows * n_cols);
//  estimate = ippsMalloc_32f(n_image_rows * n_cols);
//  true_value = ippsMalloc_32f(n_cols);
//  observations = ippsMalloc_32f(n_rows);
//
//  int stride_2 = sizeof(float);
//  int stride_1 = n_cols * stride_2;
//
//  srand(1);
//  random_matrix(matrix, stride_1, stride_2, n_rows, n_cols);
//
//  for (int i = 0; i < n_cols; ++i)
//  {
//    true_value[i] = 1.0F;
//  }
//  for (int i = 0; i < n_image_rows * n_cols; ++i)
//  {
//    estimate[i] = 0.0F;
//  }
//
//  multiply(matrix, stride_1, stride_2, n_rows, n_cols, true_value, observations);
//
//  DenseCG dense_CG(std::max(n_cols, n_rows));
//  dense_CG.setA(matrix, n_rows, n_cols, stride_1);
//  dense_CG.setB(observations, n_rows);
//
//  LARGE_INTEGER start = get_performance_timer_time();
//  int n_iterations;
//  float * row_start = estimate;
//  for (int image_row = 0; image_row < n_image_rows; ++image_row)
//  {
//    n_iterations = dense_CG.solve_normal_eq_blas(row_start, max_iterations, cg_espilon);
//    bool eql = all_equal(true_value, n_cols, estimate, n_cols, equals_precision);
//    if (n_iterations != max_iterations)
//    {
//      cout << "equal: " << eql << endl;
//
//      float resid = residual(matrix, stride_1, stride_2, n_rows, n_cols, estimate, observations);
//      float rms_err = rms_error(estimate, true_value, stride_2, n_cols);
//
//      cout << "Ran for " << n_iterations << " iterations" << endl;
//      cout << "Residual " << resid << endl;
//      cout << "rms error " << rms_err << endl;
//
//
//      FAIL() << "didn't complete " << n_iterations << " on row " << image_row;
//    }
//    row_start += n_cols;
//  }
//  double secs = get_performance_timer_elapsed_seconds(start);
//  cout << "solve elapsed time: " << secs * 1000.0 << " ms" << endl;
//
//  float resid = residual(matrix, stride_1, stride_2, n_rows, n_cols, estimate, observations);
//  float rms_err = rms_error(estimate, true_value, stride_2, n_cols);
//
//  ASSERT_TRUE(all_equal(true_value, n_cols, estimate, n_cols, equals_precision))
//      << "Ran for " << n_iterations << " iterations" << endl
//      << "Residual " << resid << endl
//      << "rms error " << rms_err << endl;
//}

TEST_F(Test_DenseCG, toeplitz_small_ramp)
{
  int nRowsMax = 10;
  int nTopelitzElements = 3;
  int n_cols = nRowsMax + nTopelitzElements - 1;
  int iMax = 1;
  float * toeplitz_row = mkl_allocate(nTopelitzElements, 64, "row");
  for (int i = 0; i < nTopelitzElements; i++)
  {
    toeplitz_row[i] = i + 1.0F;
  }
  toeplitz_row[0] = 1.0;
  toeplitz_row[1] = 3.0;
  toeplitz_row[2] = 1.0;

  float * toeplitz_row_rev = mkl_allocate(nTopelitzElements, 64, "row");
  for (int i = 0; i < nTopelitzElements; i++)
  {
    toeplitz_row_rev[i] = toeplitz_row[nTopelitzElements - i - 1];
  }

  MKLMatrix<float> mkl_matrix(nRowsMax, n_cols);
  mkl_matrix.fill_row_toeplitz(toeplitz_row, nTopelitzElements, nRowsMax, n_cols);
  //print_matrix(mkl_matrix._buffer, nRowsMax, n_cols, 0);

  float * b = new float[nRowsMax];
  for (int i = 0; i < nRowsMax; i++)
  {
    b[i] = i + 1.0F;
  }
  print_array(b, nRowsMax, "b");

  int nColumns = nRowsMax + nTopelitzElements - 1;
  float * xEstimate = new float[nColumns];
  for (int i = 0; i < nColumns; i++)
  {
    xEstimate[i] = 0.0F;
  }
  print_array(xEstimate, nColumns, "initial x");

  DenseCG dense_cg(nRowsMax);
  dense_cg.setA(mkl_matrix);
  dense_cg.setB(b, nRowsMax);
  dense_cg.solve_normal_eq_blas(xEstimate, iMax, 0.0F);
  print_array(xEstimate, n_cols, "denseCG x");

  RowToeplitzCG row_toeplitz_cg(nRowsMax, nTopelitzElements);

  float * rtcg_est = mkl_allocate(n_cols, 64, "rctg_est");
  zero_array(rtcg_est, n_cols);

  int n_iterations_rtcg = row_toeplitz_cg.solve_normal_eq(toeplitz_row_rev,
                                                          nTopelitzElements,
                                                          nRowsMax,
                                                          b,
                                                          rtcg_est,
                                                          iMax,
                                                          0.0);

  print_array(rtcg_est, nColumns, "rtcg x");
}

//TEST_F(Test_DenseCG, toeplitz_random_symmetric)
//{
//  int n_impulse_response = 21;
//  int n_samples = 100;
//  float * row = mkl_allocate(n_impulse_response, 64, "row");
//  random_symmetric_vector(row, n_impulse_response);
//
//  int n_rows = n_samples;
//  int n_cols = n_samples + n_impulse_response - 1;
//  MKLMatrix<float> mkl_matrix(n_rows, n_cols);
//  mkl_matrix.fill_row_toeplitz(row, n_impulse_response, n_rows, n_cols);
//
//  float * true_x = mkl_allocate(n_cols, 64, "true_x");
//  uniform_random_vector(true_x, n_cols);
//
//  float * samples = mkl_allocate(n_samples, 64, "samples");
//  mkl_matrix.multiply(true_x, samples);
//
//  DenseCG dense_CG(n_cols);
//  dense_CG.setA(mkl_matrix);
//  dense_CG.setB(samples, n_rows);
//  float * est_x = mkl_allocate(n_cols, 64, "est_x");
//  zero_array(est_x, n_cols);
//  //memcpy(est_x, true_x, n_cols * sizeof(float));
//
//  int i_max = 5;
//  float epsilon = 0.0;
//  float equals_precision = 1E-3F;
//
//  int n_iterations_dense = dense_CG.solve_normal_eq_blas(est_x, i_max, epsilon);
//  //float resid = residual(matrix, stride_1, stride_2, n_rows, n_cols, estimate, observations);
//  //float rms_err = rms_error(estimate, true_value, stride_2, n_cols);
//
//  printf("\n\n");
//
//  RowToeplitzCG row_toeplitz_cg(n_samples, n_impulse_response);
//  //row_toeplitz_cg.setRow(row, n_impulse_response, n_cols);
//  //row_toeplitz_cg.setB(samples, n_rows);
//
//
//  float * rtcg_est = mkl_allocate(n_cols, 64, "rctg_est");
//  zero_array(rtcg_est, n_cols);
//
//  int n_iterations_rtcg = row_toeplitz_cg.solve_normal_eq(row,
//                                                          n_impulse_response,
//                                                          n_rows,
//                                                          samples,
//                                                          rtcg_est,
//                                                          i_max,
//                                                          epsilon);
//  printf("n iterations  dense: %d  rtcg: %d\n", n_iterations_dense, n_iterations_rtcg);
//  bool res = all_equal(rtcg_est, n_cols, est_x, n_cols, equals_precision);
//
//  ASSERT_TRUE(res);
//  //<< "Residual " << resid << endl
//  //<< "rms error " << rms_err << endl;
//}

int main(int argc, char * argv[])
{
  IppStatus ipp_status = ippStaticInit();
  check_ipp_status(ipp_status, __FILE__, __LINE__);

  ::testing::InitGoogleTest(&argc, argv);
  int test_status = RUN_ALL_TESTS();
  return test_status;
}
