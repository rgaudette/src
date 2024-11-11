%DOCFIG6BY6     Format the current axis for a document 6x6 in
%
%   DOCFIG6BY6 changes the fonts of the labels and axis labels to Times-Roman
%   20 pt. bold.  This is suitable for a ~ 6x6 in. figure.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:05 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: docfig6by6.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:05  rickg
%  Matlab Source
%
%  Revision 1.2  1998/04/15 22:56:58  rjg
%  Help section correction.
%
%  Revision 1.1  1998/04/15 22:50:47  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function docfig6by6(flgResizeFig)
if nargin > 0,
    if flgResizeFig
        FigPos = get(gcf, 'Position');
        FigPos(3) = 560;
        FigPos(4) = 503;
        set(gcf, 'Position', FigPos);
    end
end

hax = gca;

set(hax, 'FontName', 'Helvetica');
set(hax, 'FontWeight', 'Bold');
set(hax, 'FontSize', 24);

hxl = get(hax, 'xlabel');
set(hxl, 'FontName', 'Helvetica');
set(hxl, 'FontWeight', 'Bold');
set(hxl, 'FontSize', 24);

hyl = get(hax, 'ylabel');
set(hyl, 'FontName', 'Helvetica');
set(hyl, 'FontWeight', 'Bold');
set(hyl, 'FontSize', 24);

ht = get(hax, 'title');
set(ht, 'FontName', 'Helvetica');
set(ht, 'FontWeight', 'Bold');
set(ht, 'FontSize', 24);

hzl = get(hax, 'zlabel');
set(hzl, 'FontName', 'Helvetica');
set(hzl, 'FontWeight', 'Bold');
set(hzl, 'FontSize', 24);
