%HLM1D_VHA      1D Helmholtz Equation with variable sampling.
%
%   phi = hlm1d_vh(x, k, q)
%
%   phi         The solution to the Helmholtz equation.
%
%   x           The value of the sampling points.
%
%   k           The complex wavenumber for the region of interest.
%
%   q           The source function.
%
%   HLM1D_VH computes the solution to the 1D Helmholtz equation by a FDFD
%   approach with a variable step size.  The problem is posed as a sparse
%   linear system of equations and solved using MATLABs backslash operator.
%
%   The 1D Helmholtz equation for this function is defined as
%
%    d^2 
%   ----- phi(x) + k(x)^2 = q(x) 
%    dx^2
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
%  $Log: hlm1d_vha.m,v $
%  Revision 1.1.1.1  2004/01/03 08:23:59  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [phi] = hlm1d_vha(x, k, q)

x = x(:);
k = k(:);
q = q(:);
N = length(x);
h = diff(x);
h = [h(1); h; h(end)];
n = [1:N]';

Ai = [n+1; n+1; n+1];
Aj = [n; n+2; n+1];
As = [2./(h(n).*(h(n+1)+h(n)))
      2./(h(n+1).*(h(n+1)+h(n)))
      -2./(h(n+1).*h(n))+k.^2];
Ab = sparse(Ai, Aj, As, N+2, N+2);

% for n = 1:N
%     Ab(n+1, n) = 2/(h(n)*(h(n+1)+h(n)));
%     Ab(n+1, n+2) = 2/(h(n+1)*(h(n+1)+h(n)));
%     Ab(n+1, n+1) = -2/(h(n+1)*h(n)) - k(n)^2;
% end

%%
%%  Trim matrix to simulate zero boundary condition.
%%
A = Ab(2:N+1, 2:N+1);
    
%%
%%  Solve the system
%%
phi = A \ q;
