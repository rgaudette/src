%SUBMAP		Select a portion of a rectangular map.
%
%    [SubMap SubXdist SubYdist] = submap(map, xdist, ydist, select)
%
%    SubMap	The selcted protion of the map
%
%    SubXdist	The x distance vector corrsponding to the submap.
%
%    SubYdist	The y distance vector corrsponding to the submap.
%
%    map	The map array.
%
%    xdist	The x distance values corresponding to the columns of map.
%
%    ydist	The y distance values corresponding to the rows of map.
%
%    select	A 4 element vector descibing the region to select for the
%		submap [xmin xmax ymin ymax] the coordinates are inclusive..
%
%	    SUBMAP 
%
%    Calls: 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:33 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: submap.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:33  rickg
%  Matlab Source
%
%  
%     Rev 1.0   31 Mar 1993 11:36:18   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [SubMap, SubXdist, SubYdist] = submap(map, xdist, ydist, select);

%%
%%    Get indicies of selected area.
%%
idxXSel = find((xdist >= select(1)) & (xdist <= select(2)));
idxYSel = find((ydist >= select(3)) & (ydist <= select(4)));

SubMap = map(idxYSel, idxXSel);

SubXdist = xdist(idxXSel);
SubYdist = ydist(idxYSel);
