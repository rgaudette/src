%getDefaultColor   Return the default color in the object color sequence 
%
%   color = getDefaultColor(imodModel, idxObject)
%
%   color       The color of the object
%
%   imodModel   The ImodModel object
%
%   idxObject   The index of the object
%
%
%   getDefaultColor returns the color for the given object index that cycles
%   around the red-yellow-green-cyan-blue-magenta color sequence.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/08 17:47:34 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function color = getDefaultColor(imodModel, idxObject)
listColor = [ ...
  1 0 0
  1 1 0
  0 1 0
  0 1 1
  0 0 1
  1 0 1 ];
nColors = size(listColor, 1);

idxColor = rem(idxObject - 1, nColors) + 1;
color = listColor(idxColor, :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: getDefaultColor.m,v $
%  Revision 1.4  2005/05/08 17:47:34  rickg
%  Comment update
%
%  Revision 1.3  2005/05/08 17:33:18  rickg
%  Comment update
%
%  Revision 1.2  2005/05/06 22:05:57  rickg
%  Comment updates
%
%  Revision 1.1  2004/09/18 20:36:49  rickg
%  Initial revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
