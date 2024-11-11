%setVolume      Set a sub volume of an MRCImage
%
%   mRCImage = getVolume(mRCImage, vol, center)
%
%   vol         The extracted volume
%
%   mRCImage    The opened MRCImage object.
%
%   vol         The volume to be inserted.
%
%   center      OPTIONAL: The indices into the mRCImage volume which will be the
%               center of the inserted volume [idxX idxY idxZ].  The center
%               of the volume to be inserted is specfied by:
%
%               floor(size(vol) ./ 2) + 1
%
%               (default: [1 szVol]).
%               
%
%   setVolume sets a region of the MRCImage object.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/10 22:52:43 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mRCImage = setVolume(mRCImage, vol, center)

szVol = size(vol);
szMRC = getDimensions(mRCImage);

if nargin < 3
  idxMin = [1 1 1];
  idxMax = szVol;
else
  idxMax = center + ceil(szVol ./ 2) - 1;
  idxMin = center - floor(szVol ./ 2);
end

if any(idxMin < 1)
  fprintf('Minimum index ');
  fprintf('%f', idxMin);
  fprintf('\n');
  error('Minimum index out of range');
end

if any(idxMax > szMRC)
  fprintf('Maximum index ');
  fprintf('%f', idxMin);
  fprintf('\n');
  error('Maximum index out of range');
end


% If the volume is already loaded return the selected indices
if mRCImage.flgVolume
  mRCImage.volume([idxMin(1):idxMax(1)], ...
    [idxMin(2):idxMax(2)], [idxMin(3):idxMax(3)]) = vol;
else
  error('File based MRCImage.setVolume not yet implemented');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: setVolume.m,v $
%  Revision 1.4  2005/05/10 22:52:43  rickg
%  Default value for center
%
%  Revision 1.3  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.2  2004/09/17 04:44:54  rickg
%  Fixed error reporting
%
%  Revision 1.1  2004/09/17 04:37:12  rickg
%  Initial revision in progress
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

