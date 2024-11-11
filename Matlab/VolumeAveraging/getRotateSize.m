%getRotatesize  Compute the volume size necessary to prevent extrapolation
%
%   [szExtract, newOrigin, idxSubX, ...] = getRotateSize(szArray, origin)
%
%   szExtract   The size of the array before rotation.
%
%   newOrigin   The coordinates of the origin in the szExtract size array.
%
%   idxSubX     The indices of the szExtract array that correspond to the
%   idxSubY     central szArray elements.
%   idxSubZ
%
%   szArray     The size of the array to be rotated without extrapolation.
%
%   origin      OPTIONAL: The origin around which the array will be
%               rotated. Specified in array index units, wich fractional
%               indices allowed.
%
%   getRotateSize computes the necessary array size to prevent
%   extrapolation of a size szArray volume at the center of the larger
%   array. THe size of the increased array is such that it is sampled in
%   the same locations as the original array (i.e. 1/2 sample interpolation
%   is not necessary to align the arrays).
%
%   Calls: none
%
%   Bugs: 
%
%   Since the data size returned expands all boundaries the volume
%   isn't as tight as possible
%
%   Currently only tested for 3D

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [szExtract, newOrigin, varargout] = getRotateSize(szArray, origin)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: getRotateSize.m,v 1.3 2005/08/15 23:17:36 rickg Exp $\n');
end

if nargin < 2 || isempty(origin)
  origin = szArray ./ 2 + 0.5;
end

% Find the largest distance from the origin to array boundaries
corners = [ ...
  1 1 1
  1 1 szArray(3)
  1 szArray(2) 1
  1 szArray(2) szArray(3)
  szArray(1) szArray(2) 1
  szArray(1) szArray(2) szArray(3) ]' ;
distCorners = corners - repmat(origin', 1, 6);
maxRadius = max(sqrt(sum(distCorners .^2)));

% Find the nearest dist from the origin to the array boundary. The extreme
% case is the largest distance rotates to the nearest boundary.
edges = [ ...
  1 origin(2) origin(3)
  szArray(1) origin(2)  origin(3)
  origin(1) 1 origin(3)
  origin(1) szArray(2)  origin(3)
  origin(1) origin(2) 1
  origin(1) origin(2)  szArray(3) ]';
distEdges = edges - repmat(origin', 1, 6);
minData = min(sqrt(sum(distEdges .^2)));
expand = ceil(maxRadius - minData);
szExtract = szArray + 2 * expand;
newOrigin = origin + expand;
idxExtractOrigin =  floor(szExtract / 2) + 1;
for iDim = 1:length(szArray)
  varargout{iDim} = expand+1:expand+szArray(iDim);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: getRotateSize.m,v $
%  Revision 1.3  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.2  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.1  2005/03/03 18:39:05  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
