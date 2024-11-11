// This is required because MS has only implemented a work around for Variadic Templates and not a full implementation.
// Google Test requires 10
#define _VARIADIC_MAX 10

#include <cstdlib>
#include <direct.h>
#include <exception>
#include <fstream>
#include <istream>
#include <stdio.h>
#include <string>

#include "ipp.h"

#include "gtest/gtest.h"

#include "Exception.h"
#include "IPPImage.h"
#include "ImageUtil.h"
#include "IPPLibException.h"

#include "StationaryHaarTransformer1D.h"
#include "StationaryHaarTransformer1D.cpp"

using namespace std;

void print_vector(Ipp32f * vector, int length)
{
  for (int i = 0; i < length; ++i)
  {
    printf("%0.2f, ", vector[i]);
  }
  printf("\n");
}


void read_vector_file(string in_file, Ipp32f * vec, int length)
{
  ifstream in_stream(in_file.c_str());
  if (in_stream.fail())
  {
    string msg("can't open file: ");
    msg.append(in_file);
    throw exception(msg.c_str());
  }
  
  string line;
  for (int i = 0; i < length; ++i)
  {
    getline(in_stream, line);
    vec[i] = static_cast<Ipp32f>(atof(line.c_str()));
  }
  
  in_stream.close();
}


bool all_equal(Ipp32f * v1, Ipp32f * v2, int length, Ipp32f precision = 1.0E-14)
{
  bool state = true;
  for (int i = 0; i < length; ++i)
  {
    float abs_diff = fabs(v1[i] - v2[i]);
    state &= abs_diff < precision;
  }
  return state;
}

class Test_StationaryHaarTransformer : public ::testing::Test
{
protected:
  int max_levels;
  int max_length;
  int n_elems;
  int n_levels;
  Ipp32f * p_approx;
  Ipp32f * p_detail;
  Ipp32f * p_ramp_16;
  Ipp32f * p_unit_haar_ramp_16_approximation_l1;
  Ipp32f * p_unit_haar_ramp_16_detail_l1;
  Ipp32f * p_unit_haar_ramp_16_approximation_l2;
  Ipp32f * p_unit_haar_ramp_16_detail_l2;
  Ipp32f * p_unit_haar_ramp_16_approximation_l3;
  Ipp32f * p_unit_haar_ramp_16_detail_l3;

  Ipp32f * p_step_16;
  Ipp32f * p_unit_haar_step_16_approximation_l1;
  Ipp32f * p_unit_haar_step_16_detail_l1;
  Ipp32f * p_unit_haar_step_16_approximation_l2;
  Ipp32f * p_unit_haar_step_16_detail_l2;
  Ipp32f * p_unit_haar_step_16_approximation_l3;
  Ipp32f * p_unit_haar_step_16_detail_l3;

  Ipp32f * p_random_1024;

  StationaryHaarTransformer1D * p_sht1d;

  Test_StationaryHaarTransformer()
  {
    //char cCurrentPath[FILENAME_MAX];
    //_getcwd(cCurrentPath, sizeof(cCurrentPath));
    //cout << "The current working directory is:" << endl;
    //cout << cCurrentPath << endl;

    max_levels = 5;
    max_length = 1024;
    p_sht1d = new StationaryHaarTransformer1D(max_levels, max_length);

    p_approx = ippsMalloc_32f(max_length);
    p_detail = ippsMalloc_32f(max_length);

    n_elems = 16;
    // Read the expected results files into the associated arrays
    p_ramp_16 = ippsMalloc_32f(n_elems);
    read_vector_file("ramp 16.txt", p_ramp_16, n_elems);

    p_unit_haar_ramp_16_approximation_l1 = ippsMalloc_32f(n_elems);
    read_vector_file("unit haar ramp 16 approximation l1.txt", p_unit_haar_ramp_16_approximation_l1, n_elems);

    p_unit_haar_ramp_16_detail_l1 = ippsMalloc_32f(n_elems);
    read_vector_file("unit haar ramp 16 detail l1.txt", p_unit_haar_ramp_16_detail_l1, n_elems);

    p_unit_haar_ramp_16_approximation_l2 = ippsMalloc_32f(n_elems);
    read_vector_file("unit haar ramp 16 approximation l2.txt", p_unit_haar_ramp_16_approximation_l2, n_elems);

    p_unit_haar_ramp_16_detail_l2 = ippsMalloc_32f(n_elems);
    read_vector_file("unit haar ramp 16 detail l2.txt", p_unit_haar_ramp_16_detail_l2, n_elems);

    p_unit_haar_ramp_16_approximation_l3 = ippsMalloc_32f(n_elems);
    read_vector_file("unit haar ramp 16 approximation l3.txt", p_unit_haar_ramp_16_approximation_l3, n_elems);

    p_unit_haar_ramp_16_detail_l3 = ippsMalloc_32f(n_elems);
    read_vector_file("unit haar ramp 16 detail l3.txt", p_unit_haar_ramp_16_detail_l3, n_elems);

    // Read the expected results files into the associated arrays
    p_step_16 = ippsMalloc_32f(n_elems);
    read_vector_file("step 16.txt", p_step_16, n_elems);

    p_unit_haar_step_16_approximation_l1 = ippsMalloc_32f(n_elems);
    read_vector_file("unit haar step 16 approximation l1.txt", p_unit_haar_step_16_approximation_l1, n_elems);

    p_unit_haar_step_16_detail_l1 = ippsMalloc_32f(n_elems);
    read_vector_file("unit haar step 16 detail l1.txt", p_unit_haar_step_16_detail_l1, n_elems);

    p_unit_haar_step_16_approximation_l2 = ippsMalloc_32f(n_elems);
    read_vector_file("unit haar step 16 approximation l2.txt", p_unit_haar_step_16_approximation_l2, n_elems);

    p_unit_haar_step_16_detail_l2 = ippsMalloc_32f(n_elems);
    read_vector_file("unit haar step 16 detail l2.txt", p_unit_haar_step_16_detail_l2, n_elems);

    p_unit_haar_step_16_approximation_l3 = ippsMalloc_32f(n_elems);
    read_vector_file("unit haar step 16 approximation l3.txt", p_unit_haar_step_16_approximation_l3, n_elems);

    p_unit_haar_step_16_detail_l3 = ippsMalloc_32f(n_elems);
    read_vector_file("unit haar step 16 detail l3.txt", p_unit_haar_step_16_detail_l3, n_elems);

    p_random_1024 = ippsMalloc_32f(1024);
    read_vector_file("random 1024.txt", p_random_1024, 1024);

  }

  virtual void SetUp()
  {
  }

};

TEST_F(Test_StationaryHaarTransformer, fwd_ramp_level_1)
{
  p_sht1d->unit_haar_one_level_analysis(p_ramp_16, p_approx, p_detail, n_elems, 0);
  ASSERT_TRUE(all_equal(p_unit_haar_ramp_16_approximation_l1, p_approx, n_elems));
  ASSERT_TRUE(all_equal(p_unit_haar_ramp_16_detail_l1, p_detail, n_elems));
}

TEST_F(Test_StationaryHaarTransformer, inv_ramp_level_1)
{
  Ipp32f * result = new Ipp32f[n_elems];
  p_sht1d->unit_haar_one_level_synthesis(p_unit_haar_ramp_16_approximation_l1,
    p_unit_haar_ramp_16_detail_l1,
    result,
    n_elems,
    0);
  ASSERT_TRUE(all_equal(p_ramp_16, result, n_elems));
  delete[] result;
}

TEST_F(Test_StationaryHaarTransformer, fwd_inv_ramp_level_1)
{
  p_sht1d->unit_haar_one_level_analysis(p_ramp_16, p_approx, p_detail, n_elems, 0);
  Ipp32f * result = new Ipp32f[n_elems];
  p_sht1d->unit_haar_one_level_synthesis(p_approx, p_detail, result, n_elems, 0);
  ASSERT_TRUE(all_equal(p_ramp_16, result, n_elems));
  delete[] result;
}

TEST_F(Test_StationaryHaarTransformer, fwd_inv_ramp_level_3)
{
  p_sht1d->unit_haar_one_level_analysis(p_unit_haar_ramp_16_approximation_l2, p_approx, p_detail, n_elems, 0);
  Ipp32f * result = new Ipp32f[n_elems];
  p_sht1d->unit_haar_one_level_synthesis(p_approx, p_detail, result, n_elems, 0);
  ASSERT_TRUE(all_equal(p_unit_haar_ramp_16_approximation_l2, result, n_elems));
  delete[] result;
}

TEST_F(Test_StationaryHaarTransformer, fwd_step_level_1)
{
  p_sht1d->unit_haar_one_level_analysis(p_step_16, p_approx, p_detail, n_elems, 0);
  ASSERT_TRUE(all_equal(p_unit_haar_step_16_approximation_l1, p_approx, n_elems));
  ASSERT_TRUE(all_equal(p_unit_haar_step_16_detail_l1, p_detail, n_elems));
}

TEST_F(Test_StationaryHaarTransformer, inv_step_level_1)
{
  Ipp32f * result = new Ipp32f[n_elems];
  p_sht1d->unit_haar_one_level_synthesis(p_unit_haar_step_16_approximation_l1,
    p_unit_haar_step_16_detail_l1,
    result,
    n_elems,
    0);
  ASSERT_TRUE(all_equal(p_step_16, result, n_elems));
  delete[] result;
}

TEST_F(Test_StationaryHaarTransformer, fwd_inv_step_level_1)
{
  p_sht1d->unit_haar_one_level_analysis(p_step_16, p_approx, p_detail, n_elems, 0);
  Ipp32f * result = new Ipp32f[n_elems];
  p_sht1d->unit_haar_one_level_synthesis(p_approx, p_detail, result, n_elems, 0);
  ASSERT_TRUE(all_equal(p_step_16, result, n_elems));
  delete[] result;
}

TEST_F(Test_StationaryHaarTransformer, fwd_inv_step_level_3)
{
  p_sht1d->unit_haar_one_level_analysis(p_unit_haar_step_16_approximation_l2, p_approx, p_detail, n_elems, 0);
  Ipp32f * result = new Ipp32f[n_elems];
  p_sht1d->unit_haar_one_level_synthesis(p_approx, p_detail, result, n_elems, 0);
  ASSERT_TRUE(all_equal(p_unit_haar_step_16_approximation_l2, result, n_elems));
  delete[] result;
}

TEST_F(Test_StationaryHaarTransformer, unit_haar_swt_ramp_level_3)
{
  p_sht1d->unit_haar_swt(3, p_ramp_16, 16);
  ASSERT_TRUE(all_equal(p_sht1d->_approx[0], p_unit_haar_ramp_16_approximation_l1, n_elems));
  ASSERT_TRUE(all_equal(p_sht1d->_detail[0], p_unit_haar_ramp_16_detail_l1, n_elems));
  ASSERT_TRUE(all_equal(p_sht1d->_approx[1], p_unit_haar_ramp_16_approximation_l2, n_elems));
  ASSERT_TRUE(all_equal(p_sht1d->_detail[1], p_unit_haar_ramp_16_detail_l2, n_elems));
  ASSERT_TRUE(all_equal(p_sht1d->_approx[2], p_unit_haar_ramp_16_approximation_l3, n_elems));
  ASSERT_TRUE(all_equal(p_sht1d->_detail[2], p_unit_haar_ramp_16_detail_l3, n_elems));
}

TEST_F(Test_StationaryHaarTransformer, unit_haar_swt_step_level_3)
{
  p_sht1d->unit_haar_swt(3, p_step_16, 16);
  ASSERT_TRUE(all_equal(p_sht1d->_approx[0], p_unit_haar_step_16_approximation_l1, n_elems));
  ASSERT_TRUE(all_equal(p_sht1d->_detail[0], p_unit_haar_step_16_detail_l1, n_elems));
  ASSERT_TRUE(all_equal(p_sht1d->_approx[1], p_unit_haar_step_16_approximation_l2, n_elems));
  ASSERT_TRUE(all_equal(p_sht1d->_detail[1], p_unit_haar_step_16_detail_l2, n_elems));
  ASSERT_TRUE(all_equal(p_sht1d->_approx[2], p_unit_haar_step_16_approximation_l3, n_elems));
  ASSERT_TRUE(all_equal(p_sht1d->_detail[2], p_unit_haar_step_16_detail_l3, n_elems));
}

TEST_F(Test_StationaryHaarTransformer, unit_haar_swt_fwd_inv_step_level_3)
{
  p_sht1d->unit_haar_swt(3, p_step_16, 16);
  Ipp32f * result = new Ipp32f[n_elems];
  p_sht1d->unit_haar_iswt(3, result, 16);
  ASSERT_TRUE(all_equal(p_step_16, result, n_elems));
}

TEST_F(Test_StationaryHaarTransformer, unit_haar_swt_fwd_inv_ramp_level_3)
{
  p_sht1d->unit_haar_swt(3, p_ramp_16, 16);
  Ipp32f * result = new Ipp32f[n_elems];
  p_sht1d->unit_haar_iswt(3, result, 16);
  ASSERT_TRUE(all_equal(p_ramp_16, result, n_elems));
}

TEST_F(Test_StationaryHaarTransformer, unit_haar_swt_fwd_inv_random_level_3)
{
  p_sht1d->unit_haar_swt(3, p_random_1024, 1024);
  Ipp32f * result = new Ipp32f[1024];
  p_sht1d->unit_haar_iswt(3, result, 1024);
  ASSERT_TRUE(all_equal(p_random_1024, result, 1024, 1.0E-6F));
}

int main(int argc, char * argv[])
{
  // Seed the random number generator at 1 so we always get the same sequence of values from it.
  srand(1);

  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
