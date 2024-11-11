%setPoints      Sets the points of the specified object and contour
%
%   imodModel = setPoints(imodModel, idxObject, idxContour, points)
%
%   imodModel   The ImodModel object.
%
%   idxObject   The index of the object in the model to set.
%
%   idxContour  The index of the countour to set in the specified object to set.
%
%   points      The array of points to set the countour to (3xN).
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/08 17:22:49 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodModel = setPoints(imodModel, idxObject, idxContour, points)
imodObject = imodModel.Objects{idxObject};
imodContour = getContour(imodObject, idxContour);
imodContour = setPoints(imodContour, points);
imodObject = setContour(imodObject, imodContour, idxContour);
imodModel.Objects{idxObject} = imodObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: setPoints.m,v $
%  Revision 1.4  2005/05/08 17:22:49  rickg
%  Comment updates
%
%  Revision 1.3  2005/05/06 22:05:57  rickg
%  Comment updates
%
%  Revision 1.2  2004/10/01 23:37:04  rickg
%  Prevent extraneous output
%
%  Revision 1.1  2004/08/20 20:07:04  rickg
%  Initial revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
