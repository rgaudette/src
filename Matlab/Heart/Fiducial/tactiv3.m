%TACTIV3        Estimate the activation time of a number of ECG leads.
%
%    [idxActiv Peaks Regions Decomp] = tactiv3(Leads, nDecomp)
%
%    idxActiv    The estimated activation time index for each lead.
%
%    Leads       The ECG sequence(s).  If ECGData is multiple leads, each row
%                should represent a different lead, each column a differenent
%                time instant.
%
%    nDecomp     [OPTIONAL] The number of decompositions to perform.
%                (default: 5)
%
%        TACTIV3 uses Mallat's wavelet deomposition algorithm and works up from
%    coarser resoltions to finer to close-in on the activation time (min dv/dt)
%
%    Calls: mallat, peaksrch

function [idxActiv, Peaks, Regions, Decomp] = tactiv3(Leads, nDecomp)

%%
%%  Initializations
%%
if nargin < 2,
    nDecomp = 5;
end

[nLeads nSamples] = size(Leads);
idxActiv = zeros(nLeads, 1);
Peaks = zeros(1,nDecomp);
Regions = zeros(2,nDecomp-1);

for iLead = 1:nLeads,

    %%
    %%  Decompose the lead using Mallat's wavelet algorithm
    %%
    Decomp = mallat(Leads(iLead, :), nDecomp);

    %%
    %%  Find the global minimum in the fifth level decomposition.
    %%  
    %%
    [val idxCurrPeak] = min(Decomp(:,nDecomp));
    Peaks(nDecomp) = idxCurrPeak;
    
    %%
    %%  Loop up in scale finding the peak value within the acceptable region
    %%  defined by the previous scale.
    %%
    for iScale = nDecomp-1:-1:2,

        %%
        %%  Extract data from current scale
        %%
        nRegion = 4 * ((2^iScale - 1) + (2^(iScale - 1) - 1)) + 3;
        idxRegion = [idxCurrPeak-floor(nRegion/2):idxCurrPeak+ceil(nRegion/2)];
        Regions(:, iScale) = [idxCurrPeak-floor(nRegion/2) idxCurrPeak+ceil(nRegion/2)]';
        Region = Decomp(idxRegion, iScale);
        [Val idxLocalMax] = min(Region);
        idxCurrPeak = idxRegion(1) + idxLocalMax - 1;
        Peaks(iScale) = idxCurrPeak;
    end
    idxActiv(iLead) = idxCurrPeak;
end