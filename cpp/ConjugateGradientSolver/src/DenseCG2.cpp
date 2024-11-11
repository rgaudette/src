#include "DenseCG2.hpp"
#include <ipp.h>
#include <cassert>
#include <float.h>
#include <iostream>
#include <new>

DenseCG2::DenseCG2(int const max_elements, int const n_restart)
  : _max_elements(max_elements)
  , _n_restart(n_restart)
  , _tmp(0)
  , _r(0)
  , _d(0)
  , _q(0)
{
  assert(max_elements > 0);
  assert(n_restart > 0);

  _tmp = ippsMalloc_32f(max_elements * 4);
  if (!_tmp)
  {
    throw std::bad_alloc();
  }

  _r = _tmp + max_elements;
  _d = _r + max_elements;
  _q = _d + max_elements;
}

DenseCG2::~DenseCG2()
{
  ippsFree(_tmp);
}

static float dot_product(float const * const x, int const n)
{
  float d;
  ippsDotProd_32f(x, x, n, &d);
  return d;
}

void DenseCG2::solve_normal_eq(
  float const * const impulse_response, // a PSF evaluated in a finite range, centered at zero
  int const n_impulse_response,     // must be odd and >= 3
  float const * const original_value, // the original signal values
  int const n_original_value,     // must be > 0
  float * const est_x, // initially filled with original_value
  // extended by (n_impulse_response/2) elements at both beginning and end side
  // (therefore n_est_x is assumed to be (n_original_value + n_impulse_response - 1)
  // on return, est_x is filled with the estimated values
  int const i_max,  // max iteration, must be > 0
  float const epsilon
)
{
  assert(impulse_response);
  assert(n_impulse_response >= 3);
  assert(n_impulse_response % 2 == 1);
  assert(original_value);
  assert(n_original_value > 0);
  assert(est_x);
  assert(i_max > 0);

  int const n_double_apron = n_impulse_response - 1;
  assert(_max_elements >= (n_original_value + 2 * n_double_apron));

  int const n_apron = n_double_apron / 2;
  int const n_extended = n_original_value + n_double_apron;

  // RJG Why set the ends of temp
  memset(_tmp, 0, n_double_apron * sizeof(float));
  memset(_tmp + n_extended, 0, n_double_apron * sizeof(float));

  // _tmp = convolve est_x with impulse_response
  {
    IppiSize const roi = { n_original_value, 1 };
    int const step = roi.width * sizeof(float);
    ippiFilterRow_32f_C1R(
      est_x + n_apron, 
      step,
      _tmp + n_double_apron,
      step,
      roi,
      impulse_response, 
      n_impulse_response,
      n_apron);
  }

  // _tmp = original_value - _tmp
  ippsSub_32f(
    _tmp + n_double_apron,
    original_value,
    _tmp + n_double_apron,
    n_original_value);

  // _r = convolve _tmp with impulse_response
  {
    IppiSize const roi = { n_extended, 1 };
    int const step = roi.width * sizeof(float);
    ippiFilterRow_32f_C1R(
      _tmp + n_apron,
      step,
      _r,
      step,
      roi,
      impulse_response,
      n_impulse_response,
      n_apron);
  }

  // delta_new = dotproduct(_r, _r)
  float delta_new = dot_product(_r, n_extended);

  // _d = _r
  ippsCopy_32f(_r, _d, n_extended);

  float const min_delta = epsilon * epsilon * delta_new;
  for (int i = 0; i < i_max && delta_new > min_delta; ++i)
  {
    // _tmp = convolve _d with impulse_response
    {
      IppiSize const roi = { n_original_value, 1 };
      int const step = roi.width * sizeof(float);
      ippiFilterRow_32f_C1R(
        _d + n_apron,
        step,
        _tmp + n_double_apron,
        step,
        roi,
        impulse_response,
        n_impulse_response,
        n_apron);
    }

    float const dot_tmp1 = dot_product(_tmp + n_double_apron, n_original_value);
    // alpha = delta_new / dotproduct(_tmp, _tmp)
    float const alpha = delta_new / dot_tmp1;

    // TODO: unit test this path
    if (!_finite(alpha))
    {
      std::cerr << "infinite alpha" << std::endl;
      break;
    }

    // est_x = est_x + alpha * _d
    ippsAddProductC_32f(_d, alpha, est_x, n_extended);

    if (i % _n_restart)
    {
      // _q = convolve _tmp with impulse_response
      {
        IppiSize const roi = { n_extended, 1 };
        int const step = roi.width * sizeof(float);
        ippiFilterRow_32f_C1R(
          _tmp + n_apron,
          step,
          _q,
          step,
          roi,
          impulse_response,
          n_impulse_response,
          n_apron);
      }

      // _r = _r - alpha * _q;
      ippsAddProductC_32f(_q, -alpha, _r, n_extended);
    }
    else // we have exceeded modulo(n_restart) iterations, recalculate the residual
    {
      // _tmp = convolve est_x with impulse_response
      {
        IppiSize const roi = { n_original_value, 1 };
        int const step = roi.width * sizeof(float);
        ippiFilterRow_32f_C1R(
          est_x + n_apron,
          step,
          _tmp + n_double_apron,
          step,
          roi,
          impulse_response,
          n_impulse_response,
          n_apron);
      }

      // _tmp = original_value - _tmp
      ippsSub_32f(
        _tmp + n_double_apron,
        original_value,
        _tmp + n_double_apron,
        n_original_value);

      // _r = convolve _tmp with impulse_response
      {
        IppiSize const roi = { n_extended, 1 };
        int const step = roi.width * sizeof(float);
        ippiFilterRow_32f_C1R(
          _tmp + n_apron,
          step,
          _r,
          step,
          roi,
          impulse_response,
          n_impulse_response,
          n_apron);
      }
    }

    float const delta_old = delta_new;

    // delta_new = dotproduct(_r, _r)
    delta_new = dot_product(_r, n_extended);

    float const beta = delta_new / delta_old;
    // TODO: unit test this path
    if (!_finite(beta))
    {
      std::cerr << "infinite beta" << std::endl;
      break;
    }

    // _d = beta * _d
    ippsMulC_32f_I(beta, _d, n_extended);

    // _d = _d + _r
    ippsAdd_32f_I(_r, _d, n_extended);
  }
}