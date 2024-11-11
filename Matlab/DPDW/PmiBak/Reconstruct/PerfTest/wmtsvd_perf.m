%WMTSVD_PERF
%   [TrueErr, MeanAbsErr, PkAbsErr, Resid, SemiNorm, xbest, xb_tsvd] = ...
%       wmtsvd_perf(A, b, x, nX, nY, nZ, nSV, Lambda)
function [TrueErr, MeanAbsErr, PkAbsErr, Resid, SemiNorm, xbest, xb_tsvd] = ...
    wmtsvd_perf(A, b, x, L, nSV, Lambda)

%%
%%  Initializations
%%
[nr nc ] = size(A);
x = x(:);
Xnorm = norm(x);

%%
%%  Preallocate the error matrices
%%
TrueErr = zeros(length(Lambda), length(nSV));
MeanAbsErr = zeros(length(Lambda), length(nSV));
PkAbsErr = zeros(length(Lambda), length(nSV));
Resid = zeros(length(Lambda), length(nSV));
SemiNorm = zeros(length(Lambda), length(nSV));

minTrueError = 1e300;
for iSV = 1:length(nSV)

    %%
    %%  Compute the MTSVD soln for the first value of lambda
    %%
    if iSV == 1
        [xhat xtsvd xns U S V] = fatmtsvd(A, b, nSV(1), L, Lambda(1));
    else
        [xhat xtsvd xns U S V] = fatmtsvd(A, b, nSV(iSV), L, Lambda(1), ...
            U, S, V);
    end
    
    %%
    %%  Loop over values of lambda to compute the range of errors.
    %%
    for iLambda = 1:length(Lambda)
        xhat = xtsvd - Lambda(iLambda) * xns;
        Resid(iLambda, iSV) = norm(A * xhat - b);
        TrueErr(iLambda, iSV) = norm(xhat - x) ./ Xnorm;
        SemiNorm(iLambda, iSV) = norm(L * xhat);
        abs_error = abs(xhat - x);
        MeanAbsErr(iLambda, iSV) = mean(abs_error);
        PkAbsErr(iLambda, iSV) = mean(abs_error);

        %%
        %%  Save the minimum true error reconstruction
        %%
        if TrueErr(iLambda, iSV) < minTrueError
            xbest = xhat;
            xb_tsvd = xtsvd;
            minTrueError = TrueErr(iLambda, iSV);
        end
    end
end
