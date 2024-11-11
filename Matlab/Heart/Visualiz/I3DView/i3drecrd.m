%I3DRECRD       I3D movie record reader
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
%  $Log: i3drecrd.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/20 04:45:42  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3drecrd

global nFrames
global posMessageL1 posMessageL2 posMessageL3 posMessageL4
global hMsg hEdit hRec

figure(3)
hMsg = uicontrol('Style', 'Text', ...
        'Position', posMessageL1, ...
        'HorizontalAlignment', 'Left', ...
        'String', 'Number of frames to record');

hEdit = uicontrol('Style', 'Edit', ...
        'Position', posMessageL2, ...
        'BackgroundColor','white',...
        'String', int2str(nFrames), ...
        'CallBack', 'i3drdnfr');
posButton = posMessageL4;
posButton(4) = posMessageL4(4) * 2;
hRec = uicontrol('Style', 'pushbutton', ...
        'Position', posButton, ...
        'String', 'Record ...', ...
        'CallBack', 'i3drecst');
