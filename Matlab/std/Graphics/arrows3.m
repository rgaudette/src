%ARROWS3        Display a 3D function of a 2D using arrows.
%
%   This function is incomplete?

function h = arrows3(fX, fY, fZ)

%%
%%
%%  Get the dimension of the functions
%%
[nJ nK] = size(fX);

%%
%%  Generate a model arrow
%%  - top row is horizontal coordinates
%%  - bottom row is vertical coordinates
%%  - columns is the number of points in the patch
%%
KModel = [-0.5 0.5 -0.5]';
JModel = [-0.25 0   0.25]';
IModel = [-0.25 0.5 -0.25]';

nModPoints = size(KModel);

%%
%%  Compute the angles & magnitudes of each element of the function
%%
PlaneAngles = angle(fX + j * fY);
Mags = sqrt(fX.^2 + fY.^2 + fZ.^2);
fXNorm = fX ./ Mags;
fYNorm = fY ./ Mags;
fZNorm = fZ ./ Mags;

%%
%%  Rotate an image of each arrow according to the phase at each sample point
%%
%%  - the rational operator is reversed becuse the ydir propert is reversed
%%
kArrow = KModel * fXNorm(:)' + JModel * fYNorm(:)' + IModel * fZNorm(:)';
jArrow = JModel * fXNorm(:)' + (-1)*KModel * fYNorm(:)' + IModel * fZNorm(:)';
iArrow = IModel * fXNorm(:)' + JModel * fYNorm(:)' + IModel * fZNorm(:)';

%%
%%  Offset each arrow according to its sample position
%%
[kPos jPos] = meshgrid([1:nJ], [1:nK]);
kPos = ones(nModPoints, 1) * kPos(:)';
jPos = ones(nModPoints, 1) * jPos(:)';

%%
%%    Quantize the amplitudes to the avaialable colors
%%
CMap = colormap;
[nColors junk] = size(CMap);
MagMax = matmax(Mags);
MagMin = matmin(Mags);

%%
%%  Draw patches
%%
if MagMin < MagMax
    set(gca, 'clim', [MagMin MagMax]);
else
    set(gca, 'clim', [MagMax-(1E-10) MagMax]);
end

set(gca, 'ydir', 'reverse');
h = patch(kPos + kArrow, jPos + jArrow, iArrow, Mags(:)');
