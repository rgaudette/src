%JACITER        Solve the Laplacian diff eq using jacobi iterations
%
%   [u, nIter, u_prev] = jaciter(h, m, bc, tol, nIterMax)
function [u, nIter, u_prev] = jaciter(h, m, bc, tol, nIterMax)

if nargin < 5
    nIterMax = 1000;
end

%%
%%  Initialize the solution matrix
%%
u = zeros(m,m);
u_prev = zeros(m,m);

%%
%%  Initialize the boundary conditions
%%
[nConds junk] = size(bc);
for i=1:nConds
    u(bc(i,1),bc(i,2)) = bc(i,3);
end

%%
%%  Generate the laplacian operator
%%
L = lapljac(m,m) * 0.25;

%%
%%  Interate until the laplacian operation until it converges  converges
%%
nIter = 1;
u_prev = u;
u = L*u_prev + u_prev*L;
while any(any(abs(u - u_prev) > abs(u) * tol))
    u_prev = u;
    u = L*u_prev + u_prev*L;
    
    for i=1:nConds
        u(bc(i,1),bc(i,2)) = bc(i,3);
    end

    if ~ rem(nIter, 100)
        nIter = nIter + 1
    else
        nIter = nIter + 1;
    end
    
    if nIter >= nIterMax
        break
    end     
end
