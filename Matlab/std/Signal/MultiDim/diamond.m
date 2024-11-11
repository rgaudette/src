%DIAMOND        Generate a 2D "diamond" signal.
%
%    X = diamond(N, M);
%
%    X          The 2D "diamond" signal of 0 and 1.
%
%    N          The size of the diamond, in elements point-to-point.
%
%    M          [OPTIONAL] The size of the surrounding matrix.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:21 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: diamond.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:21  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:48:25  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function X = diamond(N, M)

if nargin < 2,
    M = N;
end

%%
%%   Create a diamond of ones, if cross dimension is even the number of ones
%%   in the top row is 2, otherwise there is a single one in the top row.
%%
if rem(N,2)
    LowTri = tril(ones(ceil(N/2)));
    [nRow nCol] = size(LowTri);
    Diamond = [fliplr(LowTri) LowTri(:, 2:nCol)];
    Diamond = [ Diamond(1:nRow-1,:); flipud(Diamond)];
else
    LowTri = tril(ones(N/2));
    Diamond = [fliplr(LowTri) LowTri];
    Diamond = [ Diamond ; flipud(Diamond) ];
end
    
if N ~= M,
    X = zeros(M);
    Offset = floor((M - N) / 2);
    X(Offset+1:Offset+N, Offset+1:Offset+N) = Diamond;
else
    X = Diamond;
end
