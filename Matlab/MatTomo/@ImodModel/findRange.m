%findRange     Return the range of the contours in the model
%
%   dim = findRange(imodModel)
%
%   dim        The X,Y, and Z max for the model in the format
%              [xmax ymax zmax]
%
%   imodModel  The ImodModel containing the object.
%
%   Bugs: none known.

function dim = findRange(imodModel)
xMax = 0;
yMax = 0;
zMax = 0;

nObjects = length(imodModel.Objects);
for iObject = 1:nObjects
  imodObject = getObject(imodModel, iObject);
  nContours = getNContours(imodObject);
  for iContour = 1:nContours
    imodContour = getContour(imodObject, iContour);
    pts = getPoints(imodContour);
    tmp = max(pts, [], 2);
    if tmp(1) > xMax
      xMax = tmp(1);
    end
    if tmp(2) > yMax
      yMax = tmp(2);
    end
    if tmp(3) > zMax
      zMax = tmp(3);
    end
  end
end

dim = [xMax yMax zMax];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: findRange.m,v $
%  Revision 1.1  2005/06/24 22:43:33  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%