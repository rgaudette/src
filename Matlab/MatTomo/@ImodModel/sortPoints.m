%sort           Sort the points of the specified object and contour
%
%   imodModel = sort(imodModel, idxObject, idxContour, idxStart)
%
%   imodModel   The ImodModel object.
%
%   idxObject   The index of the object and contour containing the points to
%   idxContour  sort.
%
%   idxStart    The index of the point in the specified object and contour to
%               used as the origin for the sort.
%
%
%   sort reorders points in the specified object and contour so that they are
%   indexed next to their nearest neighboor starting with the idxStart point.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/06 22:05:57 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodModel = sortPoints(imodModel, idxObject, idxContour, idxStart)
objectType = getObjectType(imodModel, idxObject);

points = getPoints(imodModel, idxObject, idxContour);
nPoints = size(points, 2);

refPoint = repmat(points(:, idxStart), 1, nPoints);
distsq = sum((points - refPoint).^2);
[v idxSort] = sort(distsq);
points = points(:, idxSort);
imodModel = setPoints(imodModel, idxObject, idxContour, points);
imodModel = setObjectType(imodModel, idxObject, objectType);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: sortPoints.m,v $
%  Revision 1.3  2005/05/06 22:05:57  rickg
%  Comment updates
%
%  Revision 1.2  2005/02/25 23:30:10  rickg
%  Preserve the object type
%
%  Revision 1.1  2004/08/20 20:21:18  rickg
%  Initial revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
