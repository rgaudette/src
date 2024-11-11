%I3DRDNFR       I3D number of movie frame reader
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
%  $Log: i3drdnrp.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:52  rickg
%  Matlab Source
%
%  Revision 1.1  1997/04/06 19:33:03  rjg
%  Initial revision
%
%  Revision 1.1  1996/09/20 04:44:47  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global incrSample hTextIncr
global posEdit hEdit hMsg
global nRepeat
%%
%%  Read in new number of frames
%%
nRepeat = eval(get(hEdit, 'String'));
