%TRECOV2        Estimate the recovery time of a number of ECG leads.
%
%   [idxRecov idxTWave] = trecov2(Leads)
%
%       TRECOV2 uses Mallat's wavelet deomposition algorithm to first find the
%   peak of the t-wave and then working back from there identify the first
%   local maxima of the derivative (local maxima of 3rd detail decomposition).

function [idxRecov, idxTWave] = trecov2(Leads)

%%
%%  Initializations
%%
nDecomp = 5;
[nLeads nSamples] = size(Leads);
idxRecov = zeros(nLeads, 1);
idxTWave = zeros(nLeads, 1);

for iLead = 1:nLeads,

    %%
    %%  Decompose the lead using Mallat's wavelet algorithm
    %%
    Decomp = mallat(Leads(iLead, :), 5);

    %%
    %%  Find the last positive->negative zero crossing in the fourth detail
    %%  decomposition.
    %%
    Positive = Decomp(:,4) >= 0.0;
    Crossings = diff(Positive);
    PosToNeg = find(Crossings == -1);
    idxTWave(iLead) = PosToNeg(length(PosToNeg));

    %%
    %%  Working back from the t-wave time find the first local maxmima of the
    %%  of the third decomposition level.
    %%
    [val idx] = peaksrch(Decomp(:,3));

    idxRecov(iLead) = idx(max(find(idx < idxTWave(iLead))));

end

