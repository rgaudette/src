// Test Fill Time.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <locale>

#include <ppl.h>
using namespace concurrency;

using index_type = long long int;
using volume_type = float;
index_type n_samples = 1000;

void add_sphere(index_type center_x,
                index_type center_y,
                index_type center_z,
                index_type radius_squared,
                volume_type coeff,
                volume_type * volume)
{
  index_type n_samples_per_plane = n_samples * n_samples;
  for (index_type iz = 0; iz < n_samples; ++iz)
  {
    index_type dz_sq = (iz - center_z) * (iz - center_z);
    index_type plane_offset = iz * n_samples_per_plane;
    for (index_type iy = 0; iy < n_samples; ++iy)
    {
      index_type dz_sq_plus_dy_sq = (iy - center_y) * (iy - center_y);
      index_type y_plane_offset = iy * n_samples + plane_offset;
      for (index_type ix = 0; ix < n_samples; ++ix)
      {
        index_type dist_sq = (ix - center_x) * (ix - center_x) + dz_sq_plus_dy_sq;
        if (dist_sq < radius_squared)
        {
          volume[ix + y_plane_offset] += coeff;
        }
      }
    }
  }
}


void parallel_add_sphere(index_type center_x,
                index_type center_y,
                index_type center_z,
                index_type radius_squared,
                volume_type coeff,
                volume_type * volume)
{
  index_type n_samples_per_plane = n_samples * n_samples;
  parallel_for(index_type(0), n_samples, [&](index_type iz)
  {
    index_type dz_sq = (iz - center_z) * (iz - center_z);
    index_type plane_offset = iz * n_samples_per_plane;
    for (index_type iy = 0; iy < n_samples; ++iy)
    {
      index_type dz_sq_plus_dy_sq = (iy - center_y) * (iy - center_y);
      index_type y_plane_offset = iy * n_samples + plane_offset;
      for (index_type ix = 0; ix < n_samples; ++ix)
      {
        index_type dist_sq = (ix - center_x) * (ix - center_x) + dz_sq_plus_dy_sq;
        if (dist_sq < radius_squared)
        {
          volume[ix + y_plane_offset] += coeff;
        }
      }
    }
  });
}


//  By default print numbers that are , separated at the thousands interval
struct thousands_sep : std::numpunct<char>
{
  char do_thousands_sep() const
  {
    return ',';
  }

  // Specify grouping digits in 3s
  std::string do_grouping() const
  {
    return "\3";
  }
};


int main()
{
  // Set the thousands separator
  std::cout.imbue(std::locale(std::locale(), new thousands_sep));

  // Allocate the volume and initialize to zero
  LARGE_INTEGER start_time;
  QueryPerformanceCounter(&start_time);

  index_type n_total_samples = n_samples * n_samples * n_samples;
  std::cout << "Total bytes to allocate: " << n_total_samples * sizeof(volume_type) << std::endl;

  volume_type * volume = new volume_type[n_samples * n_samples * n_samples];
  for (index_type i = 0; i < n_total_samples; ++n_total_samples)
  {
    volume[i] = 0.0;
  }

  LARGE_INTEGER stop_time;
  QueryPerformanceCounter(&stop_time);
  LARGE_INTEGER frequency;
  QueryPerformanceFrequency(&frequency);
  auto period = stop_time.QuadPart - start_time.QuadPart;
  double period_secs = static_cast<double>(period) / frequency.QuadPart;
  std::cout << "Allocation and zeroing time (secs): " << period_secs << std::endl;


  // Insert a sphere
  QueryPerformanceCounter(&start_time);

  add_sphere(50, 50, 50, 50 * 50, 0.5, volume);

  QueryPerformanceCounter(&stop_time);
  period = stop_time.QuadPart - start_time.QuadPart;
  period_secs = static_cast<double>(period) / frequency.QuadPart;
  std::cout << "add_sphere time (secs): " << period_secs << std::endl;

  QueryPerformanceCounter(&start_time);
  parallel_add_sphere(50, 50, 50, 50 * 50, 0.5, volume);

  QueryPerformanceCounter(&stop_time);
  period = stop_time.QuadPart - start_time.QuadPart;
  period_secs = static_cast<double>(period) / frequency.QuadPart;
  std::cout << "parallel_add_sphere time (secs): " << period_secs << std::endl;

  return 0;
}

