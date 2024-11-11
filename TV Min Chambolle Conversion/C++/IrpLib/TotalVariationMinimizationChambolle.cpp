#include <cmath>
#include <cstdlib>

#include "TotalVariationMinimizationChambolle.h"

template <typename T>
size_t TotalVariationMinimizationChambolle<T>::initialize(T lambda_in)
{
  lambda = lambda_in;

  // Debug
  using namespace std;
  size_t bytes = 0;

  // Allocate the necessary memory in order of largest first on the CUDA device
  // Debug
  bytes += size_t(n_volume) * sizeof(T);
  //cout << "Attempting to allocate buffer_0: " << size_t(n_volume) * sizeof(T)
  //     << " bytes, total: " << bytes << endl;
  difference_x = static_cast<T *>(malloc(n_volume * sizeof(T)));

  bytes += size_t(n_volume) * sizeof(T);
  //cout << "Attempting to allocate buffer_0: " << size_t(n_volume) * sizeof(T)
  //     << " bytes, total: " << bytes << endl;
  difference_y = static_cast<T *>(malloc(n_volume * sizeof(T)));

  bytes += size_t(n_volume) * sizeof(T);
  //cout << "Attempting to allocate buffer_0: " << size_t(n_volume) * sizeof(T)
  //     << " bytes, total: " << bytes << endl;
  difference_z = static_cast<T *>(malloc(n_volume * sizeof(T)));

  bytes += size_t(n_volume) * sizeof(T);
  //cout << "Attempting to allocate buffer_0: " << size_t(n_volume) * sizeof(T)
  //     << " bytes, total: " << bytes << endl;
  p_x = static_cast<T *>(malloc(n_volume * sizeof(T)));

  bytes += size_t(n_volume) * sizeof(T);
  //cout << "Attempting to allocate buffer_0: " << size_t(n_volume) * sizeof(T)
  //     << " bytes, total: " << bytes << endl;
  p_y = static_cast<T *>(malloc(n_volume * sizeof(T)));

  bytes += size_t(n_volume) * sizeof(T);
  //cout << "Attempting to allocate buffer_0: " << size_t(n_volume) * sizeof(T)
  //     << " bytes, total: " << bytes << endl;
  p_z = static_cast<T *>(malloc(n_volume * sizeof(T)));

  bytes += size_t(n_volume) * sizeof(T);
  //cout << "Attempting to allocate buffer_0: " << size_t(n_volume) * sizeof(T)
  //     << " bytes, total: " << bytes << endl;
  neg_div = static_cast<T *>(malloc(n_volume * sizeof(T)));

  bytes += size_t(n_volume) * sizeof(T);
  //cout << "Attempting to allocate buffer_0: " << size_t(n_volume) * sizeof(T)
  //     << " bytes, total: " << bytes << endl;
  estimate = static_cast<T *>(malloc(n_volume * sizeof(T)));

  return bytes;
}

template size_t TotalVariationMinimizationChambolle<float>::initialize(float lambda_in);
template size_t TotalVariationMinimizationChambolle<double>::initialize(double lambda_in);

template <typename T>
void TotalVariationMinimizationChambolle<T>::solve(T * estimate_in_out, int n_iter)
{
  using namespace std;
  zero_buffer(difference_x);
  zero_buffer(difference_y);
  zero_buffer(difference_z);
  zero_buffer(p_x);
  zero_buffer(p_y);
  zero_buffer(p_z);
  zero_buffer(neg_div);

  T const tau = T(1) / T(6);
  T const weight = tau / lambda;

  auto i = 0;
  cout << "interation: " << i << endl;
  while (i < n_iter)
  {
    if (i > 0)
    {
      for (int idx = 0; idx < n_volume; ++idx)
      {
        neg_div[idx] = T(-1) * (p_x[idx] + p_y[idx] + p_z[idx]);
      }
//      cout << "initial neg_div:" << endl;
//      print_volume(neg_div);

      for (size_t idx_z = 0; idx_z < n_z - 1; ++idx_z)
      {
        auto const p_offset_z = idx_z * n_elements_per_plane;
        for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
        {
          auto const p_offset_y = idx_y * n_x + p_offset_z;
          for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
          {
            auto const p_index = idx_x + p_offset_y;
            neg_div[p_index + n_elements_per_plane] += p_z[p_index];
          }
        }
      }
//      cout << "z inc neg_div:" << endl;
//      print_volume(neg_div);

      for (size_t idx_z = 0; idx_z < n_z; ++idx_z)
      {
        auto const p_offset_z = idx_z * n_elements_per_plane;
        for (size_t idx_y = 0; idx_y < n_y - 1; ++idx_y)
        {
          auto const p_offset_y = idx_y * n_x + p_offset_z;
          for (size_t idx_x = 0; idx_x < n_x; ++idx_x)
          {
            auto const p_index = idx_x + p_offset_y;
            neg_div[p_index + n_x] += p_y[p_index];
          }
        }
      }
//      cout << "y inc neg_div:" << endl;
//      print_volume(neg_div);

      for (size_t idx_z = 0; idx_z < n_z; ++idx_z)
      {
        auto const p_offset_z = idx_z * n_elements_per_plane;
        for (size_t idx_y = 0; idx_y < n_y; ++idx_y)
        {
          auto const p_offset_y = idx_y * n_x + p_offset_z;
          for (size_t idx_x = 0; idx_x < n_x - 1; ++idx_x)
          {
            auto const p_index = idx_x + p_offset_y;
            neg_div[p_index + 1] += p_x[p_index];
          }
        }
      }
//      cout << "x inc neg_div:" << endl;
//      print_volume(neg_div);

      for (int idx = 0; idx < n_volume; ++idx)
      {
        estimate[idx] = estimate_in_out[idx] + neg_div[idx];
      }
//      cout << "estimate update:" << endl;
//      print_volume(estimate);
    }
    else
    {
      // Initial iteration, just copy the original volume into the working estimate
      for (int idx = 0; idx < n_volume; ++idx)
      {
        estimate[idx] = estimate_in_out[idx];
      }
    }

    // Compute the backward first difference for each dimension and update each p volume
    diff_3d.backward_diff_z_3d(estimate, difference_z);
//    cout << "diff_z:" << endl;
//    print_volume(difference_z);

    for (int idx = 0; idx < n_volume; ++idx)
    {
      p_z[idx] -= tau * difference_z[idx];
    }

    diff_3d.backward_diff_y_3d(estimate, difference_y);
//    cout << "diff_y:" << endl;
//    print_volume(difference_y);

    for (int idx = 0; idx < n_volume; ++idx)
    {
      p_y[idx] -= tau * difference_y[idx];
    }

    diff_3d.backward_diff_x_3d(estimate, difference_x);
//    cout << "diff_x:" << endl;
//    print_volume(difference_x);

    for (int idx = 0; idx < n_volume; ++idx)
    {
      p_x[idx] -= tau * difference_x[idx];
    }

//    cout << "pre-norm p_z:" << endl;
//    print_volume(p_z);
//    cout << "pre-norm p_y:" << endl;
//    print_volume(p_y);
//    cout << "pre-norm p_x:" << endl;
//    print_volume(p_x);

    // Compute the gradient norm, weight and update the p volumes
    for (int idx = 0; idx < n_volume; ++idx)
    {
      T const sum_of_squares = difference_x[idx] * difference_x[idx]
                               + difference_y[idx] * difference_y[idx]
                               + difference_z[idx] * difference_z[idx];
      T const p_divisor = weight * std::sqrt(sum_of_squares) + T(1);
      p_z[idx] /= p_divisor;
      p_y[idx] /= p_divisor;
      p_x[idx] /= p_divisor;
    }

//    cout << "post-norm p_z:" << endl;
//    print_volume(p_z);
//    cout << "post-norm p_y:" << endl;
//    print_volume(p_y);
//    cout << "post-norm p_x:" << endl;
//    print_volume(p_x);

    i++;
  }

  // Copy the working estimate back into the initial estimate
  for (int idx = 0; idx < n_volume; ++idx)
  {
    estimate_in_out[idx] = estimate[idx];
  }

}

template void TotalVariationMinimizationChambolle<float>::solve(float * estimate_in_out, int n_iter);
template void TotalVariationMinimizationChambolle<double>::solve(double * estimate_in_out, int n_iter);
