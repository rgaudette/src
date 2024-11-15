%DIV2D          2D divergence operator
%
%   D2 = div2d(nX, nY)
%
%   D2          The 2D sparse divergence operator.
%
%   nX, nY      The number of X and Y samples (this is the number of columns
%               and rows respectiveley of the 2D domain).
%
%
%   DIV2D generates a 2D divergence operator using a sparse matrix.  The
%   assumes column major ordering in the data to be operated on.
%   Additionally, the direction of increasing y is down the columns, this is
%   the same format generated by meshgrid.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:08 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: div2d.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function D2 = div2d(nX, nY)

%%
%%  Compute the size of the sparse matrix
%%
M = (nX - 2)*(nY-2);
N = nX * nY;

%%
%%  Calculate the column major mapping of the vector to be operated on
%%
[l iY] = meshgrid(2:(nX-1), 2:(nY-1));
l = (l(:) - 1) * nY + iY(:);

%%
%%  Fill in the non-zero entries
%%
D2 = sparse([1:M 1:M 1:M 1:M], [l-nY l-1 l+nY l+1], ...
    [repmat(-1, 1, 2*M) ones(1, 2*M) ], M, N);
