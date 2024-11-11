%TWSTAT         Generate T-wave statisitics.
%
%    [idxRecov idxTpeak TPeak] = twstat(Leads)
%
%    idxRecov    The estimated recovery time index for each lead.
%
%    idxTpeak    The estimated t-wave peak index.
%
%    TPeak       The amplitude of each lead at estimated t-wave peak.
%
%    Leads       The array of lead sequences.  Each row is different lead,
%                each a different time sample.
%
%        TWSTAT computes several statistics of the t-waves within a set of
%    ECG leads.  The recovery time index, t-wave peak index and t-wave peak
%    value are estimated.  The algorithm first generates an estimate of the
%    recovery time using TRECOV3, the t-wave peak value and index are found
%    by searching forward of the recovery time index.
%
%    Calls: trecov3

function [idxRecov, idxTpeak, TPeak] = twstat(Leads)

%%
%%    Initializations
%%
[nLeads nSamples] = size(Leads);

%%
%%    Find the estimated recovery time for each lead.
%%
[idxRecov idxTtemp] = trecov3(Leads);

%%
%%    Search forward of the estimated recovery time, to find the t-wave peak.
%%
idxTpeak = zeros(nLeads, 1);
TPeak = zeros(nLeads, 1);

for idxLead = 1:nLeads,
    [TPeak(idxLead) idxTpeak(idxLead)] = max(Leads(idxLead,idxRecov:nSamples));
end