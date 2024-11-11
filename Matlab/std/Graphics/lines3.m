%LINES3         Display a 3D function of a 2D using arrows.
%
%   h = arrows3(fX, fY, fZ)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:05 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: lines3.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:05  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/15 22:55:25  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%%  Offset each arrow according to its sample position
%%
[kPos jPos] = meshgrid([1:nJ], [1:nK]);

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
set(gca, 'ColorOrder', [1 0 0])
xVec = [kPos(:) kPos(:)+fXNorm(:) ...
        kPos(:)+fXNorm(:)-.2 kPos(:)+fXNorm(:) kPos(:)+fXNorm(:)+.2 ]';
yVec = [jPos(:) jPos(:)+fYNorm(:) ...
        jPos(:)+fYNorm(:)+.2 jPos(:)+fYNorm(:) jPos(:)+fYNorm(:)-.2]';
zVec = [Mags(:) Mags(:)+fZNorm(:) ...
        Mags(:)+fZNorm(:) Mags(:)+fZNorm(:) Mags(:)+fZNorm(:)]';
h = plot3(xVec, yVec, zVec);
set(h, 'color', [1 0 0])
hold on
h2 = plot3(kPos(:)', jPos(:)', Mags(:)', 'o');
set(h2, 'color', [1 0 0])
%hold off


