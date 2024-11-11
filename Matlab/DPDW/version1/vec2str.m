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
%  $Date: 2004/01/03 08:26:00 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: vec2str.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:00  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/28 20:36:49  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function str = vec2str(vec)
vec = vec(:)';
str = '[';
for elem = vec
    str = [ str num2str(elem) ' '];
end
str = [str ']' ];