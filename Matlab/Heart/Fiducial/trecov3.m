%TRECOV3        Estimate the recovery time of a number of ECG leads.
%
%   [idxRecov Peaks Regions Decomp] = trecov3(Leads, nDecomp, Stop)
%
%   idxRecov    The estimated recovery time index for each lead.
%
%   Peaks       The index of the peak value extracted from each search region.
%
%   Regions     The search for used for each scale, this is defined by the
%               peak of the next finer scale and the support of the
%               decomposition filters at the finer scale.
%
%   Decomp      Returns the detail sequences from the Mallat decomposition.
%               This is useful along with Regions and Peaks for daignostic
%               purposes.  See trecperf
%
%   Leads       The ECG sequence(s).  If ECGData is multiple leads, each row
%               should represent a different lead, each column a differenent
%               time instant.
%
%   nDecomp     [OPTIONAL] The number of decompositions to perform.
%               (default: 5)
%
%   ScaleStop   [OPTIONAL] The finest scale to examine (default: 2).
%
%        TRECOV3 uses Mallat's wavelet deomposition algorithm and works up
%    from coarser resoltions to finer to close-in on the recovery time
%    (max dv/dt) near the peak of the t-wave.
%
%    Calls: mallat, peaksrch, dipsrch

function [idxRecov, Peaks, Regions, Decomp] = trecov3(Leads, nDecomp, ScaleStop)

%%
%%  Initializations
%%
if nargin < 3
    ScaleStop = 2;
    if nargin < 2
        nDecomp = 5;
    end
end

[nLeads nSamples] = size(Leads);

%%
%%  Pre-allocations
%%
idxRecov = zeros(nLeads, 1);
Peaks = zeros(1,nDecomp);
Regions = zeros(2,nDecomp-1);

for iLead = 1:nLeads,

    %%
    %%  Decompose the lead using Mallat's wavelet algorithm
    %%
    Decomp = mallat(Leads(iLead, :), nDecomp);

    %%
    %%  Compute local maxima/minima in the coarsest detail sequence.
    %%  
    %%
    [val idxMax] = peaksrch(Decomp(:, nDecomp));
    [val idxMin] = dipsrch(Decomp(:, nDecomp));

    %%
    %%  Find the last local maximum that occurs earlier than the last
    %%  local minimum.  The last local minimum corresponds to the falling
    %%  edge of the T wave, the preceding maximum corresponds to the rising
    %%  edge of the T wave.
    %%
    idx = idxMax(idxMax < idxMin(length(idxMin)));
    idxCurrPeak = idx(length(idx));
    Peaks(nDecomp) = idxCurrPeak;
    
    %%
    %%  Iterate up in scale finding the peak value within the acceptable region
    %%  defined by the previous scale.
    %%
    for iScale = nDecomp-1:-1:ScaleStop,

        %%
        %%  Compute the support of the decomposition filter for the current scale
        %%
%        nFilt = 2 + 3 * (2^(iScale) - 1);
%        nFilt = 4 * 2^(iScale - 1) + 2^iScale + 2;
        nFilt = 4 * ((2^iScale - 1) + (2^(iScale - 1) - 1)) + 3;

        idxRegion = [idxCurrPeak-floor(nFilt/2):idxCurrPeak+ceil(nFilt/2)];
        mask = idxRegion <= nSamples;
        idxRegion = idxRegion(mask);
        Regions(:, iScale) = ...
            [idxCurrPeak-floor(nFilt/2) idxCurrPeak+ceil(nFilt/2)]';
        Region = Decomp(idxRegion, iScale);

        %%
        %%  Find the maximum with the region, label this as the current
        %%  estimate.
        %%
        [Val idxLocalMax] = max(Region);
        idxCurrPeak = idxRegion(1) + idxLocalMax - 1;
        Peaks(iScale) = idxCurrPeak;
    end
    idxRecov(iLead) = idxCurrPeak;
end
