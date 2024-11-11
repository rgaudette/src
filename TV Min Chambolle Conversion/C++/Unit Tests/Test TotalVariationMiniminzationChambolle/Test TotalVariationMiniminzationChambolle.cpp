#include <iostream>
#include "gtest/gtest.h"

#include "../../IrpLib/TotalVariationMinimizationChambolle.h"


class TestTotalVariationMinimizationChambolleSmallIncrementalFloat : public ::testing::Test
{
  public:
    size_t static const n_x = 5;
    size_t static const n_y = 4;
    size_t static const n_z = 3;
    size_t static const n_elements_per_plane = n_x * n_y;
    size_t static const n_elements = n_elements_per_plane * n_z;
    float volume_in[n_elements];

  private:

    virtual void SetUp() override
    {
      auto value = 0.0F;
      for (size_t idx_z = 0; idx_z < n_z; ++idx_z)
      {
        auto const z_offset = idx_z * n_elements_per_plane;
        for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
        {
          auto const y_offset = idx_y * n_x + z_offset;
          for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
          {
            auto const index = idx_x + y_offset;
            volume_in[index] = value;
            value++;
          }
        }
      }
    }
};


//TEST_F(TestTotalVariationMinimizationChambolleSmallIncrementalFloat, lambda_0p1_n_iter_1)
//{
//  using namespace std;
//
//  TotalVariationMinimizationChambolle<float> tv_min_chambolle(n_x, n_y, n_z);
//  tv_min_chambolle.initialize(0.1F);
//  tv_min_chambolle.solve(volume_in, 1);
//
//  // validate the differences
//  cout << "result:" << endl;
//  for (size_t idx_z = 0; idx_z < n_z; ++idx_z)
//  {
//    auto const offset_z = idx_z * n_elements_per_plane;
//    for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
//    {
//      auto const y_offset = idx_y * n_x + offset_z;
//      for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
//      {
//        auto const index = idx_x + y_offset;
//        cout << volume_in[index] << " ";
//      }
//      cout << endl;
//    }
//    cout << endl;
//  }
//}


//TEST_F(TestTotalVariationMinimizationChambolleSmallIncrementalFloat, lambda_0p1_n_iter_2)
//{
//  using namespace std;
//
//  TotalVariationMinimizationChambolle<float> tv_min_chambolle(n_x, n_y, n_z);
//  tv_min_chambolle.initialize(0.1F);
//  tv_min_chambolle.solve(volume_in, 2);
//
//  // validate the differences
//  for (size_t idx_z = 0; idx_z < n_z; ++idx_z)
//  {
//    auto const offset_z = idx_z * n_elements_per_plane;
//    for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
//    {
//      auto const y_offset = idx_y * n_x + offset_z;
//      for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
//      {
//        auto const index = idx_x + y_offset;
//        cout << volume_in[index] << " ";
//      }
//      cout << endl;
//    }
//    cout << endl;
//  }
//}
//
//
class TestTotalVariationMinimizationChambolleSmallIncrementalDouble : public ::testing::Test
{
  public:
    size_t static const n_x = 5;
    size_t static const n_y = 4;
    size_t static const n_z = 3;
    size_t static const n_elements_per_plane = n_x * n_y;
    size_t static const n_elements = n_elements_per_plane * n_z;
    double volume_in[n_elements];

  private:

    virtual void SetUp() override
    {
      auto value = 0.0F;
      for (size_t idx_z = 0; idx_z < n_z; ++idx_z)
      {
        auto const z_offset = idx_z * n_elements_per_plane;
        for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
        {
          auto const y_offset = idx_y * n_x + z_offset;
          for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
          {
            auto const index = idx_x + y_offset;
            volume_in[index] = value;
            value++;
          }
        }
      }
    }
};

TEST_F(TestTotalVariationMinimizationChambolleSmallIncrementalDouble, lambda_0p1_n_iter_2)
{
  using namespace std;

  TotalVariationMinimizationChambolle<double> tv_min_chambolle(n_x, n_y, n_z);
  tv_min_chambolle.initialize(0.1F);
  tv_min_chambolle.solve(volume_in, 2);

  // validate the differences
  for (size_t idx_z = 0; idx_z < n_z; ++idx_z)
  {
    auto const offset_z = idx_z * n_elements_per_plane;
    for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
    {
      auto const y_offset = idx_y * n_x + offset_z;
      for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
      {
        auto const index = idx_x + y_offset;
        cout << volume_in[index] << " ";
      }
      cout << endl;
    }
    cout << endl;
  }
}
int main(int argc, char ** argv)
{
  ::testing::InitGoogleTest(&argc, argv);
  int status = RUN_ALL_TESTS();
  return status;
}

