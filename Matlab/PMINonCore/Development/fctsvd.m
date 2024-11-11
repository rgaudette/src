%FCTSVD         Truncated FC-SVD solution to a fat matrix problem.
%
%   [xtsvd U S V]= fctsvd(A, b, thresh, U, S, V)
%
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:27:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: fctsvd.m,v $
%  Revision 1.1.1.1  2004/01/03 08:27:29  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xtsvd, U, S, V] = fctsvd(A, b, thresh, U, S, V)

%%
%%  Compute the economy SVD of the tall problem if necessary
%%
[m n] = size(A);
if nargin < 6
    [V S U] = svd(A', 0);
end

%%
%% Compute the fourier coefficients
%%
fc = U' * b;
if length(thresh) == 1
    svd_thresh = U' * ones(size(b)) * thresh;
else
    svd_thresh = U' * thresh;
end
idxZero = abs(fc) < abs(svd_thresh);
clf
plot(fc, 'b');
fc(idxZero) = 0;
hold on
plot(fc, 'g')
plot(svd_thresh,'r')
xtsvd = V * (diag(S).^-1 .* fc);
nnz = sum(~idxZero)