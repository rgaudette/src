%getPoints      Return the points of the contour
%
%   points = getPoints(imodContour, indices)
%
%   points      The selected points of the contour in a 3 x N array
%
%   imodContour The ImodContour object.
%
%   indices     OPTIONAL: Selected indices of the countour (default: [ ] which
%               implies all points).
%
%
%   ImodContour.getPoints return the points of the contour.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 15:56:10 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function points = getPoints(imodContour, indices)

if nargin < 2 || isempty(indices)
  points = imodContour.points;
else
  points = imodContour.points(:, indices);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: getPoints.m,v $
%  Revision 1.4  2005/05/09 15:56:10  rickg
%  Comment updates
%
%  Revision 1.3  2005/04/05 19:03:28  rickg
%  Grab the whole point vector instead of a single value
%
%  Revision 1.2  2005/04/05 16:02:22  rickg
%  Added optional point indices
%
%  Revision 1.1  2003/03/04 05:35:31  rickg
%  Initial revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

