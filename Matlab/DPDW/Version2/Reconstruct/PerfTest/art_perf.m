
function [TrueErr, MeanAbsErr, PkAbsErr, Resid] = art_perf(A, b, x, nIter)
[nr nc ] = size(A);
TrueErr = zeros(nIter, 1);
Xnorm = norm(x);
MeanAbsErr = zeros(nIter, 1);
PkAbsErr = zeros(nIter, 1);
Resid = zeros(nIter, 1);
old_xhat = zeros(size(x));
for iIter = 1:nIter
%    xhat = art(A, b, old_xhat, 1, rem(iIter-1, nr) + 1);
    xhat = art(A, b, old_xhat, nr);
    Resid(iIter) = norm(A * xhat - b);
    TrueErr(iIter) = norm(xhat - x) / Xnorm;
    MeanAbsErr(iIter) = mean(abs(xhat - x));
    PkAbsErr(iIter) = max(abs(xhat - x));
    old_xhat = xhat;
end
