%WT_CMAP        Plot a Wavelet transform colormap.
%
%   wt_cmap(x, Approx, Detail, EdgesflgZeroApp)
%
%   x	        The sequence to be tranformed (this function assumes x is a 
%               column vector).
%
%   Approx      The "Approximation" filter or scaling function coefficients.
%
%   Detail      The "Detail" filter or wavelet function coefficients.
%
%   Edges       [Optional] Edge handling. A string ['zero'|'mirror'|'period']
%               describing the processing to perform on the edges of the
%               sequences at each scale (default: 'zero').
%
%   flgZeroApp  [Optional] Sets the final approximation coefficient(s) to zero.

function wtcmap(x, Approx, Detail, Edges, flgZeroApprox)

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
    [wt map] = recwt(x, rev(Approx), rev(Detail));

elseif strcmp(Edges, 'mirror'),
    [wt map] = recwtm(x, rev(Approx), rev(Detail));

elseif strcmp(Edges, 'period'),
    [wt map] = recwtp(x, rev(Approx), rev(Detail));
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
%wi = wi';
[n m] = size(wi);

surf(abs(wi));
shading flat
%axis([0 n 1 m 0 max(max(abs(wi)))]);
%view([-135 30])
grid
colormap(jet)
cbar('vert')

