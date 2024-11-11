%rbVisPlane     Visualization radio button control function.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:41 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rbVisPlane.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%  Revision 2.0  1998/08/07 21:31:55  rjg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rbVisPlane(value)

UIHandles = get(gcf, 'UserData');

set(UIHandles.XPlane, 'value', 0);
set(UIHandles.YPlane, 'value', 0);
set(UIHandles.ZPlane, 'value', 0);
switch value 
case 'X'
    set(UIHandles.XPlane, 'value', 1);
case 'Y'
    set(UIHandles.YPlane, 'value', 1);
case 'Z'
    set(UIHandles.ZPlane, 'value', 1);
end
