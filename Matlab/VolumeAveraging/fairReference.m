%fairReference  Generate an unbiased reference
%
%   [refVolume select eulerOffset stTransform] = ...
%     fairReference(volume, imodParticle, select, motiveList, szVol, ...
%     vDeltaPhi, vDeltaTheta, vDeltaPsi, searchRadius, ...
%     lowCutoff, hiCutoff, flgDebugText)
%
%   refVolume   The generated reference volume
%
%   select      The index of the selected particle
%
%   eulerOffset The euler offset of the reference volume
%
%   stTransform The struture of transform and matching parameters.
%
%   volume      The MRCImage object containing the volume.
%
%   imodParticle  The Imod model containing the locations of the particles 
%               (in object 1, contour 1)
%
%   select      Either the number of number of particles to select or the
%               indices of the particles to use.  This should be a power of 2
%               or contain a power of 2 elements.
%
%   motiveList  The motive list containing the initial orientation of each of
%               particles or [] to assume no know initial orientation.
%
%   parm        Input description [units: MKS]
%
%   deltaPhi   The offsets (degrees) to rotate the particle to search for the
%   deltaTheta peak cross correlation coefficient.
%   deltaPsi
%   Optional    OPTIONAL: This parameter is optional (default: value)
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.11 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [volumes select eulerOffset stTransform] = ...
  fairReference(volume, imodParticle, select, motiveList, szVol, ...
  vDeltaPhi, vDeltaTheta, vDeltaPsi, searchRadius, ...
  lowCutoff, hiCutoff, flgDebugText)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: fairReference.m,v 1.11 2005/08/15 23:17:36 rickg Exp $\n');
end

% Hard coded parameters
interpMethod = 'linear';
flgMeanRemove = 1;

% Get the particle centers from the point model and convert to a MATLAB
% array indices.  
ptsParticles = imodPoints2Index(getPoints(imodParticle, 1, 1));
nParticles = size(ptsParticles, 2);

if isempty(motiveList)
  % Create the empty motive list
  motiveList = emptyMotiveList(20, nParticles);
end

if nParticles ~= size(motiveList, 2)
  error('Indirect particle indexing is not implemented yet, get Rick to fix');
end

if length(select) == 1
  % Select a random set of the particles in the
  nSelect = select;
  rand('state', sum(100*clock));
  select = randUniqInt(nSelect, [1 nParticles])
else
  nSelect = length(select);
end

% Select an index at center of the volume or near it (even case) to
% represent the origin for rotation
idxOrigin = floor(szVol / 2) + 1;

% Construct the correlation search radius mask
% ASSUME fixed and test volumes are the same size as is the resulting
% cross correlation coefficient function
if length(searchRadius) == 1
  searchRadius = [1 1 1] * searchRadius;
end
[imageMask xcfMask] = genMasks(szVol, searchRadius, idxOrigin, 'single');
IMaskC = conj(fftn(imageMask));
nMask = sum(imageMask(:));

% Create the frequency domain filter if requested
if lowCutoff > 0 | hiCutoff < 0.866
  flgFreqFilt = 1;
  fltBandpass = ifftshift(genBandpass(szVol, lowCutoff, hiCutoff));
else
  flgFreqFilt = 0;
end

% Load each of the volumes into an array of volumes
volumes = zeros(szVol(1), szVol(2), szVol(3), nSelect, 'single');
iParticle = 1;
for iSelect = select
  subvol = single(extractSubVolume(volume, ptsParticles(:, iSelect), szVol));

  % Frequency domain filter it if required
  SUBVOL = fftn(subvol);
  if flgFreqFilt
    SUBVOL = SUBVOL .* fltBandpass;
  end

  % Zero out any DC in the sub-volume if requested
  if flgMeanRemove
    SUBVOL(1, 1, 1) = 0;
  end
  volumes(:,:,:, iParticle) = ifftn(SUBVOL);
  iParticle = iParticle + 1;
end

% Initial rotation estimate comes from the input motive list
eulerOffset = motiveList([17 19 18], select) * (pi / 180);
if flgDebugText > 1
  disp('Initial eulerOffset:')
  eulerOffset
end

% Rotational search space
eulerSearch.Phi = vDeltaPhi * (pi / 180);
eulerSearch.Theta = vDeltaTheta * (pi / 180);
eulerSearch.Psi = vDeltaPsi * (pi / 180);

% Mask structure
stMask.imageMask = imageMask;
stMask.xcfMask = xcfMask;
stMask.IMaskC = IMaskC;
stMask.nMask = nMask;
stMask.searchRadius = searchRadius;

idxPair = 1;

while size(volumes, 4) > 1
  if flgDebugText > 1
    fprintf('\nSearching volume pairs\n%s\n\n', datestr(clock)');
  end

  [ccMeasure arrRotate arrShift] = ...
    pairSearchCCS(volumes, eulerOffset, eulerSearch, stMask, idxOrigin, ...
    interpMethod, flgDebugText);

  if flgDebugText > 2
    ccMeasure
    squeeze(arrRotate)
    squeeze(arrShift)
  end
  
  % Walk through the CCS measures finding the current highest and generating
  % the average of them
  nAvg = size(ccMeasure, 1) / 2;
  newVolumes = zeros([szVol nAvg], 'single');
  newEulerOffset = [];
  
  if flgDebugText > 1
    fprintf('\nComputing averages\n');
  end
  
  for iAvg = 1:nAvg
    % The fixed particle always comes from the row and the rotated particle from
    % the colume because the CCS matrix is filled in upper triangular
    [val iFixed iRot] = matmax(ccMeasure);
    if flgDebugText > 1
      fprintf('Fixed: %d  transformed: %d  CCS: %f\n', ...
        iFixed, iRot, val);
      fprintf('Rotation phi: %6.2f  theta: %6.2f  psi: %6.2f\n', ...
        arrRotate(iFixed, iRot, :) * 180/pi);
      fprintf('Shift %6.2f %6.2f %6.2f\n', ...
        arrShift(iFixed, iRot, :))
    end

    % Record the index of the reference and transformed volumes and the
    % rotation and shift applied to to generate the average
    stTransform(idxPair).iFixed = iFixed;
    stTransform(idxPair).iRot = iRot;
    stTransform(idxPair).CCS = val;
    stTransform(idxPair).rotate = arrRotate(iFixed, iRot, :);
    stTransform(idxPair).shift = arrShift(iFixed, iRot, :);
    idxPair = idxPair + 1;
    
    newVolumes(:,:,:, iAvg) = ...
      pairAverage(volumes(:,:,:, iFixed), volumes(:,:,:, iRot), ...
      arrRotate(iFixed, iRot, :), arrShift(iFixed, iRot, :), idxOrigin, ...
      interpMethod);
    ccMeasure([iFixed iRot], :) = -2;
    ccMeasure(:, [iFixed iRot]) = -2;
    newEulerOffset(:, iAvg) = eulerOffset(:, iFixed)
  end

  % Replace the the inputs for the next iteration
  volumes = newVolumes;
  eulerOffset = newEulerOffset;
  if flgDebugText > 1
    disp('Updated eulerOffset:')
    eulerOffset
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Local functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pairSearchCCS
%
% Compare all pairs of volume to compute the peak CCS over the rotational
% search space
%
%  volumes      4D volume array
%
%  eulerOffset  The approximate rotation parameters of each volume (radians)
%
%  eulerSearch  The euler space structure to search (radians)
%
%  stMask       The mask structure
%
%  idxOrigin    The index of the origin within the volume

function [matCCS, arrRotate, arrShift] = ...
  pairSearchCCS(volumes, eulerOffset, eulerSearch, ...
  stMask, idxOrigin, interpMethod, flgDebugText)

% shift indexing
searchRadius = stMask.searchRadius;
idxShiftX = -searchRadius(1):searchRadius(1);
idxValidXCFX = idxOrigin(1) + idxShiftX;
idxShiftY = -searchRadius(2):searchRadius(2);
idxValidXCFY = idxOrigin(2) + idxShiftY;
idxShiftZ = -searchRadius(3):searchRadius(3);
idxValidXCFZ = idxOrigin(3) + idxShiftZ;
            
nVols = size(volumes, 4);
matCCS = zeros(nVols, nVols);
invNMask = 1 / stMask.nMask;

for iFixed = 1:nVols-1
  FIXED = fftn(volumes(:,:,:, iFixed));
  %%% Compute the mean and variance of the region of interest defined 
  %%% by the shifted imageMask
  fixedMean = invNMask * real(ifftn(FIXED .* stMask.IMaskC));
  fixedVar = invNMask * ...
    real(ifftn(fftn(volumes(:,:,:, iFixed) .^ 2) .* stMask.IMaskC)) ...
    -  fixedMean .^ 2;

  for iRotate = iFixed+1:nVols
    
    centerRotation = eulerRotateSum(...
      rev(-1 * eulerOffset(:, iRotate)), eulerOffset(:, iFixed));
    
    peakCCS = -1;

    for delPhi = eulerSearch.Phi
      for delTheta = eulerSearch.Theta
        for delPsi = eulerSearch.Psi

          % Find the total rotation required converting the offset into radians
          delRotate = [delPhi delTheta delPsi];
          totalRotation = eulerRotateSum(centerRotation, delRotate);
        
          % Rotate the particle of interest, any extraplotion points are set to
          % zero which is the global mean
          rotPOI = volumeRotate(volumes(:,:,:, iRotate) , ...
            totalRotation, idxOrigin, interpMethod, 0);
          
          % Spatial masking of rotated particle of interest
          rotPOI = rotPOI .* stMask.imageMask;
          
          %%% Compute the mean and standard deviation of the rotated volume
          %%% under the mask
          poiVec = rotPOI(logical(stMask.imageMask));
          poiVec = poiVec(:);
          poiMean = mean(poiVec);
          poiVar = invNMask * sum((poiVec - poiMean) .^ 2);
        
          %%% Compute the true cross correlation coefficient over the region
          numer = invNMask * real(ifftn(FIXED .* conj(fftn(rotPOI)))) ...
            - fixedMean * poiMean;
          denom = sqrt(fixedVar * poiVar);
          CCS = fftshift(real(numer ./ denom)) .* stMask.xcfMask;
          
          %%% Find the maximum correlation coefficient value and its position
          [maxCCS indices] = arraymax(CCS);
          if maxCCS > peakCCS
            peakCCS = maxCCS;
            peakRotation = totalRotation;
            peakDelRotate = delRotate;
            idxPeak = indices - idxOrigin;
            
            validXCF = CCS(idxValidXCFX,idxValidXCFY,idxValidXCFZ);
            [peakValue loc] = ...
              peakInterp3(idxShiftX, idxShiftY, idxShiftZ, ...
              validXCF, idxPeak, 1, 0.02);
            tshift = loc;
          end
          
        end % Psi
      end % Theta
    end % Phi
    matCCS(iFixed, iRotate) = peakCCS;
    arrRotate(iFixed, iRotate, 1:3) = peakRotation;
    arrShift (iFixed, iRotate, 1:3) = tshift;
    
    if flgDebugText
      fprintf('iFixed: %d  iRotate: %d\n', iFixed, iRotate);
      fprintf('Peak del  phi: %6.2f  theta: %6.2f  psi: %6.2f\n', ...
        peakDelRotate(1) * 180/pi, ...
        peakDelRotate(2) * 180/pi, ...
        peakDelRotate(3)* 180/pi)
      fprintf('Max CCS @ phi: %6.2f  theta: %6.2f  psi: %6.2f', ...
        peakRotation(1) * 180/pi,  ...
        peakRotation(2) * 180/pi, ...
        peakRotation(3) * 180/pi)
      fprintf('  CCS %f @ indices %6.2f %6.2f %6.2f\n', ...
        peakCCS, idxPeak(1), idxPeak(2), idxPeak(3))
      fprintf(' Interpolated shift %6.2f %6.2f %6.2f\n', ...
        tshift(1), tshift(2), tshift(3));
      fprintf('%s\n\n', datestr(clock));
    end
  end
end


% Average a pair of volumes rotating & shifting one onto the other
function avgVol = pairAverage(fixedVol, rotVol, rotation, shift, ...
  idxOrigin, interpMethod)

avgVol = (fixedVol ...
  + volumeRotateShift(rotVol, rotation, shift, idxOrigin, interpMethod)) ...
  ./ 2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: fairReference.m,v $
%  Revision 1.11  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.10  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.9  2005/01/07 22:09:55  rickg
%  Number of particles from model
%  Empty motive list is created if not null
%
%  Revision 1.8  2005/01/07 04:05:33  rickg
%  Debug & help text changes
%
%  Revision 1.7  2005/01/05 16:29:49  rickg
%  Corrected select indexing
%  Merged volumes and arrParticle
%
%  Revision 1.6  2005/01/05 01:04:09  rickg
%  Validating correlation coefficient algorithm and shift and rotation
%
%  Revision 1.5  2005/01/04 06:05:56  rickg
%  Correcting correlation coefficient algorithm
%
%  Revision 1.4  2004/12/31 18:01:25  rickg
%  *** empty log message ***
%
%  Revision 1.3  2004/12/21 00:47:25  rickg
%  Initial revision
%
%  Revision 1.2  2004/12/16 00:56:54  rickg
%  Development in progress
%
%  Revision 1.1  2004/12/10 00:31:40  rickg
%  In development
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
