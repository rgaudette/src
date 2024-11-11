#pragma once

#include <cmath>
#include <limits>

class DenseCG2
{
public:
	DenseCG2(int max_elements, int n_restart = 50);
	~DenseCG2();
	
	void solve_normal_eq(
		float const* impulse_response,	// a PSF evaluated in a finite range, centered at zero
		int n_impulse_response,			// must be odd and >= 3
		float const* original_value,	// the original signal values
		int n_original_value,			// must be > 0
		float* est_x,	// initially filled with original_value
						// extended by (n_impulse_response/2) elements at both beginning and end side
						// (therefore n_est_x is assumed to be (n_original_value + n_impulse_response - 1)
						// on return, est_x is filled with the estimated values
		int i_max,		// max iteration, must be > 0
		float epsilon = std::sqrt(std::numeric_limits<float>::min())
		);

private:
	DenseCG2(DenseCG2 const&);
	DenseCG2& operator=(DenseCG2 const&);
	
	int const _max_elements;
	int _n_restart;
	float* _tmp;
	float* _r;
	float* _d;
	float* _q;
};