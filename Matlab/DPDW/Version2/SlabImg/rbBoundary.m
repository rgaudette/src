%rbBoundary     Boundary selector radio button control function.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:14 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rbBoundary.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:14  rickg
%  Matlab Source
%
%  Revision 1.3  1998/07/30 19:54:32  rjg
%  Removed SIdefines codes, uses string now.
%
%  Revision 1.2  1998/06/03 16:39:53  rjg
%  Uses SIdefines codes
%
%  Revision 1.1  1998/04/28 20:27:28  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rbBoundary(str)

UIHandles = get(gcf, 'UserData');

switch str
case 'Infinite'
    set(UIHandles.ExtrapBnd, 'value', 0);
    set(UIHandles.InfMedium, 'value', 1);
case 'Extrapolated'
    set(UIHandles.InfMedium, 'value', 0);
    set(UIHandles.ExtrapBnd, 'value', 1);
end
