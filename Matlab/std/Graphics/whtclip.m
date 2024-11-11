%WHTCLIP		Whiten the bottom portion of current figures colormap.
%
%	whtclip(Percentage)
%
%   Percentage  The percetage of the colormap to whiten.
%
%       WHTCLIP sets the specified lower portion of the colormap to white.
%   This can used as clipping (or filtering operation) on colormaps and images.

function whtclip(pct)
pct = pct / 100;
GCF = gcf;
CMap = get(GCF, 'colormap');
[n m] = size(CMap);
idxTop = round(pct * n);
CMap(1:idxTop, :) = ones(idxTop, 3);
set(GCF, 'colormap', CMap);

