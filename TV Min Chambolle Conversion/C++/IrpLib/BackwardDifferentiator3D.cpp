#include "BackwardDifferentiator3D.h"


template <typename calc_precision>
void BackwardDifferentiator3D<calc_precision>::backward_diff_x_3d(calc_precision const * const volume_in,
                                                                  calc_precision * volume_out)
{
  auto const n_elements_per_plane = n_x * n_y;
  for (size_t idx_z = 0; idx_z < n_z; ++idx_z)
  {
    auto const offset_z = idx_z * n_elements_per_plane;
    for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
    {
      auto const offset_y = idx_y * n_x + offset_z;
      for (size_t idx_x = 0; idx_x < n_x - 1; ++idx_x)
      {
        auto index = idx_x + offset_y;
        volume_out[index] = volume_in[index + 1] - volume_in[index];
      }

      // Set the last difference element in the X dimension to 0, implementing a reflected boundary condition
      volume_out[n_x - 1 + offset_y] = calc_precision{0};
    }
  }
}

template void BackwardDifferentiator3D<float>::backward_diff_x_3d(float const * const volume_in, float * volume_out);
template void BackwardDifferentiator3D<double>::backward_diff_x_3d(double const * const volume_in,
                                                                   double * volume_out);


template <typename calc_precision>
void BackwardDifferentiator3D<calc_precision>::backward_diff_y_3d(calc_precision const * const volume_in,
                                                                  calc_precision * volume_out)
{
  auto const n_elements_per_plane = n_x * n_y;
  for (size_t idx_z = 0; idx_z < n_z; ++idx_z)
  {
    auto const offset_z = idx_z * n_elements_per_plane;
    for (size_t idx_y = 0; idx_y < n_y - 1; ++idx_y)
    {
      auto const offset_y = idx_y * n_x + offset_z;
      for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
      {
        auto index = idx_x + offset_y;
        volume_out[index] = volume_in[index + n_x] - volume_in[index];
      }
    }

    // Set the last difference element in the Y dimension to 0, implementing a reflected boundary condition
    auto const offset_y = (n_y - 1) * n_x + offset_z;
    for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
    {
      auto index = idx_x + offset_y;
      volume_out[index] = calc_precision{0};
    }
  }
}

template void BackwardDifferentiator3D<float>::backward_diff_y_3d(float const * const volume_in, float * volume_out);
template void BackwardDifferentiator3D<double>::backward_diff_y_3d(double const * const volume_in,
                                                                   double * volume_out);


template <typename calc_precision>
void BackwardDifferentiator3D<calc_precision>::backward_diff_z_3d(calc_precision const * const volume_in,
                                                                  calc_precision * volume_out)
{
  auto const n_elements_per_plane = n_x * n_y;
  for (size_t idx_z = 0; idx_z < n_z - 1; ++idx_z)
  {
    auto const offset_z = idx_z * n_elements_per_plane;
    for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
    {
      auto const offset_y = idx_y * n_x + offset_z;
      for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
      {
        auto index = idx_x + offset_y;
        volume_out[index] = volume_in[index + n_elements_per_plane] - volume_in[index];
      }
    }
  }

  // Set the last difference element in the Z dimension to 0, implementing a reflected boundary condition
  auto const offset_z = (n_z - 1) * n_elements_per_plane;
  for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
  {
    auto const offset_y = idx_y * n_x + offset_z;
    for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
    {
      auto index = idx_x + offset_y;
      volume_out[index] = calc_precision{0};
    }
  }
}

template void BackwardDifferentiator3D<float>::backward_diff_z_3d(float const * const volume_in, float * volume_out);
template void BackwardDifferentiator3D<double>::backward_diff_z_3d(double const * const volume_in,
                                                                   double * volume_out);
