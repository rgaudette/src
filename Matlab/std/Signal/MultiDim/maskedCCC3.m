%maskedCCC3     Cross correlation coefficient over a specified search radius
%
%  [xcf, peakCCC, shift] = maskedCCC3(ref, test, searchRadius)
%
%  peakCCC      The peak cross correlation coefficient
%
%  shift        The shift parameters in test to maximize the cross-correlation
%               coefficient with ref
%
%  flgZeroMean  Remove the mean of both volumes before processing
%
%  TODO:
%   testing for odd number of pixels
%   testing of non-square images
%   rename
%   Handling variations in the local mean under the masked region

function [xcf, ccc, shift] = maskedCCC3(ref, test, searchRadius, flgZeroMean)

if nargin < 4
  flgZeroMean = 0;
end
if length(searchRadius) == 1
  searchRadius = [1 1 1] * searchRadius;
end

% Get the image size and create the image mask
szTest = size(test);
% The center is defined by the FFT indexing after fftshift is applied
center = floor(szTest / 2) + 1;

imageMask = ones(szTest);
imageMask([1:searchRadius(1) end-searchRadius(1)+1:end], :, :) = 0;
imageMask(:, [1:searchRadius(2) end-searchRadius(2)+1:end], :) = 0;
imageMask(:, :, [1:searchRadius(3) end-searchRadius(3)+1:end]) = 0;
xcfMask = zeros(szTest);
xcfMask([center(1)-searchRadius(1):center(1)+searchRadius(1)], ...
        [center(2)-searchRadius(2):center(2)+searchRadius(2)], ...
        [center(3)-searchRadius(3):center(3)+searchRadius(3)]) = 1; 

if flgZeroMean
  test = test - mean(test(:));
  ref = ref - mean(ref(:));
end

% Transform the test and reference signals into the Fourier domain
TEST = fftn(test .* imageMask);
nrgTEST = sum(TEST(:) .* conj(TEST(:))) / prod(szTest);

REF = fftn(ref);

% Compute the raw circulant cross correlation function 
xcf = real(ifftn(REF .* conj(TEST)));

% Scale the cross correlation function by energy over the masked reference 
% region.  This is part of the scaling necessary to produce a cross-correlation
% coefficient over the masked region.
nrgMaskedRef = real(ifftn(fftn(ifftn(REF) .^ 2) .* conj(fftn(imageMask))));
xcf = xcf ./ sqrt( nrgMaskedRef .* nrgTEST);

% Quadrant shift and mask out non-valid (aliased) cross correlation regions
xcf = fftshift(xcf) .* xcfMask;


if nargout > 1
  [ccc indices] = arraymax(xcf);
  shift = indices - center;
end
