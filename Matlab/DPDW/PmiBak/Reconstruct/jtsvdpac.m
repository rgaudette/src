%JTSVDPAC       Joint Truncated SVD solution with post applied constraint.
%
%   [xpctsvd U S V] = jtsvdpac(A, b, r, C, U, S, V)
%
%   xcptsvd     The truncated SVD solutions with the post applied constraint.
%
%   U, S, V     OPTIONAL: The economy SVD of the block diagonal system.
%
%   A           The two system matrices in a 3D array. A_1 = A(:,:,1),
%               A_2 = A(:,:,2).
%
%   r           The set of truncation parameters to compute.
%
%   C           The expected ratio between x_1 and x_2 as x_1 / x_2.
%
%   
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:37 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: jtsvdpac.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:37  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xpctsvd, U, S, V] = jtsvdpac(A, b, r, C, U, S, V)

m = size(A,1);
n = size(A,2);
b = b(:);

%%
%%  Compute the SVD if not supplied.
%%  This only handles underdetermined systems
%%
if nargin < 6
    [V1 S1 U1] = svd(A(:,:,1)', 0);
    [V2 S2 U2] = svd(A(:,:,2)', 0);
    s1 = diag(S1);
    s2 = diag(S2);
    [sr ipr] = sort([s1; s2]);
    iPermute = rev(ipr);

    U = [U1 zeros(size(U1)); zeros(size(U1)) U2];
    U = U(:, iPermute);
    V = [V1 zeros(size(V1)); zeros(size(V1)) V2];
    V = V(:, iPermute);
    S = diag(rev(sr));
end


%%
%%  Compute the truncated SVD solutions for all truncation parameters.
%%
rmax = max(r);
rmin = min(r);
nr = length(r);
disp('Computing truncated SVD solution...');
fc = (U(:,1:rmax)' * b) ./ diag(S(1:rmax,1:rmax));

xtsvd = zeros(2*n, nr);
for i = 1:nr
    xtsvd(:,i) = V(:,1:r(i)) * fc(1:r(i));
end

%%
%%  Apply the post processing constraint
%%
[xpc1 xpc2] = postconstrain(xtsvd(1:n,:), xtsvd(n+1:2*n,:), C);

xpctsvd = [xpc1; xpc2];
