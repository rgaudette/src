%I3DRDVPT       I3D view point reader
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
%  $Log: i3drdvpt.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/20 04:45:17  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3drdvpt

global hEdit hMsg
global hTextAz hTextEl

%%
%%  Read in the new increment value.
%%
AzElVec = eval(get(hEdit, 'String'));
set(hTextAz, 'String', ['Azimuth: ' num2str(AzElVec(1))]);
set(hTextEl, 'String', ['Elevation: ' num2str(AzElVec(2))]);

figure(1)
view(AzElVec);
figure(3)

%%
%%  Delete the dialog box.
%%
delete(hMsg);
delete(hEdit);