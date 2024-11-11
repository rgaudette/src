%bandlimitedRandVol  Create a bandlimted random volume
%
%   vol = bandlimitedRandVol(szVol, hiCutoff, lowCutoff)
%
%   vol         The random volume.
%
%   szVol       The size of the random volume to generate [nX nY nZ]
%
%   hiCutoff    The upper cutoff frequency and optionally the transition
%               width [cutoff transWidth].  Specifically the cutoff value
%               is the start of Gaussian transition band and the transition
%               width specifies the sigma parameter of the Gaussian.
%
%   lowCutoff   OPTIONAL: The lower cutoff frequency and optional
%               transition width [cutoff transWidth].
% 
%
%   bandlimitedRandomVolume generates a bandlimited random volume with a
%   normal distribution (mean = 0, std = 1).  The bandlimiting is applied
%   through a Gaussian mask in the frequency domain
function vol = bandlimitedRandVol(szVol, hiCutoff, lowCutoff)

if nargin < 3
  lowCutoff = 0;
end
fltBandpass = genBandpass(szVol, lowCutoff, hiCutoff);
vol = randn(szVol);
VOL = fftshift(fftn(vol));
VOL = VOL .* fltBandpass;
vol = ifftn(ifftshift(VOL));
vol = vol ./ std(vol(:));