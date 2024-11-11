%rbColorRange   Color range radio button control function.
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
%  $Log: rbColorRange.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:14  rickg
%  Matlab Source
%
%  Revision 1.3  1998/07/30 19:55:05  rjg
%  Removed SIdefines codes, uses string now.
%
%  Revision 1.2  1998/06/03 16:40:24  rjg
%  Uses SIdefines codes
%
%  Revision 1.1  1998/04/29 15:15:43  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rbColorRange(value)

UIHandles = get(gcf, 'UserData');

switch value 
case 'fixed'
    set(UIHandles.CRangeAuto, 'value', 0);
    set(UIHandles.CRangeFixed, 'value', 1);
    set(UIHandles.CRangeVal, 'Enable', 'on');
    set(UIHandles.CRangeVal, 'BackgroundColor', [1 1 1]);    
    
case 'auto'
    set(UIHandles.CRangeVal, 'Enable', 'off');
    set(UIHandles.CRangeVal, 'BackgroundColor', [0.65 0.65 0.65]);    
    set(UIHandles.CRangeFixed, 'value', 0);
    set(UIHandles.CRangeAuto, 'value', 1);
end
