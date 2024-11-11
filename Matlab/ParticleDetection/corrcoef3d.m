%corrcoeff3d    Compute the the cross correlation coeffiecient in 3D
%
%    [ccFunc] = corrcoef3d(vol1, vol2, shape)

function [ccFunc] = corrcoef3d(vol1, vol2, shape)

if nargin < 3
  shape = 'valid';
end

% Create a ones mask the size of vol2 for extracting shifted regions of the
% same size from within vol1
maskVol2 = ones(size(vol2));
nSaMask = prod(size(vol2));

% APPROXIMATION: assume that the mean of vol1 is stationary
%zmVol1 = vol1 - mean(vol1(:));

% EXACT: Calculate the local mean for each mask region
localMeanVol1 = convn(vol1, maskVol2, 'same') / nSaMask;
zmVol1 = vol1 - localMeanVol1;

zmVol2 = vol2 - mean(vol2(:));
% Compute the standard deviation of the kernel and the shifted regions
% of the analysis volume, finally the denominator of the correlation coefficent
% for each region
stdVol2 = std(zmVol2(:));
localStdVol1 = sqrt(convn(zmVol1 .^2, maskVol2, shape) ./ nSaMask);
ccDenom = localStdVol1 * stdVol2;

% Compute the cross correlation of the two volumes and divide by the std
xcFunc = xcorr3d(zmVol1, zmVol2, shape);
ccFunc = xcFunc ./ (ccDenom * nSaMask);

