%filtbpVolume   Compute a volume estimate using filtered backprojection
%
%  vol = filtbpVolume(mRCImage, theta, interp, filter, d, n, yIndex)
function vol = filtbpVolume(mRCImage, theta, interp, filter, d, n, yIndex)

% Get the dimensions of the projection stack
nX = getNX(mRCImage);
nY = getNY(mRCImage);
nZ = getNZ(mRCImage);

if nargin < 3
  interp = 'linear';
end
if nargin < 4
  filter = 'Ram-Lak';
end
if nargin < 5
  d = 1;
end    
if nargin < 6
  n = nX;
end

if nargin < 7
  yIndex = 1:nY
end

% The rotation for collecting projection data is defined to be in
% the X-Z plane
%The first index is assumed to vary over the spatial

% Load the complete projection volume
%projStack = getVolume(mRCImage, [1 nX], [1 nY], [1 nZ]);

% TODO: We are assuming that the sample is thin and thus has support in
% the z domain that is much less than in x.  To account for this we
% zero out projection data outside zero degree projection area onto
% the image plane

% Normalize the integrated amplitude of each project to unity
%for iZ = 1:nZ
%  projStack(:,:, iZ) = projStack(:, :, iZ) ./ sum(sum(projStack(:, :, iZ)));
%end
%size(projStack)

% Loop through each slice generating the selected tomogram in place
vol = zeros(n, length(yIndex), n);
iVolY = 1;
for iY = yIndex
  fprintf('%d ', iY);
  projSequence = getVolume(mRCImage, [1 nX], [iY iY], [1 nZ]);
  % iradon returns the reconstruction in image ordering, that is depth 
  % varying in rows, it needs to be transposed so that x is associated
  % with rows
  vol(:, iVolY, :) = iradon(squeeze(projSequence), theta, interp, filter, d, n)';
  iVolY = iVolY + 1;
end
fprintf('\n');
