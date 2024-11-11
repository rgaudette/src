%getPoints      Return the points of the specified object and contour
%
%   points = getPoints(imodModel, idxObject, idxContour)
%
%   points      The array of points contained in the specified object and
%               contour (3xN).
%
%   imodModel   The ImodModel object.
%
%   idxObject   The index of the object and contour from which to extract the
%   idxContour  points.
%
%   indices     OPTIONAL: Selected indices of the countour (default: [ ] which
%               implies all points).
%
%   Return the points of the specified object and contour.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/06 22:05:57 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function points = getPoints(imodModel, idxObject, idxContour, indices)

if nargin < 4 || isempty(indices)
  indices = [ ];
end

points = getPoints(imodModel.Objects{idxObject}, idxContour, indices);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: getPoints.m,v $
%  Revision 1.4  2005/05/06 22:05:57  rickg
%  Comment updates
%
%  Revision 1.3  2005/04/05 16:02:22  rickg
%  Added optional point indices
%
%  Revision 1.2  2004/11/23 00:42:53  rickg
%  Help update
%
%  Revision 1.1  2003/03/04 05:35:31  rickg
%  Initial revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
