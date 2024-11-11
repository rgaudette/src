%LAPL1D         1D Laplacian operator
%
%   L1 = lapld(nX)
%
%   L1          The 1D sparse Laplacian operator.
%
%   nX
%
%
%   LAPL1D generates a 1D laplacian operator.
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
%  $Log: lapl1d.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function L1 = lapl1d(nX)

%%
%%  Compute the size of the sparse matrix
%%
M = (nX - 2);
N = nX;


%%
%%  Fill in the non-zero entries
%%
L1 = sparse([1:M 1:M 1:M], [(2:M+1) 1:M (3:M+2)], ...
    [repmat(2, 1, M) repmat(-1, 1, 2*M)], M, N);

