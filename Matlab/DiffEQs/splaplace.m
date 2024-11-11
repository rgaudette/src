%SPLAPLACE      Create a sparse laplacian matrix for the Jacobi alg
%
%   L = splaplace(nX, nY)

function l = splaplace(nX, nY)

%%
%%  Allocate space for the matrix
%%
l = sparse([], [], [], nX * nY, nX * nY, 4*(nX-2)*(nY-2) + ...
    3*((2*nX-4)+(2*nY-4)) 8);

%%
%%  Create the main diagonal, this is actually at one element off the main
%%  diagonal, for lengths of nY-2 elements followed by a zero
%%


THERE IS A SIMPLER WAY

