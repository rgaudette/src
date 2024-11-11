%JACITEREB      Solve the Laplacian diff eq using jacobi iterations exp. bound
%
%   [u, nIter, u_prev] = jacitereb(h, m, bc, tol, nIterMax)
function [u, nIter, u_prev] = jacitereb(h, m, bc, tol, nIterMax)

if nargin < 5
    nIterMax = 1000;
end

%%
%%  Initialize the solution matrix
%%
u = ones(m,m);
u_prev = ones(m,m);

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
while any(any((abs(u - u_prev) ./ abs(u)) > tol))
    u_prev = u;
    u = L*u_prev + u_prev*L;

    for i=1:nConds
        u(bc(i,1),bc(i,2)) = bc(i,3);
        u_prev(bc(i,1),bc(i,2)) = bc(i,3);
    end
  

    %%
    %%  Make the grid boundary a continuous exponential
    %%
%    step = 20;
%    if all((u(2:m-1,m-step)> 0) &  u(2:m-1,m-2*step) > 0)
%        k = log(u(2:m-1,m-step)./ u(2:m-1,m-2*step)) ./ step;
%        xo = -1 * (log(u(2:m-1,m-2*step)) + k .* (m - 2*step));
%        u(2:m-1, m) = exp(-k*m-xo);
%    end
%    if all((u(2:m-1,step)> 0) &  u(2:m-1,2*step) > 0)
%        k = log(u(2:m-1,step)./ u(2:m-1,2*step)) ./ step;
%        xo = -1 * (log(u(2:m-1,2*step)) + k .* (2*step));
%        u(2:m-1, 1) = exp(-k*m-xo);
%    end
%
%    if all((u(m-step,2:m-1)> 0) &  u(m-2*step,2:m-1) > 0)
%        k = log(u(m-step,2:m-1)./ u(m-2*step,2:m-1)) ./ step;
%        xo = -1 * (log(u(m-2*step,2:m-1)) + k .* (2 * step));
%        u(m,2:m-1) = exp(-k*m-xo);
%    end
%    if all((u(step,2:m-1)> 0) &  u(2*step,2:m-1) > 0)
%        k = log(u(step,2:m-1)./ u(2*step,2:m-1)) ./ step;
%        xo = -1 * (log(u(2*step,2:m-1)) + k .* (2 * step));
%        u(1,2:m-1) = exp(-k*m-xo);
%    end

    step = 20;
    if all((u(2:m-1,m-step)> 0) &  u(2:m-1,m-2*step) > 0)
        k = log(u(2:m-1,m-step)./ u(2:m-1,m-2*step)) ./ step;
        xo = -1 * (log(u(2:m-1,m-2*step)) + k .* (m - 2*step));
        u(2:m-1, m) = exp(-k*m-xo);
    end
    if all((u(2:m-1,step)> 0) &  u(2:m-1,2*step) > 0)
        k = log(u(2:m-1,step)./ u(2:m-1,2*step)) ./ step;
        xo = -1 * (log(u(2:m-1,2*step)) + k .* (2*step));
        u(2:m-1, 1) = exp(-k*m-xo);
    end

    if all((u(m-step,2:m-1)> 0) &  u(m-2*step,2:m-1) > 0)
        k = log(u(m-step,2:m-1)./ u(m-2*step,2:m-1)) ./ step;
        xo = -1 * (log(u(m-2*step,2:m-1)) + k .* (2 * step));
        u(m,2:m-1) = exp(-k*m-xo);
    end
    if all((u(step,2:m-1)> 0) &  u(2*step,2:m-1) > 0)
        k = log(u(step,2:m-1)./ u(2*step,2:m-1)) ./ step;
        xo = -1 * (log(u(2*step,2:m-1)) + k .* (2 * step));
        u(1,2:m-1) = exp(-k*m-xo);
    end
    
    
    if ~ rem(nIter, 100)
        nIter = nIter + 1
        mean(mean(abs(u - u_prev)./abs(u)))
        matmax(abs(u - u_prev)./abs(u))
    else
        nIter = nIter + 1;
    end
    
    if nIter >= nIterMax
        break
    end     
end
