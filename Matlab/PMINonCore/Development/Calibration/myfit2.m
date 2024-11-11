%MYFIT2         Compute the background properties of a PMI data structure
%
%   [mu_sp, mu_a] = myfit(pmi, vInit, lstSrcGood, lstDetGood)
%
%   mu_sp       The estimates of mu_sp.  This is a matrix whose columns are
%               indexed by the number of initial vector and whose rows are
%               indexed by the number of measurements in the PhiTotal field of
%               pmi.
%
%   mu_a        The estimates of mu_a in the same format as mu_sp.
%
%   pmi         The PMI data structure containing the total field measurements
%               in PhiTotal.
%
%   vInit       The matrix of initial vectors, each supplies an initial starting
%               point for the non-linear simplex algorithm in fmins.
%
%   lstSrcGood  OPTIONAL: List of good sources (default: all).
%
%   lstDetGood  OPTIONAL: List of good detectors (default: all).

function [mu_sp, mu_a] = myfit2(pmi, vInit, lstSrcGood, lstDetGood)
nD = 16;
nS = 9;
nMeas = size(pmi.PhiTotal, 2);
if nargin > 1
    nInit = size(vInit, 1);
else
    nInit = 1;
    vInit = [10 0.04];
end
if nargin < 4
    lstDetGood = [1:nD]
else
    lstDetGood = lstDetGood(:)';
end
if nargin < 3
    lstSrcGood = [1: nS]'
else
    lstSrcGood = lstSrcGood(:);
end

mu_sp = zeros(nMeas, nInit);
mu_a = zeros(nMeas, nInit);

%%
%%  Estimate the optical parameters for each measurement
%%
for iMeas = 1:nMeas
    FF0 = reshape(pmi.PhiTotal(:, iMeas), nD, nS)';

    %%
    %%  Generate an estimate for each initial vector
    %%
    for iInit = 1:nInit
        temp = fmins('cali2', vInit(iInit, :), [], [], FF0, lstSrcGood, lstDetGood)
        mu_sp(iMeas, iInit) = temp(1);
        mu_a(iMeas, iInit) = temp(2);
    end
end
