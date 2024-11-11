%WT_SPLT        Plot a Wavelet transform scale representation.
%
%   wt_splt(x, hApp, Detail, Edges, Scales)
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

function wt_splt(x, hApp, Detail, Edges, Scales)

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
%%  Draw a colormap in the current figure.
%%
wi = wimage(wt, map);
[nscale nWTPts] = size(wi);

if nargin > 4,
    nscale = length(Scales);
else
    Scales = 1:nscale;
end

%%
%% Plot the original signal on the first row
%%
subplot(nscale+1, 1, 1);
plot(0:length(x)-1, x);
set(gca, 'XLim', [0 nWTPts*2-2]);
ylabel('Orig.');
grid on

%%
%%  Plot the requested detail sequences in order below the original signal
%%
xIndex = [0:nWTPts-1] * 2;
peak = max(max(wi));
bot = min(min(wi));
for i = 1:nscale,
    subplot(nscale+1,1, Scales(i)+1);
    plot(xIndex, wi(i,:));
    ylabel(['Scale:' int2str(Scales(i))]);
    axis([0 length(x) bot peak]);
    grid on;
end
xlabel('Time')
