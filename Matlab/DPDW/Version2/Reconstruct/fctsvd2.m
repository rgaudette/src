%FCTSVD2        Truncated FC-SVD solution to a fat matrix problem for all r.
%
%   [xtsvd U S V]= fctsvd2(A, b, thresh, U, S, V)
%
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
%  $Log: fctsvd2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xtsvd, U, S, V] = fctsvd2(A, b, thresh, U, S, V)

%%
%%  Compute the economy SVD of the tall problem if necessary
%%
[m n] = size(A);
if nargin < 6
    [V S U] = svd(A', 0);
end

%%
%%  Compute the fourier coefficients
%%
fc = U' * b;
if length(thresh) == 1
    svd_thresh = U' * ones(size(b)) * thresh;
else
    svd_thresh = U' * thresh;
end
%%
%%  Sort the fourier coefficients
%%
fcratio = abs(fc) ./ abs(svd_thresh);
[v idxsort] = sort(fcratio);
idxsort = rev(idxsort);

%%
%%  Set any singular below  the threshold to zero in the sigma inverse vector
%%
s = diag(S);
sigma_thresh = s(1) * 1E-10;
sinv = s .^ -1;
sinv(s < sigma_thresh) = 0;

xtsvd = zeros(n, m);
for i = 1:m
    fczero = zeros(size(fc));
    fczero(idxsort(1:i)) = fc(idxsort(1:i));
    xtsvd(:,i) = V * (s .^-1 .* fczero);
end
