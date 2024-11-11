%rbVisualize    Visualize technique selector radio button control function.
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
%  $Log: rbVisualize.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%  Revision 1.3  1998/07/30 20:02:08  rjg
%  Removed SIdefines codes, uses string now.
%
%  Revision 1.2  1998/06/03 16:43:19  rjg
%  Uses SIdefines codes
%
%  Revision 1.1  1998/04/29 15:15:59  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rbVisualize(value)

UIHandles = get(gcf, 'UserData');


switch value
case 'contour'
    set(UIHandles.Image, 'value', 0);
    set(UIHandles.Contour, 'value', 1);
    set(UIHandles.nCLines, 'Enable', 'on');
    set(UIHandles.nCLines, 'BackgroundColor', [1 1 1]);    
    
case 'image'
    set(UIHandles.nCLines, 'Enable', 'off');
    set(UIHandles.nCLines, 'BackgroundColor', [0.65 0.65 0.65]);    
    set(UIHandles.Contour, 'value', 0);
    set(UIHandles.Image, 'value', 1);
end
