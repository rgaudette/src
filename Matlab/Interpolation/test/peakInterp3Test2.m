%peakInterp3Test2

%%
% load in the reference volume
mrcRef = MRCImage('6f5ida_5.mrc', 0);
fullVolume = getVolume(mrcRef);
[nX nY nZ] = size(fullVolume);

% Extract the central cube as the reference
nElem = 64;
idxXStart = floor((nX - nElem) / 2);
idxYStart = floor((nY - nElem) / 2);
idxZStart = floor((nZ - nElem) / 2);

ref = fullVolume(idxXStart:idxXStart+nElem-1, ...
  idxYStart:idxYStart+nElem-1, ...
  idxZStart:idxZStart+nElem-1);

% Shift the volume and extract the central cube as the test volume
shift = [1.25 -1.9 0];
idxX = [1:nX]';
idxY = 1:nY;
idxZ = 1:nZ;
%[idxX idxY idZ] = ndgrid
testFull = interpn(idxX, idxY, idxZ, fullVolume, ...
  idxX+shift(1), idxY+shift(2), idxZ+shift(3), ...
  'spline', 0);
test = testFull(idxXStart:idxXStart+nElem-1, ...
  idxYStart:idxYStart+nElem-1, ...
  idxZStart:idxZStart+nElem-1);

%%

mrcTest = MRCImage('6f5ida_7.mrc', 0);
fullVolume = getVolume(mrcTest);
testn = fullVolume(idxXStart:idxXStart+nElem-1, ...
  idxYStart:idxYStart+nElem-1, ...
  idxZStart:idxZStart+nElem-1);
%%
%%
testn = test + 19.5 * randn(size(test));

figure(1)
imagesc(testn(:,:,33));
%%

%%
% Compute the cross-correlation coefficient function
searchRadius = 10;
[xcf] = maskedCCC3(ref, testn, searchRadius);
[peakCCC indices] = arraymax(xcf);
peakCCC
center = floor(size(ref) ./ 2) + 1;
idxPeak = indices - center
idxShift = -searchRadius:searchRadius;
idxValidXCF = center(1) + idxShift;
validXCF = xcf(idxValidXCF,idxValidXCF,idxValidXCF);

%%

%%
% Use the valid sub region of the CCC function
[peakValue loc] = peakInterp3(idxShift, idxShift, idxShift, validXCF, ...
  idxPeak, 1, 0.02);
peakValue
loc
%%

%%
% Second order hyper-surface interpolation, extract the local region around
% the maximum indices
nSORegion = 2
subLocX = indices(1)-nSORegion:indices(1)+nSORegion;
subLocY = indices(2)-nSORegion:indices(2)+nSORegion;
subLocZ = indices(3)-nSORegion:indices(3)+nSORegion;
subCCC = xcf(subLocX, subLocY, subLocZ);
[soPeakValue soLoc] = peakInterpSO3(subLocX-center(1), subLocY-center(2), subLocZ-center(3), subCCC);
  
soPeakValue
soLoc
%%

imagesc(xcf(:,:,11))
colorbar