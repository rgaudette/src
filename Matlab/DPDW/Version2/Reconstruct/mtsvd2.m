%MTSVD2         Modified truncated SVD solution.
%
%   [xlm, xtsvd, xns, U, S, V] = mtsvd(A, b, r, L, U, S, V)
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
%   r           The range of singular values/singular vectos to use for the
%               truncated SVD system.
%
%   L           The semi-norm operator.
%
%   Reference: The Modified Truncated SVD Method for Regularization in
%              General Form
%              P.C. Hansen, T. Sekii, H. Shibahashi
%              SIAM J. Sci. Stat. Comput.  Vol 13, No. 5, 1142-1150
%              September 1992
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:08 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mtsvd2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xlm, xtsvd, xns, U, S, V] = mtsvd2(A, b, r, L, U, S, V)

[M N] = size(A);

%%
%%  Compute the SVD of the forward matrix
%%
if nargin < 7
    disp('Computing full SVD...');
    [U S V] = svd(A);
end

%%
%%  Compute the truncated SVD solutions for all truncation parameters.
%%
rmax = max(r);
rmin = min(r);
nr = length(r);
disp('Computing truncated SVD solution...');
fc = (U(:,1:rmax)' * b) ./ diag(S(1:rmax,1:rmax));

xtsvd = zeros(N, nr);
for i = 1:nr
    xtsvd(:,i) = V(:,1:r(i)) * fc(1:r(i));
end

%%
%%  Compute the minimum norm solution for y
%%
Lm = size(L,1);
LV = L * V(:, rmin:N);
LXt = L * xtsvd;
xmn = zeros(N, nr);
for i=1:nr
    WNS = LV(:, r-rmin+1:N-rmin);
    z = 
    xmn(:,i) = WNS' * WNS
if Lm < N-r
    disp('Computing the minimum norm solution for the null space...');
    y = fatmn(L*V(:,r+1:N), L*xtsvd);
else
    disp('Computing the least squares solution for the null space...');
    y = (L * V(:,r+1:N)) \ (L * xtsvd);
end

%%
%%  Compute the null space component
%%
disp('Adding in the null space component..');
xns = V(:,r+1:N) * y;
xlm = xtsvd - lambda * xns;
