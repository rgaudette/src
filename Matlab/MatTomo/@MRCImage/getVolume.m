%getVolume      Extract a volume from the MRC image
%
%   vol = getVolume(mRCImage, iRange, jRange, kRange)
%
%   vol         The extracted volume
%
%   mRCImage    The opened MRCImage object
%
%   iRange      The indices of the i (first, columns) dimension to be extracted
%               as [iMin iMax], an empty array specifies all.
%
%   jRange      The indices of the j (second, rows) dimension to be extracted
%               as [jMin jMax], an empty array specifies all.
%
%   kRange      The indices of the k (third, planes) dimension to be extracted
%               as [kMin kMax], an empty array specifies all.
%
%   MRCImage.getVolume extracts a three dimensional region from an MRCImage
%   object.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:47:05 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vol = getVolume(mRCImage, iRange, jRange, kRange)

if nargin < 2 | isempty(iRange)
  iIndex = 1:getNX(mRCImage);
else
  iIndex = [iRange(1):iRange(2)];
end

if nargin < 3 | isempty(jRange)
  jIndex = 1:getNY(mRCImage);
else
  jIndex = [jRange(1):jRange(2)];
end

if nargin < 4 | isempty(kRange)
  kIndex = 1:getNZ(mRCImage);
else
  kIndex = [kRange(1):kRange(2)];
end


% If the volume is already loaded return the selected indices
if mRCImage.flgVolume
  vol = mRCImage.volume(iIndex, jIndex, kIndex);
  return
end

%  Allocate the output matrix
vol = zeros(length(iIndex), length(jIndex), length(kIndex));

%  Walk through the images
l = 1;
for k = kIndex
  img = getImage(mRCImage, k);
  vol(:, :, l) = img(iIndex, jIndex);
  l = l + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  $Log: getVolume.m,v $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Revision 1.4  2005/05/09 17:47:05  rickg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Comment updates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Revision 1.3  2004/09/08 23:13:29  rickg
%  Default index ranges
%
%  Revision 1.2  2003/06/13 22:05:01  rickg
%  empty index array specifies all
%
%  Revision 1.1  2003/02/14 23:58:42  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%