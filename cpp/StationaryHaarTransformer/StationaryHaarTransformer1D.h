#pragma once

#include "ipp.h"


class StationaryHaarTransformer1D
{
  public:
    StationaryHaarTransformer1D(int max_levels, int max_length);
    ~StationaryHaarTransformer1D(void);
    void StationaryHaarTransformer1D::unit_haar_swt(int n_levels, const float * p_signal, int n_elems);
    void StationaryHaarTransformer1D::unit_haar_iswt(int n_levels, float * p_signal, int n_elems);

    void static StationaryHaarTransformer1D::unit_haar_one_level_analysis(const float * approx_in,
      float * approx_out,
      float * detail,
      int length,
      int level);

    void static StationaryHaarTransformer1D::unit_haar_one_level_synthesis(const float * approx_in,
      const float * detail_in,
      float * approx_out,
      int length,
      int level);


  private:
    int _max_levels;
    int _max_length;
    float * * _approx;
    float * * _detail;

    // These are the mangled GoogleTest class that need access to the coefficient structures
    friend class Test_StationaryHaarTransformer_fwd_inv_ramp_level_3_Test;
    friend class Test_StationaryHaarTransformer_fwd_inv_step_level_3_Test;
    friend class Test_StationaryHaarTransformer_unit_haar_swt_ramp_level_3_Test;
    friend class Test_StationaryHaarTransformer_unit_haar_swt_step_level_3_Test;
    StationaryHaarTransformer1D();
};
