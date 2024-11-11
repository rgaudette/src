%LAPL2D         2D Laplacian operator
%
%   L2 = lapld(nX, nY)
%
%   L2          The 2D sparse Laplacian operator.
%
%   nX, nY      The number of X and Y samples (this is the number of columns
%               and rows respectiveley of the 2D domain).
%
%
%   LAPL2D generates a 2D laplacian operator.
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
%  $Log: lapl2d.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function L2 = lapl2d(nX, nY)

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
L2 = sparse([1:M 1:M 1:M 1:M 1:M], [l l+nY l-nY l-1 l+1], ...
    [repmat(4, 1, M) repmat(-1, 1, 4*M)], M, N);

