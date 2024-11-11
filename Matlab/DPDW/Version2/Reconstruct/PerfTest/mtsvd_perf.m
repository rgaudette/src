
function [TrueErr, MeanAbsErr, PkAbsErr, Resid, LaplX] = mtsvd_perf(A, b, x, vSV, vLambda, U, S, V)

nLambda = length(vLambda);
nSV = length(vSV);
Xnorm = norm(x(:));
TrueErr = zeros(nLambda, nSV);
Resid = zeros(nLambda, nSV);
LaplX = zeros(nLambda, nSV);
MeanAbsErr = zeros(nLambda, nSV);
PkAbsErr = zeros(nLambda, nSV);

[nX nY nZ] = size(x);
x = x(:);
Op = lapl3d(nX, nY, nZ);

for iSV = 1:length(vSV)
    [te, mea, pea, resid] = mtsvd_lperf(A, b, x, vSV(iSV), ...
        Op, vLambda, U, S, V);
    TrueErr(:,iSV) = te;
    MeanAbsErr(:,iSV) = mea;
    PkAbsErr(:,iSV) = pea;
    Resid(:,iSV) = resid;
end
