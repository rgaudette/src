%rbFwdBoundary     Boundary selector radio button control function.
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
%  $Log: rbFwdBoundary.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rbFwdBoundary(str)

UIHandles = get(gcf, 'UserData');

switch str
case 'Infinite'
    set(UIHandles.Fwd_ExtrapBnd, 'value', 0);
    set(UIHandles.Fwd_InfMedium, 'value', 1);
case 'Extrapolated'
    set(UIHandles.Fwd_InfMedium, 'value', 0);
    set(UIHandles.Fwd_ExtrapBnd, 'value', 1);
end
