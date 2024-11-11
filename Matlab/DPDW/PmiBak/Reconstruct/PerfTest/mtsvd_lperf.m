
function [TrueErr, MeanAbsErr, PkAbsErr, Resid] = mtsvd_lperf(A, b, x, nSV, ...
    Op, vLambda, U, S, V)
nLambda = length(vLambda);
TrueErr = zeros(nLambda, 1);
Resid = zeros(nLambda, 1);
Xnorm = norm(x);
MeanAbsErr = zeros(nLambda, 1);
PkAbsErr = zeros(nLambda, 1);

if nargin < 9
    [xhat xtsvd xns U S V] = fatmtsvd(A, b, nSV, Op, vLambda(1));
else
    [xhat xtsvd xns] = fatmtsvd(A, b, nSV, Op, vLambda(1), U, S, V);
end

Resid(1) = norm(A * xhat - b);
TrueErr(1) = norm(xhat - x) / Xnorm;
MeanAbsErr(1) = mean(abs(xhat - x));
PkAbsErr(1) = max(abs(xhat - x));

for iIter = 2:nLambda
    xhat = xtsvd - vLambda(iIter) * xns;

    Resid(iIter) = norm(A * xhat - b);
    TrueErr(iIter) = norm(xhat - x) / Xnorm;
    MeanAbsErr(iIter) = mean(abs(xhat - x));
    PkAbsErr(iIter) = max(abs(xhat - x));
end
