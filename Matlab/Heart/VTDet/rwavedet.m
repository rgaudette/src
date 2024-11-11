%RWAVEDET       Detect the R wave present in an electrogram structure.
%
%   idxRwave = rwavedet(EGStruct, QRSWidth, flgDebug)
%
%   idxRwave    The indicies of the detected R waves.
%
%   EGStruct    The electrogram structure to analyze.
%
%   QRSWidth    [OPTIONAL] The QRS complex width in seconds to use in the search
%               for independent peaks (default: 0.180 seconds).
%
%   flgDebug    [OPTIONAL] Plot the clipped difference and detected beats in
%               the electrogram in figures 1 and 2 respectively (default: 0).
%
%
%   Calls: peaksrch.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:01 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rwavedet.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:01  rickg
%  Matlab Source
%
%  Revision 1.1  1997/11/10 20:45:26  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [idxRwave] = meanbeat(EGStruct, QRSWidth, flgDebug)

%%
%%  Default QRS complex width is a 180 ms.
%%
if nargin < 3
    flgDebug = 0;
    if nargin < 2;
        QRSWidth = 0.180;
    end
end

    
%%
%%  Static parameters
%%
Thresh = 0.1;
nSampQRS = ceil(QRSWidth / 2 * EGStruct.FSamp);

%%
%%  Compute the first difference to roughly detect the QRS region, 
%%  then find the local maxima in the low clipped first difference sequence
%%
dc_dt = diff(EGStruct.Seq);
DCpeak = max(dc_dt);
ClippedDiff = clip(dc_dt, Thresh * DCpeak);
[val idxRwave] = peaksrch(ClippedDiff, 0);

%%
%%  DEBUG: plot clipped first difference sequence
%%
if flgDebug
    figure(1); clf;
    plot(ClippedDiff)
    title('Clipped First Difference');
end

%%
%%  Find the global maxima within the regions centered on the first
%%  difference local maxima
%%
nPeaks = length(idxRwave);
Peaks = zeros(nPeaks, 1);
for iPeak = 1:nPeaks
    %%
    %%  Compute the bounded region for this local maximum
    %%
    iMin = max(idxRwave(iPeak) - nSampQRS, 1);
    iMax = min(idxRwave(iPeak) + nSampQRS, length(EGStruct.Seq));
    
    %%
    %%  Find the maximum of the electrogram for this region, place its 
    %%  index in the peaks array.
    %%
    [val idx] = max(EGStruct.Seq(iMin:iMax));
    Peaks(iPeak) = idx + iMin - 1;
end

%%
%%  Local maxima of the first difference function no due to the R wave ...
%%  rising edge should produce redundant peaks, remove them.
%%
idxRwave = unique(Peaks)';

%%
%%  DEBUG:  Plot the electrogram sequence and the detected R waves
%%
if flgDebug
    figure(2)
    plot(EGStruct.Seq);
    minCh = min(EGStruct.Seq);
    maxCh = max(EGStruct.Seq);
    hold on
   
    plot([idxRwave; idxRwave], [repmat(minCh, 1, length(idxRwave)); ...
            repmat(maxCh, 1, length(idxRwave))], 'r');
    hold off
end

