#pragma once

template <typename calc_precision>
class BackwardDifferentiator3D
{
  public:
    BackwardDifferentiator3D() = default;
    BackwardDifferentiator3D(size_t n_x, size_t n_y, size_t n_z) : n_x(n_x), n_y(n_y), n_z(n_z) {}

    void set_dimensions(size_t n_x_in, size_t n_y_in, size_t n_z_in)
    {
      n_x = n_x_in;
      n_y = n_y_in;
      n_z = n_z_in;
    }

    void backward_diff_x_3d(calc_precision const * const volume_in, calc_precision * volume_out);
    void backward_diff_y_3d(calc_precision const * const volume_in, calc_precision * volume_out);
    void backward_diff_z_3d(calc_precision const * const volume_in, calc_precision * volume_out);

  private:
    size_t n_x;
    size_t n_y;
    size_t n_z;
};
