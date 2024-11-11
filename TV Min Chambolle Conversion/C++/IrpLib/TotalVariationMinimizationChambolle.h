#pragma once
#include <iostream>

#include "BackwardDifferentiator3D.h"

template <typename T>
struct TotalVariationMinimizationChambolle
{
    size_t n_x;
    size_t n_y;
    size_t n_z;
    size_t n_volume;
    size_t n_elements_per_plane;

    T * difference_x;
    T * difference_y;
    T * difference_z;
    T * p_x;
    T * p_y;
    T * p_z;
    T * neg_div;
    T * estimate;

    // The step size for each iteration
    T lambda;

    // The backwards 3D differentiator
    BackwardDifferentiator3D<T> diff_3d;

    TotalVariationMinimizationChambolle(size_t n_x, size_t n_y, size_t n_z)
      : n_x(n_x), n_y(n_y), n_z(n_z)
    {
      n_elements_per_plane = n_x * n_y;
      n_volume = n_elements_per_plane * n_z;
      diff_3d.set_dimensions(n_x, n_y, n_z);
    }

    size_t initialize(T lambda_in);

    void solve(T * estimate_in_out, int n_iter);

  private:

    void zero_buffer(T * buffer)
    {
      for (size_t idx = 0; idx < n_volume; ++idx)
      {
        buffer[idx] = T(0);
      }
    }

    void square(T * buffer)
    {
      for (size_t idx = 0; idx < n_volume; ++idx)
      {
        buffer[idx] = buffer[idx] * buffer[idx];
      }
    }

    void print_volume(T * buffer)
    {
      using namespace std;
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
            cout << buffer[index] << " ";
          }
          cout << endl;
        }
        cout << endl;
      }
    }
};