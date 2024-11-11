#include "mkl.h"

#include "StationaryHaarTransformer1D.h"

StationaryHaarTransformer1D::StationaryHaarTransformer1D(int max_levels, int max_length) :
  _max_levels(max_levels), _max_length(max_length)

{
  _approx = new float*[_max_levels];
  _detail = new float*[_max_levels];
  for (int i = 0; i < _max_levels; ++i)
  {
    _approx[i] = ippsMalloc_32f(_max_length);
    _detail[i] = ippsMalloc_32f(_max_length);
  }
}


StationaryHaarTransformer1D::~StationaryHaarTransformer1D(void)
{
  for (int i = 0; i < _max_levels; ++i)
  {
    delete[] _approx[i];
    delete[] _detail[i];
  }

  delete[] _approx;
  delete[] _detail;
}

// This implementation of the Haar wavelet decomposition uses 1 as a coefficient for the analysis filters.
// The length of source array, approx_in must be an integer multiple of 2^(level-1)
void StationaryHaarTransformer1D::unit_haar_swt(int n_levels, const float * p_signal, int n_elems)
{
  const float * p_src = p_signal;
  for (int idx_level = 0; idx_level < n_levels; ++idx_level)
  {
    unit_haar_one_level_analysis(p_src, _approx[idx_level], _detail[idx_level], n_elems, idx_level);
    p_src = _approx[idx_level];
  }
}

// Compute a single level of the Haar Stationary wavelet transform.  Given an approximation signal at N the next coarser
// level (N+1) approximation and detail signals are computed.
//
// level : the level (N) of the input approximation, for original signal this will be 0
void StationaryHaarTransformer1D::unit_haar_one_level_analysis(const float * approx_in,
                                                               float * approx_out,
                                                               float * detail,
                                                               int length,
                                                               int level)
{
  const int shift = 1 << level;
  const int overlapped = length - shift;
  // To eliminate the need for copying the input vector to a new memory location, the loop is split into two parts.
  // The first part handles the non-periodized portion of the convolution, the second loop handles the portion of the
  // convolution where the second coefficient is applied to the periodically extended portion of the vector.
  vsSub(overlapped, approx_in, approx_in + shift, detail);
  vsAdd(overlapped, approx_in, approx_in + shift, approx_out);
  //for (int i = 0; i < overlapped; ++i)
  //{
  //  detail[i] = approx_in[i] - approx_in[i + shift];
  //  approx_out[i] = approx_in[i] + approx_in[i + shift];
  //}

  //vsSub(length - overlapped, approx_in + overlapped, approx_in, detail);
  //vsAdd(length - overlapped, approx_in + overlapped, approx_in, approx_out);

  for (int i = overlapped, j = 0; i < length; ++i, ++j)
  {
    detail[i] = approx_in[i] - approx_in[j];
    approx_out[i] = approx_in[i] + approx_in[j];
  }

}

// Note this destroys the existing approximation coefficients as it reconstructs the signal
void StationaryHaarTransformer1D::unit_haar_iswt(int n_levels, float * p_signal, int n_elems)
{
  for (int idx_level = n_levels - 1; idx_level > 0; --idx_level)
  {
    unit_haar_one_level_synthesis(_approx[idx_level], _detail[idx_level], _approx[idx_level - 1], n_elems, idx_level);
  }
  
  // This final synthesis step places the result into the output array
  unit_haar_one_level_synthesis(_approx[0], _detail[0], p_signal, n_elems, 0);
}

// Compute a single level of the Haar Stationary inverse wavelet transform.  Given the approximation and detail signals
// at N the next finer level (N-1) approximation and detail signals are computed.
//
// level : the level (N-1) of the output approximation to be computed
void StationaryHaarTransformer1D::unit_haar_one_level_synthesis(const float * approx_in,
                                                                const float * detail_in,
                                                                float * approx_out,
                                                                int length,
                                                                int level)
{
  const float scale = 0.25;
  int shift = 1 << level;
  for (int i = 0, j = length - shift; i < shift; ++i, ++j)
  {
    approx_out[i] = scale * (approx_in[i] + detail_in[i] + approx_in[j] - detail_in[j]);
  }
  // Compute the periodically extended portion of the output
  for (int i = shift, j = 0; i < length; ++i, ++j)
  {
    approx_out[i] = scale * (approx_in[i] + detail_in[i] + approx_in[j] - detail_in[j]);
  }
}
