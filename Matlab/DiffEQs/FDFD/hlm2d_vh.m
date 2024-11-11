%HLM2D_VH       2D Helmholtz Equation with variable h.
%
%   phi = hlm2d_vh(x, y, k, q)
%
%   phi         The solution to the Helmholtz equation.
%
%   x           The sampling points in the x dimension.
%
%   y           The sampling points in the y dimension.
%
%   k           The complex wavenumber for the region of interest.
%
%   q           The source function.
%
%   HLM2D_VH computes the solution to the 2D Helmholtz equation by a FDFD
%   approach with a variable step size.  The problem is posed as a sparse
%   linear system of equations and solved using the 
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:23:59 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: hlm2d_vh.m,v $
%  Revision 1.1.1.1  2004/01/03 08:23:59  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [phi, A] = hlm2d_vh(x, y, k, q)

[M N] = size(k);

%%
%%  Create the step size vectors
%%
hx = diff(x);
hx = [hx(1); hx; hx(end)];
hy = diff(y);
hy = [hy(1); hy; hy(end)];

%%
%%  Create the sparse matrix
%%
nPixels = M*N;
nnz = 5 * nPixels;
Ab = sparse([], [], [], (M+1)*(N+1), (M+1)*(N+1), 5*(M+1)*(N+1));

%%
%%  Loop over each pixel filling the appropriate columns.
%%
for n = 1:N
    for m = 1:M
        iRow = mn2i(m+1,n+1,M+1);
        Ab(iRow, iRow) = -2 / (hx(n+1)*hx(n)) -2 / (hy(m+1)*hy(m)) - ...
            k(m,n)^2;
        Ab(iRow, iRow-1) = 2 / (hy(m) * (hy(m+1) + hy(m)));
        Ab(iRow, iRow+1) = 2 / (hy(m) * (hy(m+1) + hy(m)));        
        Ab(iRow, mn2i(m+1,n,M+1)) = 2 / (hx(n) * (hx(n+1) + hx(n)));
        Ab(iRow, mn2i(m+1,n+2,M+1)) = 2 / (hx(n+1) * (hx(n+1) + hx(n)));
    end
end
[mi mj] = meshgrid(2:M+1, 2:N+1);
im = mn2i(mi(:), mj(:), M+1);
A = Ab(im,im);

%%
%%  Solve the system
%%
phi = A \ q(:);
phi = reshape(phi, M, N);

%%
%%  mn2i: Convert row column indices into a stacked vector index
%%
function idx = mn2i(m, n, M)
idx = (n - 1) * M + m;