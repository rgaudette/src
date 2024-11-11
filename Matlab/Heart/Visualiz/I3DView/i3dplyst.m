%I3DPLYST       I3D movie play function
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
%  $Log: i3dplyst.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:52  rickg
%  Matlab Source
%
%  Revision 1.2  1997/04/21 13:13:23  rjg
%  Moved figure command to right before movie call
%
%  Revision 1.1  1997/04/06 19:19:05  rjg
%  Initial revision
%
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3dplyst

global Movie nRepeat frmRate
global hMsgNRepeat hEditNRepeat hMsgRate hEditRate hRec

nRepeat = eval(get(hEditNRepeat, 'String'));
frmRate = eval(get(hEditRate, 'String'));

%%
%%  Delete the frame rate and repeat count for playback
%%
delete(hMsgNRepeat);
delete(hEditNRepeat);
delete(hMsgRate);
delete(hEditRate);
delete(hRec);
figure(1);
movie(gcf, Movie, nRepeat, frmRate);