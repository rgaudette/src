%FATTSVDALL     Truncated SVD solution to a fat matrix problem for all r.
%
%   [xtsvd U S V]= fattsvdall(A, b, U, S, V)
%
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:36 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: fattsvdall2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:36  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xtsvd, U, S, V] = fattsvdall(A, b, U, S, V)

[m n] = size(A);

%%
%%  Compute the economy SVD of the tall problem if necessary
%%
if nargin < 5
    [V S U] = svd(A', 0);
end
xtsvd = zeros(n, m);
bproj = A' * b;

for r = 1:m
    xtsvd(:,r) = U(:,1:r) * (diag(S(1:r,1:r)).^-2 .* ((U(:,1:r))' * bproj));
end
