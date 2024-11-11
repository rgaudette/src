%WT_CMAP        Plot a Wavelet transform colormap.
%
%   wt_cmap(x, hApp, hDet, EdgesflgZeroApp)
%
%   x	        The sequence to be tranformed (this function assumes x is a 
%               column vector).
%
%   hApp        The "Approximation" filter impulse response as row vector.
%
%   hDet        The "Detail" filter impulse response as row vector, in reverse
%               order.
%
%   Edges       [Optional] Edge handling. A string ['zero'|'mirror'|'period']
%               describing the processing to perform on the edges of the
%               sequences at each scale (default: 'zero').
%
%   flgZeroApp  [Optional] Sets the final approximation coefficient(s) to zero.

function wtcmap(x, hApp, hDet, Edges, flgZeroApprox)

if nargin < 5,
    flgZeroApprox = 0;
    if nargin < 4,
        Edges = 'zero';
    end
end

%%
%%  Compute the wavelet transform of the signal reversing the filters, using
%%  the appropriate edge processing.
%%
if strcmp(Edges, 'zero'),
    [wt map] = recwt(x, hApp, hDet);

elseif strcmp(Edges, 'mirror'),
    [wt map] = recwtm(x, hApp, hDet);

elseif strcmp(Edges, 'period'),
    [wt map] = recwtp(x, hApp, hDet);
else
    error('Unknown edge processing selection.');
end

if flgZeroApprox
    nwt = length(wt);
    idxApp = [(nwt - map(length(map)) + 1) : nwt];
    wt(idxApp) = zeros(size(idxApp))';
end

%%
%%  Draw a colormap in the current figure.
%%
wi = wimage(wt, map);

hi = imagesc(abs(wi));
colormap(jet)
colorbar('vert')

