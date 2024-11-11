%getSlice       Get a slice of data 
%
%   slice = getImage(mRCImage, idxDomain, index)
%
%   slice       The selected image slice
%
%   mRCImage    The MRCImage object.
%
%   idxDomain   The index of the domain to hold constant for extracting the
%               slice: 1=I, 2=J, 3=K
%
%   index       The value of the constant domain.
%
%
%   Bugs: inefficient in that it loads to much data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:47:05 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function slice = getSlice(mRCImage, idxDomain, index)

dimensions = [mRCImage.header.nX mRCImage.header.nY ...
              mRCImage.header.nZ];


if index < 1 | index > dimensions(idxDomain)
  error('Image index out of range');
end

%FIXME implement a more efficient access than getVolume
iRange = [1 dimensions(1)];
jRange = [1 dimensions(2)];
kRange = [1 dimensions(3)];

switch idxDomain
 case 1,
  iRange = [index index];
 case 2,
  jRange = [index index];
 case 3,
  kRange = [index index];
 otherwise,
  error('Unknown domain index');
end

slice = getVolume(mRCImage, iRange, jRange, kRange);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: getSlice.m,v $
%  Revision 1.2  2005/05/09 17:47:05  rickg
%  Comment updates
%
%  Revision 1.1  2003/02/14 23:54:42  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
