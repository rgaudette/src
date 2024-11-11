%getPoints      Return the points of the specified contour
%
%   points = getPoints(imodObject, idxContour, indices)
%
%   points      The array of points contained in the specified object and
%               contour (3xN).
%
%   imodObject  The ImodObject containing the contour
%
%   idxContour  The index of the contour from which to extract the points.
%
%   indices     OPTIONAL: Selected indices of the countour (default: [ ] which
%               implies all points).
%
%   Return the points of the specified contour in the current object.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 05:03:27 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function points = getPoints(idxObject, idxContour, indices)

if nargin < 3 || isempty(indices)
  indices = [ ];
end

points = getPoints(idxObject.contour{idxContour}, indices);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: getPoints.m,v $
%  Revision 1.4  2005/05/09 05:03:27  rickg
%  Comment update
%
%  Revision 1.3  2005/04/05 16:02:22  rickg
%  Added optional point indices
%
%  Revision 1.2  2004/11/23 00:43:25  rickg
%  Use accum to prevent divide by zero errors
%
%  Revision 1.1  2003/03/04 05:35:44  rickg
%  *** empty log message ***
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
