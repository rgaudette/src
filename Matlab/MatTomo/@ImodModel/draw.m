%draw           Draw the IMOD model on the current display
%
%   draw(imodModel)
%
%   imodModel  The ImodModel
%
%   ImodModel.draw draws the complete model on the current figure and axis.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/07/07 17:26:54 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function draw(imodModel)

for iObject = 1:imodModel.nObjects
  imodObject = getObject(imodModel, iObject);
  
  % Set the color order to match the specified color of the object,
  % save the old color order to reset when we are done
  oldColorOrder = get(gca, 'ColorOrder');
  set(gca, 'ColorOrder', getColor(imodObject));
  for iContour = 1:getNContours(imodObject)
    imodContour = getContour(imodObject, iContour);
    points = getPoints(imodContour);
    plot3(points(1,:), points(2,:), points(3,:), '+')
  end
  set(gca, 'ColorOrder', oldColorOrder);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: draw.m,v $
%  Revision 1.4  2005/07/07 17:26:54  rickg
%  Switched to 3D plotting
%
%  Revision 1.3  2005/05/08 17:47:34  rickg
%  Comment update
%
%  Revision 1.2  2005/05/06 21:05:20  rickg
%  Comment updates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%