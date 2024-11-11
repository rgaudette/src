%setObjectType  Set the object type of the specified object
%
%   imodModel = setObjectType(imodModel, idxObject, type)
%
%   imodModel   The ImodModel object.
%
%   idxObject   The index of the object whos type to change.
%
%   type      A case insensitive string specifying the object type: either
%             'closed', 'open', 'scattered'
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/08 17:22:49 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodModel = setObjectType(imodModel, idxObject, type)
if idxObject > length(imodModel.Objects)
  error('Object %d does not exist\n', idxObject);
end
iObject = getObject(imodModel, idxObject);
imodModel.Objects{idxObject} = setType(iObject, type);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: setObjectType.m,v $
%  Revision 1.3  2005/05/08 17:22:49  rickg
%  Comment updates
%
%  Revision 1.2  2005/05/06 22:05:57  rickg
%  Comment updates
%
%  Revision 1.1  2005/02/25 23:29:23  rickg
%  *** empty log message ***
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%