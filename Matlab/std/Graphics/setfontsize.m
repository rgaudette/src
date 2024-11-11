%setfontsize    Set the font size for all text elements in the figure
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/27 13:01:51 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hc = setfontsize(szFont);

hFigCh = get(gcf, 'Children');
nFigCh = length(hFigCh);
for iAxes = 1:nFigCh,

  %%  Get the children of the current axes
  hAxesCh = get(hFigCh(iAxes), 'Children');
  nAxesCh = length(hAxesCh);

  %%  Loop over each child object checking the type
  for iChild=1:nAxesCh
    ChType = get(hAxesCh(iChild),'Type');

    if strcmp(ChType,'text')
      setTextProps(hAxesCh(iChild), szFont);
    end
  end
  
  setTextProps(gca, szFont);
  setTextProps(get(gca,'xlabel'), szFont)
  setTextProps(get(gca,'ylabel'), szFont)
  setTextProps(get(gca,'zlabel'), szFont)
  setTextProps(get(gca,'title'), szFont)
end

function setTextProps(handle, szFont)
set(handle,'FontSize', szFont)
set(handle, 'FontName', 'helvetica');
set(handle, 'FontWeight', 'Bold');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: setfontsize.m,v $
%  Revision 1.3  2005/08/27 13:01:51  rickg
%  Fixed default parameter bug
%
%  Revision 1.2  2005/03/18 23:45:18  rickg
%  Switched font to helvetica for better printing
%
%  Revision 1.1  2005/03/18 22:29:21  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
