%LAPL3D         3D Laplacian operator
%
%   L3 = lapld(nX, nY, nZ)
%
%   L3          The 3D sparse Laplacian operator.
%
%   nX, nY, nZ  The number of X,Y and Z samples (this is the number of columns
%               rows and planes respectiveley of the 3D domain).
%
%
%   LAPL3D generates a 3D laplacian operator.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:09 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: lapl3d.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:09  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function L3 = lapl3d(nX, nY, nZ)

%%
%%  Compute the size of the sparse matrix
%%
M = (nX - 2)*(nY-2)*(nZ - 2);
N = nX * nY * nZ;

%%
%%  Calculate the column major mapping of the vector to be operated on
%%
[l iY iZ] = meshgrid(2:(nX-1), 2:(nY-1), 2:(nZ-1));
l = (iZ(:) - 1) * (nY*nX) + (l(:) - 1) * nY + iY(:);

%%
%%  Fill in the non-zero entries
%%
L3 = sparse([1:M 1:M 1:M 1:M 1:M 1:M 1:M], ...
    [l l-1 l+1 l+nY l-nY l+(nX*nY) l-(nX*nY)], ...
    [repmat(6, 1, M) repmat(-1, 1, 6*M)], M, N);

