%DOCFIG1        Format the current axis for a document - type 1.
%
%   DOCFIG1 changes the fonts of the labels and axis labels to Times-Roman
%   14 pt. bold.  This is suitable for a ~ 3x3 in figure.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:05 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: docfig1.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:05  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/15 22:47:05  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function docfig1(flgResizeFig)
if nargin > 0,
    if flgResizeFig
        FigPos = get(gcf, 'Position');
        FigPos(3) = 640;
        FigPos(4) = 480;
        set(gcf, 'Position', FigPos);
    end
end

hax = gca;

set(hax, 'FontName', 'Times');
set(hax, 'FontWeight', 'Bold');
set(hax, 'FontSize', 14);

hxl = get(hax, 'xlabel');
set(hxl, 'FontName', 'Times');
set(hxl, 'FontWeight', 'Bold');
set(hxl, 'FontSize', 14);

hyl = get(hax, 'ylabel');
set(hyl, 'FontName', 'Times');
set(hyl, 'FontWeight', 'Bold');
set(hyl, 'FontSize', 14);

ht = get(hax, 'title');
set(ht, 'FontName', 'Times');
set(ht, 'FontWeight', 'Bold');
set(ht, 'FontSize', 14);

hzl = get(hax, 'zlabel');
set(hzl, 'FontName', 'Times');
set(hzl, 'FontWeight', 'Bold');
set(hzl, 'FontSize', 14);
