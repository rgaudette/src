%LAPLJAC        Create a 1D Laplacian for use in the Jacobi algorithm
%
%   L = lapljac(m, n)
%
%   LAPLJAC generates a sparse Laplacian operator for use in the Jacobi
%   algorithm (i.e. the main diagonal is zero) in one dimension (down the
%   columns of the matrix it is operating on).
%
%   BUGS: current m and n must be equal
function l = lapljac(m, n)

Dmin = min(m,n);
OD = sparse(1:Dmin-1,2:Dmin, ones((Dmin-1),1), m, n);
l = OD + OD';
