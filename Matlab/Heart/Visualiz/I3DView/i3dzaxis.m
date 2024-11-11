%I3DZAXIS       I3D Z axis dialog box.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:54 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: i3dzaxis.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/20 04:48:27  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3dzaxis

global posMessageL1 posMessageL2 posMessageL3 hEdit hMsg

figure(1)
Axis = axis;
nAxis = length(Axis);
figure(3)
strAzEl = [ '[' num2str(Axis(nAxis-1)) ' ' num2str(Axis(nAxis)) ']' ];

hMsg1 = uicontrol('Style', 'Text', 'HorizontalAlignment', 'Left', ...
        'Position', posMessageL1, ...
        'String', 'Enter a new z axis range');

hMsg2 = uicontrol('Style', 'Text', 'HorizontalAlignment', 'Left', ...
        'Position', posMessageL2, ...
        'String', '   [zMin zMax] or 0 for auto');

hMsg = [hMsg1 hMsg2];

hEdit = uicontrol('Style', 'Edit', 'Position', posMessageL3, ...
        'BackgroundColor','white',...
        'String', strAzEl, 'CallBack', 'i3drdzax');
