%extractSubVolume  Extract the sub-volume from MRCImage
%
%   subVolume = extractSubVolume(mRCImage, center, volSize, test, meanFill)
%
%   mRCImage    The MRCImage containing the volume
%
%   center      The array index of the center voxel, this can be
%               non-integer and the nearest voxels will be extracted.
%
%   volSize     The size of the sub volume to extract [nX nY nZ]
%
%   test        OPTIONAL: If true then only test to see if the
%               subvolume to be extracted is completely in the in the
%               volume.
%
%   meanFill    OPTIONAL: If true allow for sub volumes out of the
%               boundaries of the MRCImage data.  Outside data will be
%               filled with the mean of the present data (default: 0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.10 $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function subVolume = extractSubVolume(mRCImage, center, volSize, test, meanFill)
global PRINT_ID
if PRINT_ID
    fprintf('$Id: extractSubVolume.m,v 1.10 2005/08/15 23:17:36 rickg Exp $\n');
end

if nargin < 4
  test = 0;
end

if nargin < 5
  meanFill = 0;
end

% Get the full volume size
szFullVol = getDimensions(mRCImage);

% Calculate the index range to extract, need to use floor(x + 0.5) because
% round([-0.5 0.5]) = [-1 1]
halfSize = floor(volSize/ 2);
center = center + 0.5;
rngX = floor(center(1) + [-halfSize(1) -halfSize(1)+volSize(1)-1]);
rngY = floor(center(2) + [-halfSize(2) -halfSize(2)+volSize(2)-1]);
rngZ = floor(center(3) + [-halfSize(3) -halfSize(3)+volSize(3)-1]);

% Check the indices for any out of range
inRange = 1;
inRange = inRange & checkIndexRange('X', szFullVol(1), rngX, test, meanFill);
inRange = inRange & checkIndexRange('Y', szFullVol(2), rngY, test, meanFill);
inRange = inRange & checkIndexRange('Z', szFullVol(3), rngZ, test, meanFill);

if test
  subVolume = inRange;
  return
end

% Limit the data index ranges if meanFill is selected
if meanFill
  [idxSubVolX, extractRngX] = mapPresentIndices(szFullVol(1), rngX);
  [idxSubVolY, extractRngY] = mapPresentIndices(szFullVol(2), rngY);
  [idxSubVolZ, extractRngZ] = mapPresentIndices(szFullVol(3), rngZ);
  extractVolume = getVolume(mRCImage, extractRngX, extractRngY, extractRngZ);
  svMean = mean(extractVolume(:));
%   dataType = getModeString(mRCimage);
%   switch dataType
%     case 'uint8'
%       svMean = uint8(svMean);
%     case 'int16'
%       svMean = int16(svMean);
%     case 'float32'
%       svMean = single(svMean);
%       dataType = 'single';
%   end
  subVolume = ones(volSize) * svMean;
  subVolume(idxSubVolX, idxSubVolY,idxSubVolZ) = ...
    extractVolume;
else    
  subVolume = getVolume(mRCImage, rngX, rngY, rngZ);
end

% Check the inidices to see if they are in range
function inRange = checkIndexRange(axisLabel, axisMax, indices, test, meanFill)
inRange = 1;
if min(indices) < 1
  msg = sprintf(...
    '%s axis volume minimum index: 1, sub-volume minumum index %d\n', ...
    axisLabel, min(indices));
  if test
    fprintf(msg);
    inRange = 0;
  else
    if meanFill
      warning(msg);
    else
      error(msg);
    end
  end
end

if max(indices) > axisMax
  msg = sprintf(...
    '%s axis volume maximum index: %d, sub-volume maximum index %d\n', ...
    axisLabel, axisMax, max(indices));
  if test
    fprintf(msg);
    inRange = 0;
  else
    if meanFill
      warning(msg);
    else
      error(msg);
    end
  end
end

%  TODO:  Not tested for data that exceed limits on both ends
function [idxSubVol, idxExtract] = mapPresentIndices(szDim, selectRange);
idxExtract = selectRange;
start = 1;
stop = selectRange(2) - selectRange(1) + 1;
if selectRange(1) < 1
  idxExtract(1) = 1;
  start = 2 - selectRange(1);
end
if selectRange(2) > szDim
  idxExtract(2) = szDim;
  stop = idxExtract(2) - idxExtract(1) + start;
end
idxSubVol = start:stop;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: extractSubVolume.m,v $
%  Revision 1.10  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.9  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.8  2005/07/20 23:43:15  rickg
%  Fixed case where extracted sub volume was large on both end than supplied.
%
%  Revision 1.7  2005/07/20 20:58:03  rickg
%  Switch round to floor(+0.5)
%
%  Revision 1.6  2005/03/24 05:05:23  rickg
%  help comment fix
%
%  Revision 1.5  2005/03/02 22:40:52  rickg
%  Added meanFill capability
%
%  Revision 1.4  2004/11/08 04:49:46  rickg
%  Updated help
%  Fixed indexing for odd cases
%
%  Revision 1.3  2004/10/05 22:17:51  rickg
%  Clearified error reporting string
%
%  Revision 1.2  2004/10/05 20:36:33  rickg
%  Enhanced error reporting
%
%  Revision 1.1  2004/09/27 23:52:46  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
