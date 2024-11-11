%TRECOV4M       Estimate the recovery time of a number of ECG leads.
%
%   [idxRecov Peaks Regions Decomp] = trecov4m(Leads, nDecomp, nWindow,
%                                              ScaleStop)
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
%   nWindow     [OPTIONAL] The number of elements in the median filter window.
%
%   ScaleStop   [OPTIONAL] The finest scale to examine (default: 2).
%
%
%        TRECOV4M uses Mallat's wavelet deomposition algorithm and works up
%   from coarser resoltions to finer to close-in on the recovery time 
%   (max dv/dt) near the peak of the T-wave.  This routine add a median
%   filter to the algorithm used in trecov3. Each lead is median filtered
%   using the window defined by nWindow before the processing with the Mallat
%   decomposition.  Additionally the local maxima for the coarsest scale are
%   thresholded by a scaled by estimate of the the noise std.
%
%    Calls: mallat, peaksrch, medfilt

function [idxRecov, Peaks, Regions, Decomp] = ...
    trecov4m(Leads, nDecomp, nWindow, ScaleStop)

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
idxRecov = zeros(nLeads, 1);
Peaks = zeros(1,nDecomp);
Regions = zeros(2,nDecomp-1);

for iLead = 1:nLeads,

    %%
    %%  Decompose the lead using Mallat's wavelet algorithm with median
    %%  filtering.
    %%
    Seq = medfilt(Leads(iLead, :), nWindow);
    Seq = Seq(1:nSamples-nWindow);
    Decomp = mallat(Seq', nDecomp);

    %%
    %%  Find the last local maxima in the fifth level decomposition.
    %%  
    %%

    [val idxMax] = peaksrch(Decomp(:, nDecomp));
    vThresh = 0.5  * std(Leads(iLead, nSamples-20:nSamples));
    idxThresh = find(val > vThresh);
    idxMax = idxMax(idxThresh);

    %%
    %%  Last local maximum (over the threshold) should correspond to the
    %%  rising edge of the T wave.
    %%
    idxCurrPeak = idxMax(length(idxMax));
    Peaks(nDecomp) = idxCurrPeak;
    
    %%
    %%  Loop up in scale finding the peak value within the acceptable region
    %%  defined by the previous scale.
    %%
    for iScale = nDecomp-1:-1:ScaleStop,

        %%
        %%  Compute the support of the decomposition filter for the current scale
        %%
        %%  NEED TO RECHECK DERIVATION FOR FILTER SUPPORT FROM ONE SCALE TO
        %%  ANOTHER !!!
%        nFilt = 4 * 2^(iScale - 1) + 2^iScale + 2;
        nFilt = 2 + 3 * (2^(iScale) - 1);
        idxRegion = [idxCurrPeak-floor(nFilt/2):idxCurrPeak+ceil(nFilt/2)];
        mask = idxRegion <= (nSamples-nWindow);
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

idxRecov = idxRecov + round(nWindow/2);
