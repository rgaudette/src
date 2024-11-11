%itMedian       Iterative median filter
%
%   mRCImage = itMedian(mRCImage, nIter, nElem)
%
%   mRCImage    The mRCImage object to filter.
%
%   nIter       The number of iterations to median filter.
%
%   nElem       OPTIONAL: The size of the median filter in the format
%               [nX nY nZ] (default: [3 3 3]).
%
%   itMedian calculates the iterative median filtered
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/07/14 23:15:41 $
%
%  $Revision: 1.1 $
%
%  $Log: itMedian.m,v $
%  Revision 1.1  2004/07/14 23:15:41  rickg
%  Incomplete initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function filtered = itMedian(mRCImage, nIter, nElem)

if nargin < 3
  nElem = [3 3 3];
end
if length(nElem) == 1
  nElem = nElem * [1 1 1];
end
  
if ~ all(rem(nElem, 2) == [1 1 1])
  error('The filter size must odd in all dimensions');
end

header = getHeader(mRCImage);

header.nX = header.nX - nElem(1) + 1
header.nY = header.nY - nElem(2) + 1
header.nZ = header.nZ - nElem(3) + 1

% Create a zero filled 
[path name] = fileparts(getFilename(mRCImage))

filtered = MRCImage(header, [name '.med'], isVolumeLoaded(mRCImage));
