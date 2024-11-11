%FATMTSVD       Modified truncated SVD solution.
%
%   [xlm, xtsvd, xns, U, S, V] = fatmtsvd(A, b, r, L, lambda, U, S, V)
%
%   xlm         The minimized semi-norm solution.
%
%   xtsvd       The truncated SVD solution.
%
%   xns         The null space vector subtracted from the truncated SVD
%               solution meet the constriant.
%
%   U,S,V       The SVD of A.
%
%   A,b         The system to be solved.
%
%   r           The number of singular values/singular vectos to use for the
%               truncated SVD system.
%
%   L           The semi-norm operator.
%
%   lambda      A parameter that controls how much of the null space is
%               added to the truncated SVD solution.
%
%   Reference: Piecewise Polynomial Solutions Without a priori Break Points
%              P.C. Hansen, Klaus Mosegaard,  Numerical Linear Algebra with
%              Applications, Vol 3(6) 513-524 1996
%
%
%   Calls: none.
%
%   Bugs: not sure if this solves the short-fat problem correctly?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:57 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: fatmtsvd.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:57  rickg
%  Matlab Source
%
%  Revision 1.1  1998/06/03 16:12:22  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xlm, xtsvd, xns, U, S, V] = fatmtsvd(A, b, r, L, lambda, U, S, V)

[M N] = size(A);
if nargin < 5
    lambda = 1;
end

%%
%%  Compute the SVD of the forward matrix
%%
if nargin < 8
    [U S V] = svd(A);
end

%%
%%  Compute the minimum norm solution to the truncated system.
%%
xtsvd = V(:,1:r)* (diag(S(1:r,1:r)).^-1 .* ((U(:,1:r))' * b));

%%
%%  Minimize the semi-norm with the null space of the truncated operator
%%
yls = (L * V(:,r+1:N)) \ (L * xtsvd);
xns = V(:,r+1:N) * yls;
xlm = xtsvd - lambda * xns;
