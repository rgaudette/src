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
%  $Log: i3drdnfr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:52  rickg
%  Matlab Source
%
%  Revision 1.2  1997/04/06 19:20:24  rjg
%  Added nFrames global
%
%  Revision 1.1  1996/09/20 04:44:47  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global incrSample hTextIncr
global posEdit hEdit hMsg
global nFrames
%%
%%  Read in new number of frames
%%
nFrames = eval(get(hEdit, 'String'));
