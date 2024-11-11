%WT_STAT        Compute some statistics of a the WT coefficicients.
%
%   [meanWc minWc maxWc EpeakWc powerWc VarRatio] = ...
%        wt_stat(x, hApp, Detail, Edges, Scales)
%
%   x	        The sequence to be transformed.
%
%   hApp        The approximation filter impulse response.
%
%   hDet        The detail filter impulse response.
%
%   Edges       [Optional] Edge handling. A string ['zero'|'mirror'|'period']
%               describing the processing to perform on the edges of the
%               sequences at each scale (default: 'zero').
%
%   Scales      [OPTIONAL] The scales to inlcude in the display.  The
%               default is all scales.

function [meanWc, minWc, maxWc, EpeakWc, powerWc, VarRatio] = ...
    wt_stat(x, hApp, Detail, Edges, Scales)

if nargin < 4,
    Edges = 'zero';
end

%%
%%  Compute the wavelet transform of the signal reversing the filters, using
%%  the appropriate edge processing.
%%
if strcmp(Edges, 'zero'),
    [wt map] = dwtz(x, hApp, Detail);

elseif strcmp(Edges, 'mirror'),
    [wt map] = recwtm(x, rev(hApp), rev(Detail));

elseif strcmp(Edges, 'period'),
    [wt map] = dwtp(x, hApp, Detail);

else
    error('Unknown edge processing selection.');
end


%%
%%  Compute the mean, min and max, peak energy and power in each scale
%%
fprintf('Seqeunce    mean         min        max        peak NRG     power     Var Ratio\n');
fprintf('=============================================================================\n');
fprintf('Orig.     %+4.2e  %+4.2e  %+4.2e  %+4.2e  %+4.2e  +%4.2e\n', ...
    mean(x), min(x), max(x),max(x.^2), mean(x.^2), 1.0);

SigVar = std(x) ^2;

nScale = length(map);
Start = [1; cumsum(map(1:nScale-1))+1];
Stop = cumsum(map);

meanWc = zeros(nScale, 1);
minWc = zeros(nScale, 1);
maxWc = zeros(nScale, 1);
EpeakWc = zeros(nScale, 1);
powerWc = zeros(nScale, 1);
VarRatio = zeros(nScale, 1);

for i =1:nScale
    meanWc(i) = mean(wt(Start(i):Stop(i)));
    minWc(i) =  min(wt(Start(i):Stop(i)));
    maxWc(i) =  max(wt(Start(i):Stop(i)));
    EpeakWc(i) =  max(wt(Start(i):Stop(i)).^2);
    powerWc(i) = mean(wt(Start(i):Stop(i)).^2);
    VarRatio(i) =  std(wt(Start(i):Stop(i))) ./ SigVar;
    fprintf('Scale #%d  %+4.2e  %+4.2e  %+4.2e  %+4.2e  %+4.2e  %+4.2e\n', i, ...
        meanWc(i), minWc(i), maxWc(i), EpeakWc(i), powerWc(i), VarRatio(i) );
end
