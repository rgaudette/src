%TYPESLCT       I3D graph type select.
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
%  $Log: typeslct.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/20 04:50:00  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function typeslct
global posMessageL1 posMessageL2 posMessageL3
global hRadMesh hRadSurf hRadSurfl

hRadMesh = uicontrol('Style', 'RadioButton', ...
                     'Position', posMessageL1, ...
                     'String', 'Mesh', ...
                     'CallBack', 'inimesh;i3dstlbl(''Mesh'');radclean');

hRadSurf = uicontrol('Style', 'RadioButton', ...
                     'Position', posMessageL2, ...
                     'String', 'Surface', ...
                     'CallBack', 'inisurf;i3dstlbl(''Surface'');radclean');

hRadSurfl = uicontrol('Style', 'RadioButton', ...
                      'Position', posMessageL3, ...
                      'String', 'Lighted Surface', ...
                      'CallBack', 'inisurfl;i3dstlbl(''Lighted'');radclean');
