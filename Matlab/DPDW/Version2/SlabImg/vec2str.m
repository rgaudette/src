%VEC2STR        Convert a vector to a string.
%
%   str = vec2str(vec)
%
%   str         The resultant string.
%
%   vec         The vector to be converted.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:17 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: vec2str.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:17  rickg
%  Matlab Source
%
%  Revision 2.0  1998/08/06 20:32:32  rjg
%  Removed trailing space in vector.
%  Does not now return brackets when a scalar is passed.
%
%  Revision 1.1  1998/04/28 20:36:49  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function str = vec2str(vec)
nElem = length(vec);
if nElem == 1
    str = num2str(vec);
    return;
end

str = '[';
for iElem = 1:nElem-1
    str = [ str num2str(vec(iElem)) ' '];
end
str = [ str num2str(vec(nElem)) ']' ];
