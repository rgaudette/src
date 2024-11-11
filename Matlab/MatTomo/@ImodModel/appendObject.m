%appendObject  Append the specified ImodObject to the ImodModel
%
%   imodModel = appendObject(imodModel, imodObject)
%
%   imodModel  The ImodModel object.
%
%   imodObject The ImodObject to append to the end of the ImodModel
%
%   ImodModel.appendObject adds the specified imodObject to the list of objects
%   for this model.  If the color of the object is unset (black) then it is set
%   to the next color in the color list as specified by
%   ImodModel.getDefaultColor
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

function imodModel = appendObject(imodModel, imodObject)

imodModel.nObjects = imodModel.nObjects + 1;

% If the color is unset (black) set it
color = getColor(imodObject);
if all(color == 0.0)
  color = getDefaultColor(imodModel, imodModel.nObjects);
  imodObject = setColor(imodObject, color);
end 
  
imodModel.Objects{imodModel.nObjects}  = imodObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: appendObject.m,v $
%  Revision 1.4  2005/05/06 22:05:57  rickg
%  Comment updates
%
%  Revision 1.3  2005/05/06 21:05:20  rickg
%  Comment updates
%
%  Revision 1.2  2004/09/18 20:48:47  rickg
%  Set object color if it is black (default)
%
%  Revision 1.1  2004/09/17 23:56:10  rickg
%  Initial revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
