%TSVD_PERF      Compute the error performance of the TSVD alg over trunc parm.
%   [TrueErr, MeanAbsErr, PkAbsErr, Resid] = tsvd_perf(A, b, x, Uecon, Secon, ...
%                                                      Vecon)

function [TrueErr, MeanAbsErr, PkAbsErr, Resid] = tsvd_perf(A, b, x, Uecon, Secon, Vecon)
[nr nc] = size(A);
TrueErr = zeros(nr, 1);
Resid = zeros(nr, 1);
Xnorm = norm(x);
MeanAbsErr = zeros(nr, 1);
PkAbsErr = zeros(nr, 1);

if nargin < 6
    [xhat Uecon Secon Vecon] = fattsvd(A, b, 1);
else
    xhat = fattsvd(A, b, 1, Uecon, Secon, Vecon);
end

Resid(1) = norm(A * xhat - b);
TrueErr(1) = norm(xhat - x) / Xnorm;
MeanAbsErr(1) = mean(abs(xhat - x));
PkAbsErr(1) = max(abs(xhat - x));

for iIter = 2:nr

    [xhat] = fattsvd(A, b, iIter, Uecon, Secon, Vecon);

    Resid(iIter) = norm(A * xhat - b);
    TrueErr(iIter) = norm(xhat - x) / Xnorm;
    MeanAbsErr(iIter) = mean(abs(xhat - x));
    PkAbsErr(iIter) = max(abs(xhat - x));
end
