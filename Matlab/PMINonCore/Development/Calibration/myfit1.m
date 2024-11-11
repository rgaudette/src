%MYFIT1         Compute the background properties of a PMI data structure
%
%   [mu_sp, mu_a] = myfit(pmi, vInit)
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

function [mu_sp, mu_a] = myfit1(pmi, vInit)

nMeas = size(pmi.PhiTotal, 2);
if nargin > 1
    nInit = size(vInit, 2);
else
    nInit = 1;
    vInit = [10 0.04];
end

mu_sp = zeros(nMeas, nInit);
mu_a = zeros(nMeas, nInit);

%%
%%  Estimate the optical parameters for each measurement
%%
for iMeas = 1:nMeas
    FF0 = reshape(pmi.PhiTotal(:, iMeas), 16, 9)';

    %%
    %%  Generate an estimate for each initial vector
    %%
    for iInit = 1:nInit
        temp = fmins('cali', vInit(iInit, :), [], [], FF0)
        mu_sp(iMeas, iInit) = temp(1);
        mu_a(iMeas, iInit) = temp(2);
    end
end
