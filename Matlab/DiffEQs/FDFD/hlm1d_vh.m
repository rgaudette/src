%HLM1D_VH       1D Helmholtz Equation with variable h.
%
%   phi = hlm1d_vh(h, k, q)
%
%   phi         The solution to the Helmholtz equation.
%
%   h           The distance between each sampling point h_i = x_i - x_i+1.
%
%   k           The complex wavenumber for the region of interest.
%
%   q           The source function.
%
%   HLM1D_VH computes the solution to the 1D Helmholtz equation by a FDFD
%   approach with a variable step size.  The problem is posed as a sparse
%   linear system of equations and solved using the CG algoirthm.
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
%  $Log: hlm1d_vh.m,v $
%  Revision 1.1.1.1  2004/01/03 08:23:59  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [phi] = hlm1d_vh(h, k, q)

h = h(:);
k = k(:);
q = q(:);

%%
%%  Diagonal elements
%%
d = -2 ./ (h .* [h(1); h(1:end-1)]) - k.^2;
%%
%%  Super-diagonal elements
%%
S = 2 ./ ((h(1:end-1) + [h(1); h(1:end-2)]) .* h(1:end-1));
%%
%%  Sub-diagonal elements
%%
s = 2 ./ ((h(2:end) + h(1:end-1)) .* h(1:end-1));
%%
%%  Create a sparse matrix of the Helmholtz operator.
%%
m = length(d);
id = [1:m 2:m 1:m-1]';
jd = [1:m 1:m-1 2:m]';
A = sparse(id, jd, [d; s; S], m, m);
%%
%%  Solve the system
%%
phi = A \ q;
