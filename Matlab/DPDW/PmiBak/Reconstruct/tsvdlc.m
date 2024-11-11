%TSVDLC         Compute the L-curve for a TSVD solution.
%
%   [resid xnorm] = tsvdlc(b, U, S, V, vNSV)

function [resid, xnorm, errtrue] = tsvdlc(A, b, U, S, V, vSV, xtrue)
nSV = length(vSV);
resid = zeros(nSV, 1);
xnorm = zeros(nSV, 1);
if nargin > 6
    errtrue = zeros(nSV, 1);
end

for iSV = 1:nSV
    r = vSV(iSV);
    xhat = V(:,1:r)* (diag(S(1:r,1:r)).^-1 .* ((U(:,1:r))' * b));
    resid(iSV) = norm(A * xhat - b);
    xnorm(iSV) = norm(xhat);
    if nargin > 6
        errtrue(iSV) = norm(xtrue - xhat);
    end
end


