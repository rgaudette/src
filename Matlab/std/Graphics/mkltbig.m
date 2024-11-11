%mkltbig        Bolden the line types on a graph.
%
%   mkltbig(wdLines)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/10/24 21:54:44 $
%
%  $Revision: 1.5 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mkltbig(wdLines)
if nargin < 2
    szFont = 14;
    if nargin < 1
        wdLines = 2;
    end
end

hFigCh = get(gcf, 'Children');
nFigCh = length(hFigCh);
for iAxes = 1:nFigCh,

  %%  Get the children of the current axes
  hAxesCh = get(hFigCh(iAxes), 'Children');
  nAxesCh = length(hAxesCh);

  %%  Loop over each child object checking the type
  for iChild=1:nAxesCh
    ChType = get(hAxesCh(iChild),'Type');
    if strcmp(ChType, 'line')
      set(hAxesCh(iChild),'LineWidth', wdLines)
    end
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: mkltbig.m,v $
%  Revision 1.5  2005/10/24 21:54:44  rickg
%  Removed fontsize references
%
%  Revision 1.4  2005/08/27 13:01:36  rickg
%  Removed text size setting, use setfontsize
%
%  Revision 1.3  2005/03/18 23:44:13  rickg
%  Comment updates
%  Switched font to helvetica for better printing
%
%  Revision 1.2  2004/11/12 03:51:40  rickg
%  updated size and default font
%
%  Revision 1.1.1.1  2004/01/03 08:25:05  rickg
%  Matlab Source
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
