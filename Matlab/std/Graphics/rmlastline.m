%RMLASTLINE     Remove the last line plotted on the current axis
%
%   rmlastline
%
%   RMLASTLINE gets the children of the current axis and deletes the first
%   on the list which is the last one plotted.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:06 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rmlastline.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:06  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 15:55:04  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rmlastline
hChildren = get(gca, 'children');
delete(hChildren(1));
