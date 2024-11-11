%DOCFIG2        Format the current axis for a document - type 2.
%
%   DOCFIG2 changes the fonts of the labels and axis labels to Times-Roman
%   14 pt.  This is suitable for a ~ 3x3 in figure.  This is similar to 
%   DOCFIG1 but does not make the text bold and does not resize axes.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:05 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: docfig2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:05  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/15 22:50:04  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function docfig1

hax = gca;

set(hax, 'FontName', 'Times');
%set(hax, 'FontWeight', 'Bold');
set(hax, 'FontSize', 14);

hxl = get(hax, 'xlabel');
set(hxl, 'FontName', 'Times');
%set(hxl, 'FontWeight', 'Bold');
set(hxl, 'FontSize', 14);

hyl = get(hax, 'ylabel');
set(hyl, 'FontName', 'Times');
%set(hyl, 'FontWeight', 'Bold');
set(hyl, 'FontSize', 14);

ht = get(hax, 'title');
set(ht, 'FontName', 'Times');
%set(ht, 'FontWeight', 'Bold');
set(ht, 'FontSize', 14);


