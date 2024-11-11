%I3DRDINC       I3D increment reader
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
%  $Log: i3drdinc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:52  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/20 04:44:33  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3drdinc

global incrSample hTextIncr
global posEdit hEdit hMsg

%%
%%  Read in the new increment value.
%%
incrSample = eval(get(hEdit, 'String'));
set(hTextIncr, 'String', ['Increment: ' int2str(incrSample)]);

%%
%%  Delete the dialog box.
%%
delete(hMsg);
delete(hEdit);
