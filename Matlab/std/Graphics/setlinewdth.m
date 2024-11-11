%SETLINEWDTH    Set the line width for a children in the current axis.
%
%   hChildren = setlinewdth(width)
%
%   hChildren   The handles to the children of the current axis.
%
%   width      The weight to set the children.
%
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
%  $Log: setlinewdth.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:06  rickg
%  Matlab Source
%
%  Revision 1.1  1997/08/06 17:49:55  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hChildren = setlinewdth(width)


hChildren = get(gca, 'Children');

if isempty(hChildren)
   return;
end

nChild = length(hChildren);

for iChild = 1:nChild
    if(strcmp('line', get(hChildren(iChild), 'type')))
        set(hChildren(iChild), 'LineWidth', width)
    end
end
