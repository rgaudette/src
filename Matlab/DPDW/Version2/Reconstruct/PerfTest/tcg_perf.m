
function [TrueErr, MeanAbsErr, PkAbsErr, Resid] = tcg_perf(A, b, x, nIter)

[nr nc] = size(A);
if nargin < 4
    nIter = nr + 10;
end

TrueErr = zeros(nr+10, 1);
Resid = zeros(nr+10, 1);
MeanAbsErr = zeros(nr+10, 1);
PkAbsErr = zeros(nr+10, 1);
Xnorm = norm(x);

x_o = zeros(size(b));
NormalEq = A * A';

for iIter = 1:(nr+10)
    z = tcg(NormalEq, b, x_o, iIter);
    xhat = A' * z;
    
    Resid(iIter) = norm(A * xhat - b);
    TrueErr(iIter) = norm(xhat - x) / Xnorm;
    MeanAbsErr(iIter) = mean(abs(xhat - x));
    PkAbsErr(iIter) = max(abs(xhat - x));
end
