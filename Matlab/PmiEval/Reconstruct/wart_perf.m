%WART_PERF
%
%  [WTrueErr, WResid, TrueErr, Resid] = wart_perf(A, x, nIter, vSNR)
%
%  Compute the true error and residual for a range of SNRs using weighted and
%  non weighted approaches since noise STD is dependent on the measured signal
%  level.

function [WTrueErr, WResid, TrueErr, Resid, TeClean, ResidClean] = wart_perf(A, x, nIter, vSNR)

[nr nc ] = size(A);
nSNR = length(vSNR);

WTrueErr = zeros(length(vSNR), 1);
WResid = zeros(length(vSNR), 1);
TrueErr = zeros(length(vSNR), 1);
Resid = zeros(length(vSNR), 1);

b_true = A * x;
nMeas = length(b_true);
NoiseSTD = zeros(nMeas, 1);
xo = zeros(size(x));

%%
%%  Compute no noise perf
%%
xhat_clean = art(A, b_true, xo, nIter);
TeClean = norm(xhat_clean - x);
ResidClean= norm(A * xhat_clean - b_true);


%%
%%  Loop over the the various SNR values
%%
for iSNR = 1:nSNR

    for iMeas = 1:nMeas
        NoiseSTD(iMeas)  = abs(b_true(iMeas)) * (10 ^ (-1 * vSNR(iSNR) / 20));
    end
    Noise = randn(nMeas, 1) .* NoiseSTD;
    b_noise = b_true + Noise;
    fprintf('Max scattered ratio noise std %e\n', max(NoiseSTD));
    fprintf('Min scattered noise std %e\n\n', min(NoiseSTD));

    %%
    %%  Compute the unweighted estimate
    %%
    [xhat] = art(A, b_noise, xo, nIter);
    Resid(iSNR) = norm(A * xhat - b_noise);
    TrueErr(iSNR) = norm(xhat - x);
    
    %%
    %%  Compute the weighted estimate
    %%
    w = NoiseSTD .^ -1;
    A_w = diag(w) * A;
    b_noise_w = w .* b_noise;
    [xhat_w] = art(A_w, b_noise_w, xo, nIter);
    WResid(iSNR) = norm(A * xhat_w - b_noise);
    WTrueErr(iSNR) = norm(xhat_w - x);
end

