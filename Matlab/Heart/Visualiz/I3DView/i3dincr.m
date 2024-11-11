%I3DINCR        I3D increment dialog box
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
%  $Log: i3dincr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:52  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/20 04:43:25  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3dincr

global incrSample
global posMessageL1 posMessageL2
global hMsg hEdit

figure(3)
hMsg = uicontrol('Style', 'Text', ...
        'Position', posMessageL1, ...
        'HorizontalAlignment', 'Left', ...
        'String', 'Enter new increment size');

hEdit = uicontrol('Style', 'Edit', ...
        'Position', posMessageL2, ...
        'BackgroundColor','white',...
        'String', int2str(incrSample), ...
        'CallBack', 'i3drdinc');