%TACTIV3M       Estimate the activation time of a number of ECG leads.
%
%   [idxActiv Peaks Regions Decomp] = ...
%   tactiv3(Leads, nDecomp, nWindow, ScaleStop)
%
%   idxActiv    The estimated activation time index for each lead.
%
%   Regions     The search for used for each scale, this is defined by the
%               peak of the next finer scale and the support of the
%               decomposition filters at the finer scale.
%
%   Leads       The ECG sequence(s).  If ECGData is multiple leads, each row
%               should represent a different lead, each column a differenent
%               time instant.
%
%   Decomp      Returns the detail sequences from the Mallat decomposition.
%               This is useful along with Regions and Peaks for diagnostic
%               purposes.  See trecperf.
%
%   nDecomp     [OPTIONAL] The number of decompositions to perform.
%               (default: 5)
%
%   nWindow     [OPTIONAL] The number of elements in the median filter window.
%
%   ScaleStop   [OPTIONAL] The finest scale to examine (default: 2).
%
%
%        TACTIV3M uses Mallat's wavelet deomposition algorithm and works up
%   from coarser resoltions to finer to close-in on the activation time
%   (min dv/dt).  This routine adds a median filter to the algorithm used in
%   tactiv3. Each lead is median filtered using the window defined by
%   nWindow before the processing with the Mallat decomposition.
%
%    Calls: mallat, peaksrch, medfilt

function [idxActiv, Peaks, Regions, Decomp] = ...
    tactiv3m(Leads, nDecomp, nWindow, ScaleStop)

%%
%%  Initializations
%%
if nargin < 4,
    ScaleStop = 2;
    if nargin < 3
        nWindow = 5;
        if nargin < 2,
            nDecomp = 5;
        end
    end
end

[nLeads nSamples] = size(Leads);
idxActiv = zeros(nLeads, 1);
Peaks = zeros(1,nDecomp);
Regions = zeros(2,nDecomp-1);

for iLead = 1:nLeads,

    %%
    %%  Decompose the lead using Mallat's wavelet algorithm
    %%
    Seq = medfilt(Leads(iLead, :), nWindow);
    Seq = Seq(1:nSamples-nWindow);
    Decomp = mallat(Seq', nDecomp);

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
    for iScale = nDecomp-1:-1:ScaleStop

        %%
        %%  Extract data from current scale
        %%
        nRegion = 4 * ((2^iScale - 1) + (2^(iScale - 1) - 1)) + 3;
        idxRegion = [idxCurrPeak-floor(nRegion/2):idxCurrPeak+ceil(nRegion/2)];
        Regions(:, iScale) = ...
            [idxCurrPeak-floor(nRegion/2) idxCurrPeak+ceil(nRegion/2)]';
        Region = Decomp(idxRegion, iScale);
        [Val idxLocalMax] = min(Region);
        idxCurrPeak = idxRegion(1) + idxLocalMax - 1;
        Peaks(iScale) = idxCurrPeak;
    end
    idxActiv(iLead) = idxCurrPeak;
end

idxActiv = idxActiv + floor(nWindow/2);
