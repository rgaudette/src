#include "gtest/gtest.h"

#include "../../IrpLib/BackwardDifferentiator3D.h"

using namespace std;

class TestBackwardDifferentiator3DSmallIncrementalFloat : public ::testing::Test
{
  public:
    size_t static const n_x = 5;
    size_t static const n_y = 4;
    size_t static const n_z = 3;
    size_t static const n_elements_per_plane = n_x * n_y;
    size_t static const n_elements = n_elements_per_plane * n_z;
    float volume_out[n_elements];

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


TEST_F(TestBackwardDifferentiator3DSmallIncrementalFloat, x_diff)
{
  BackwardDifferentiator3D<float> bd3d(n_x, n_y, n_z);

  bd3d.backward_diff_x_3d(volume_in, volume_out);

  // validate the differences
  for (size_t idx_z = 0; idx_z < n_z; ++idx_z)
  {
    auto const offset_z = idx_z * n_elements_per_plane;
    for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
    {
      auto const y_offset = idx_y * n_x + offset_z;
      for (size_t idx_x = 0; idx_x < n_x - 1; ++idx_x)
      {
        auto const index = idx_x + y_offset;
        EXPECT_FLOAT_EQ(volume_out[index], 1.0F) << "At volume out index: ["
                                                 << idx_x << ", " << idx_y << ", " << idx_z << "]";
      }

      // The last difference element in the X dimension is 0, implementing a reflected boundary condition
      auto const index = n_x - 1 + y_offset;
      EXPECT_FLOAT_EQ(volume_out[index], 0.0F) << "at volume_out index[ix, iy, iz]: ["
                                               << n_x - 1 << ", " << idx_y << ", " << idx_z << "]";
    }
  }
}


TEST_F(TestBackwardDifferentiator3DSmallIncrementalFloat, y_diff)
{
  BackwardDifferentiator3D<float> bd3d(n_x, n_y, n_z);

  bd3d.backward_diff_y_3d(volume_in, volume_out);

  // validate the differences
  for (size_t idx_z = 0; idx_z < n_z; ++idx_z)
  {
    auto const offset_z = idx_z * n_elements_per_plane;
    for (size_t idx_y = 0; idx_y < n_y - 1; ++idx_y)
    {
      auto const y_offset = idx_y * n_x + offset_z;
      for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
      {
        auto const index = idx_x + y_offset;
        EXPECT_FLOAT_EQ(volume_out[index], float(n_x)) << "At volume out index: ["
                                                       << idx_x << ", " << idx_y << ", " << idx_z << "]";
      }
    }

    // The last difference element in the Y dimension is 0, implementing a reflected boundary condition
    auto const y_offset = (n_y - 1) * n_x + offset_z;
    for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
    {
      auto const index = idx_x + y_offset;
      EXPECT_FLOAT_EQ(volume_out[index], 0.0F) << "At volume out index: ["
                                               << idx_x << ", " << n_y - 1 << ", " << idx_z << "]";
    }
  }
}


TEST_F(TestBackwardDifferentiator3DSmallIncrementalFloat, z_diff)
{
  BackwardDifferentiator3D<float> bd3d(n_x, n_y, n_z);

  bd3d.backward_diff_z_3d(volume_in, volume_out);

  // validate the differences
  for (size_t idx_z = 0; idx_z < n_z - 1; ++idx_z)
  {
    auto const offset_z = idx_z * n_elements_per_plane;
    for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
    {
      auto const y_offset = idx_y * n_x + offset_z;
      for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
      {
        auto const index = idx_x + y_offset;
        EXPECT_FLOAT_EQ(volume_out[index], float(n_elements_per_plane)) << "At volume out index: ["
                                                                        << idx_x << ", " << idx_y << ", " << idx_z << "]";
      }
    }
  }

  // The last difference element in the Z dimension is 0, implementing a reflected boundary condition
  auto const offset_z = (n_z - 1) * n_elements_per_plane;
  for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
  {
    auto const y_offset = idx_y * n_x + offset_z;
    for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
    {
      auto const index = idx_x + y_offset;
      EXPECT_FLOAT_EQ(volume_out[index], 0.0F) << "At volume out index: ["
                                               << idx_x << ", " << idx_y << ", " << n_z - 1 << "]";
    }
  }
}


class TestBackwardDifferentiator3DSmallSquaredFloat : public ::testing::Test
{
  public:
    size_t static const n_x = 5;
    size_t static const n_y = 4;
    size_t static const n_z = 3;
    size_t static const n_elements_per_plane = n_x * n_y;
    size_t static const n_elements = n_elements_per_plane * n_z;
    float volume_out[n_elements];

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
            volume_in[index] = value * value;
            value++;
          }
        }
      }
    }
};


TEST_F(TestBackwardDifferentiator3DSmallSquaredFloat, x_diff)
{
  BackwardDifferentiator3D<float> bd3d(n_x, n_y, n_z);

  bd3d.backward_diff_x_3d(volume_in, volume_out);

  // validate the differences
  for (size_t idx_z = 0; idx_z < n_z; ++idx_z)
  {
    auto const z_offset = idx_z * n_elements_per_plane;
    for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
    {
      auto const y_offset = idx_y * n_x + z_offset;
      for (size_t idx_x = 0; idx_x < n_x - 1; ++idx_x)
      {
        auto const index = idx_x + y_offset;
        auto const leading = volume_in[index + 1];
        auto const lagging = volume_in[index];
        auto difference = leading - lagging;
        //difference = idx_x * 2 + 1;
        EXPECT_FLOAT_EQ(volume_out[index], float(difference)) << "At volume out index: ["
                                                              << idx_x << ", " << idx_y << ", " << idx_z << "]";
      }

      // The last difference element in the X dimension is 0, implementing a reflected boundary condition
      auto const index = n_x - 1 + y_offset;
      EXPECT_FLOAT_EQ(volume_out[index], 0.0F) << "at volume_out index[ix, iy, iz]: ["
                                               << n_x - 1 << ", " << idx_y << ", " << idx_z << "]";
    }
  }
}

int main(int argc, char ** argv)
{
  ::testing::InitGoogleTest(&argc, argv);
  int status = RUN_ALL_TESTS();
  return status;
}

