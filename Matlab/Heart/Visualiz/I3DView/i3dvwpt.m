%I3DVWPT        I3D viewpoint dialog box
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
%  $Log: i3dvwpt.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/20 04:48:16  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3dvwpt

global posMessageL1 posMessageL2 hEdit hMsg

figure(1)
[Az El] = view;
figure(3)
strAzEl = [ '[' num2str(Az) ' ' num2str(El) ']' ];

hMsg = uicontrol('Style', 'Text', 'HorizontalAlignment', 'Left', ...
        'Position', posMessageL1, ...
        'String', 'Enter new view point [Az El]');

hEdit = uicontrol('Style', 'Edit', 'Position', posMessageL2, ...
        'BackgroundColor','white',...
        'String', strAzEl, 'CallBack', 'i3drdvpt');