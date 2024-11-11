%rbColormap     Colormap selector radio button control function.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:58 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rbColormap.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:58  rickg
%  Matlab Source
%
%  Revision 1.3  1998/07/30 19:59:47  rjg
%  Removed SIdefines codes, uses string now.
%
%  Revision 1.2  1998/06/03 16:40:43  rjg
%  Uses SIdefines codes
%
%  Revision 1.1  1998/04/29 15:15:50  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rbColormap(value)

UIHandles = get(gcf, 'UserData');

switch value
case 'grey'
    set(UIHandles.CMapBgyor, 'value', 0);
    set(UIHandles.GreyScale, 'value', 1);
case 'bgyor'
    set(UIHandles.GreyScale, 'value', 0);
    set(UIHandles.CMapBgyor, 'value', 1);
end
