%TPEAK          Find the peak t-wave value and time in a set of ECG leads.
%
%   [Peaks idxPeaks] = tpeak(Leads, tRecov)
%
%   Peaks       The peak value of the t-wave for each lead.
%
%   idxPeaks    The indices of the t-wave peak value.
%
%   Leads       The ECG leads, rows are leads, columns are sample instants.
%
%   tRecov      [OPTIONAL] Recovery time estimates for each lead, if not
%               present they will be estiameted using trecov3.
%
%   CALLS: trecov3

function [Peaks, idxPeaks] = tpeak(Leads, tRecov)

%%
%%  Initializations
%%
[nLeads nSamples] = size(Leads);
Peaks = zeros(nLeads,1);
idxPeaks = zeros(nLeads,1);

if nargin < 2,
    %%
    %%  Estimate the activation time
    %%
    [tRecov] = trecov3(Leads);
end

for iLead = 1:nLeads,
    [Peaks(iLead) idxPeaks(iLead)] = max(Leads(iLead,[tRecov(iLead):nSamples]));
    idxPeaks(iLead) = idxPeaks(iLead) + tRecov(iLead) - 1;
end