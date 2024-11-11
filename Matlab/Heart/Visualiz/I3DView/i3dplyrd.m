%I3DPLYRD       I3D movie play reader
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:52 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: i3dplyrd.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:52  rickg
%  Matlab Source
%
%  Revision 1.1  1997/04/06 19:18:50  rjg
%  Initial revision
%
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3dplyrd

global nFrames nRepeat frmRate
global posMessageL1 posMessageL2 posMessageL3 posMessageL4 posMessageL5 posMessageL6
global hMsgNRepeat hEditNRepeat hMsgRate hEditRate hRec

figure(3)
hMsgNRepeat = uicontrol('Style', 'Text', ...
        'Position', posMessageL1, ...
        'HorizontalAlignment', 'Left', ...
        'String', 'Number of Times');

hEditNRepeat = uicontrol('Style', 'Edit', ...
        'Position', posMessageL2, ...
        'BackgroundColor','white',...
        'String', int2str(nRepeat));

hMsgRate = uicontrol('Style', 'Text', ...
        'Position', posMessageL3, ...
        'HorizontalAlignment', 'Left', ...
        'String', 'Frames/Sec');

hEditRate = uicontrol('Style', 'Edit', ...
        'Position', posMessageL4, ...
        'BackgroundColor','white',...
        'String', int2str(nRepeat));
posButton = posMessageL6;
posButton(4) = posMessageL6(4) * 2;
hRec = uicontrol('Style', 'pushbutton', ...
        'Position', posButton, ...
        'String', 'Play ...', ...
        'CallBack', 'i3dplyst');
