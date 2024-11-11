#include "RowToeplitzCG.h"
#include "RowToeplitzCGOriginal.h"
#include "utilities.hpp"
#include "gtest/gtest.h"


float evalLaplace(float x, float beta)
{
  float coeff = 1.0F / (2.0F * beta);
  return coeff * expf(- fabs(x) / beta);
}


void setImpulseResponse(float edge_spread_function_rate, int impulse_length, float * impulse_response)
{
  // TODO: RJG this only works as expected for odd lengths, which is sufficient for now, but we may need to implement it
  // for even length edge spread functions later
  int half = impulse_length / 2;
  for (int i = 0, j = -half; i < impulse_length; i++, j++)
  {
    float shift = static_cast<float>(j);
    impulse_response[i] = evalLaplace(shift, edge_spread_function_rate);
  }
}


TEST(python_generated_expected, short_triangle_row_1_iteration)
{
  int nRowsMax = 10;
  int nToeplitzElements = 3;
  int iMax = 1;

  float equals_precision = 1E-3F;

  //  The Toeplitz row vector must be symmetric
  float * toeplitz_row = new float[nToeplitzElements];
  toeplitz_row[0] = 1.0;
  toeplitz_row[1] = 3.0;
  toeplitz_row[2] = 1.0;

  //print_array(toeplitz_row, nToeplitzElements, "toeplitz_row");

  float * b = new float[nRowsMax];
  for (int i = 0; i < nRowsMax; i++)
  {
    b[i] = i + 1.0F;
  }
  //print_array(b, nRowsMax, "b");

  int nColumns = nRowsMax + nToeplitzElements - 1;
  float * xEstimate = new float[nColumns];
  for (int i = 0; i < nColumns; i++)
  {
    xEstimate[i] = 0.0F;
  }
  //print_array(xEstimate, nColumns, "initial x");

  RowToeplitzCG row_toeplitz_cg(nRowsMax, nToeplitzElements);
  row_toeplitz_cg.solveNormalEquations(toeplitz_row, nToeplitzElements, nRowsMax, b, xEstimate, iMax, 0.0F);
  //print_array(xEstimate, nColumns, "final x");

  float * xEstimateOriginal = new float[nColumns];
  for (int i = 0; i < nColumns; i++)
  {
    xEstimateOriginal[i] = 0.0F;
  }
  
  RowToeplitzCGOriginal rtcgo(nRowsMax, nToeplitzElements, 50);
  rtcgo.solve_normal_eq(toeplitz_row, nToeplitzElements, nRowsMax, b, xEstimateOriginal, iMax, 0.0F);
  //print_array(xEstimateOriginal, nColumns, "RTCGO final x");

  //ASSERT_TRUE(all_equal(xEstimate, nColumns, xEstimateOriginal, nColumns, equals_precision));

  //  Compare with expected result from the python RTCG Results Generator
  float * xExpected = new float[nColumns];
  xExpected[0] = 0.04310332F;
  xExpected[1] = 0.2155166F;
  xExpected[2] = 0.43103321F;
  xExpected[3] = 0.64654981F;
  xExpected[4] = 0.86206642F;
  xExpected[5] = 1.07758302F;
  xExpected[6] = 1.29309962F;
  xExpected[7] = 1.50861623F;
  xExpected[8] = 1.72413283F;
  xExpected[9] = 1.93964944F;
  xExpected[10] = 1.68102951F;
  xExpected[11] = 0.43103321F;

  bool result = all_equal(xEstimate, nColumns, xExpected, nColumns, equals_precision);
  if (result != true)
  {
    print_array(xEstimate, nColumns, "xEstimate");
    print_array(xExpected, nColumns, "xExpected");
  }
  ASSERT_TRUE(result);

}


TEST(python_generated_expected, short_triangle_row_2_iterations)
{
  int nRowsMax = 10;
  int nToeplitzElements = 3;
  int iMax = 2;

  float equals_precision = 1E-7F;

  //  The Toeplitz row vector must be symmetric
  float * toeplitz_row = new float[nToeplitzElements];
  toeplitz_row[0] = 1.0;
  toeplitz_row[1] = 3.0;
  toeplitz_row[2] = 1.0;

  //print_array(toeplitz_row, nToeplitzElements, "toeplitz_row");

  float * b = new float[nRowsMax];
  for (int i = 0; i < nRowsMax; i++)
  {
    b[i] = i + 1.0F;
  }
  //print_array(b, nRowsMax, "b");

  int nColumns = nRowsMax + nToeplitzElements - 1;
  float * xEstimate = new float[nColumns];
  for (int i = 0; i < nColumns; i++)
  {
    xEstimate[i] = 0.0F;
  }
  //print_array(xEstimate, nColumns, "initial x");


  RowToeplitzCG row_toeplitz_cg(nRowsMax, nToeplitzElements);
  row_toeplitz_cg.solveNormalEquations(toeplitz_row, nToeplitzElements, nRowsMax, b, xEstimate, iMax, 0.0F);
  //print_array(xEstimate, nColumns, "final x");

  float * xEstimateOriginal = new float[nColumns];
  for (int i = 0; i < nColumns; i++)
  {
    xEstimateOriginal[i] = 0.0F;
  }

  RowToeplitzCGOriginal rtcgo(nRowsMax, nToeplitzElements, 50);
  rtcgo.solve_normal_eq(toeplitz_row, nToeplitzElements, nRowsMax, b, xEstimateOriginal, iMax, 0.0F);
  //print_array(xEstimateOriginal, nColumns, "RTCGO final x");

  //ASSERT_TRUE(all_equal(xEstimate, nColumns, xEstimateOriginal, nColumns, equals_precision));

  //  Compare with expected result from the python RTCG Results Generator
  float * xExpected = new float[nColumns];
  xExpected[0] = 0.03556128F;
  xExpected[1] = 0.18371607F;
  xExpected[2] = 0.38220633F;
  xExpected[3] = 0.57774175F;
  xExpected[4] = 0.77032234F;
  xExpected[5] = 0.96290292F;
  xExpected[6] = 1.15548351F;
  xExpected[7] = 1.34806409F;
  xExpected[8] = 1.57314788F;
  xExpected[9] = 2.06121215F;
  xExpected[10] = 2.22606357F;
  xExpected[11] = 0.61563844F;

  
  bool result = all_equal(xEstimate, nColumns, xExpected, nColumns, equals_precision);
  if (result != true)
  {
    print_array(xEstimate, nColumns, "xEstimate");
    print_array(xExpected, nColumns, "xExpected");
  }
  ASSERT_TRUE(result);
}


TEST(RowToeplitzCGOriginal_comparison, short_triangle_row_1_iteration)
{
  int nRowsMax = 10;
  int nToeplitzElements = 3;
  int iMax = 1;

  float equals_precision = 1E-3F;

  //  The Toeplitz row vector must be symmetric
  float * toeplitz_row = new float[nToeplitzElements];
  toeplitz_row[0] = 1.0;
  toeplitz_row[1] = 3.0;
  toeplitz_row[2] = 1.0;

  //print_array(toeplitz_row, nToeplitzElements, "toeplitz_row");

  float * b = new float[nRowsMax];
  for (int i = 0; i < nRowsMax; i++)
  {
    b[i] = i + 1.0F;
  }
  //print_array(b, nRowsMax, "b");

  int nColumns = nRowsMax + nToeplitzElements - 1;
  float * xEstimate = new float[nColumns];
  for (int i = 0; i < nColumns; i++)
  {
    xEstimate[i] = 0.0F;
  }
  //print_array(xEstimate, nColumns, "initial x");

  RowToeplitzCG row_toeplitz_cg(nRowsMax, nToeplitzElements);
  row_toeplitz_cg.solveNormalEquations(toeplitz_row, nToeplitzElements, nRowsMax, b, xEstimate, iMax, 0.0F);
  //print_array(xEstimate, nColumns, "final x");

  float * xEstimateOriginal = new float[nColumns];
  for (int i = 0; i < nColumns; i++)
  {
    xEstimateOriginal[i] = 0.0F;
  }

  RowToeplitzCGOriginal rtcgo(nRowsMax, nToeplitzElements, 50);
  rtcgo.solve_normal_eq(toeplitz_row, nToeplitzElements, nRowsMax, b, xEstimateOriginal, iMax, 0.0F);
  //print_array(xEstimateOriginal, nColumns, "RTCGO final x");

  bool result = all_equal(xEstimate, nColumns, xEstimateOriginal, nColumns, equals_precision);
  if (result != true)
  {
    print_array(xEstimate, nColumns, "xEstimate");
    print_array(xEstimateOriginal, nColumns, "xEstimateOriginal");
  }
  ASSERT_TRUE(result);

}

TEST(RowToeplitzCGOriginal_comparison, short_triangle_row_2_iterations)
{
  int nRowsMax = 10;
  int nToeplitzElements = 3;
  int iMax = 2;

  float equals_precision = 1E-7F;

  //  The Toeplitz row vector must be symmetric
  float * toeplitz_row = new float[nToeplitzElements];
  toeplitz_row[0] = 1.0;
  toeplitz_row[1] = 3.0;
  toeplitz_row[2] = 1.0;

  //print_array(toeplitz_row, nToeplitzElements, "toeplitz_row");

  float * b = new float[nRowsMax];
  for (int i = 0; i < nRowsMax; i++)
  {
    b[i] = i + 1.0F;
  }
  //print_array(b, nRowsMax, "b");

  int nColumns = nRowsMax + nToeplitzElements - 1;
  float * xEstimate = new float[nColumns];
  for (int i = 0; i < nColumns; i++)
  {
    xEstimate[i] = 0.0F;
  }
  //print_array(xEstimate, nColumns, "initial x");


  RowToeplitzCG row_toeplitz_cg(nRowsMax, nToeplitzElements);
  row_toeplitz_cg.solveNormalEquations(toeplitz_row, nToeplitzElements, nRowsMax, b, xEstimate, iMax, 0.0F);
  //print_array(xEstimate, nColumns, "final x");

  float * xEstimateOriginal = new float[nColumns];
  for (int i = 0; i < nColumns; i++)
  {
    xEstimateOriginal[i] = 0.0F;
  }

  RowToeplitzCGOriginal rtcgo(nRowsMax, nToeplitzElements, 50);
  rtcgo.solve_normal_eq(toeplitz_row, nToeplitzElements, nRowsMax, b, xEstimateOriginal, iMax, 0.0F);
  //print_array(xEstimateOriginal, nColumns, "RTCGO final x");

  bool result = all_equal(xEstimate, nColumns, xEstimateOriginal, nColumns, equals_precision);
  if (result != true)
  {
    print_array(xEstimate, nColumns, "xEstimate");
    print_array(xEstimateOriginal, nColumns, "xEstimateOriginal");
  }
  ASSERT_TRUE(result);

}

TEST(memory_management, cycle_1568)
{
  int nRowsMax = 1568;
  int nToeplitzElements = 21;
  int halfImpulseLength = nToeplitzElements / 2;
  int i_max = 2;

  int n_tests = 10000;
  for (int i_test = 0; i_test < n_tests; i_test++)
  {
    float * toeplitz_row = new float[nToeplitzElements];
    setImpulseResponse(1.0F, nToeplitzElements, toeplitz_row);
    float * b = new float[nRowsMax];
    float * xEstimate = new float[nRowsMax + nToeplitzElements];
    float * result = new float[nRowsMax];

    RowToeplitzCG * row_toeplitz_cg = new RowToeplitzCG(nRowsMax, nToeplitzElements);
    for (int nRows = 1; nRows <= nRowsMax + 1; nRows++)
    {
      uniform_random_vector(b, nRows);
      for (int i = 0; i < halfImpulseLength; ++i)
      {
        xEstimate[i] = b[halfImpulseLength - i - 1];
      }
      memcpy(xEstimate + halfImpulseLength, b, nRows * sizeof(float));
      for (int i = 0, j = nRows + halfImpulseLength; i < halfImpulseLength; ++i, ++j)
      {
        xEstimate[j] = b[nRows - i - 1];
      }

      row_toeplitz_cg->solveNormalEquations(toeplitz_row, nToeplitzElements, nRows, b, xEstimate, i_max, 0.0F);

      memcpy(result, xEstimate + halfImpulseLength, nRows * sizeof(float));

    }

    delete[] toeplitz_row;
    delete[] b;
    delete[] xEstimate;
    delete[] result;
  }

  ASSERT_TRUE(true);
}


int main(int argc, char * argv[])
{
  ::testing::InitGoogleTest(&argc, argv);
  int status = RUN_ALL_TESTS();
  return status;
}
