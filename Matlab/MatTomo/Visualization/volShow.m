%volShow        Display a thresholded surface rendering of a volume
%
%   volShow(volume, flgSmooth, pctThresh, flgInvert)
%
%   volume       The 3-D volume to display.
%
%   flgSmooth    OPTIONAL: Smooth the volume before rendering  (default: 0)
%
%   pctThresh    OPTIONAL: Threshold value as a ratio of the data range
%                (default: 0.75)
%
%   flgInvert    OPTIONAL: Invert the anmplitude of the data before rendering
%                (default: 1)
%
%   pixelSize    OPTIONAL: The size of the pixels.  A single value
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:30:29 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function volShow(volume, flgSmooth, pctThresh, flgInvert, pixelSize)
if nargin < 2
  flgSmooth = 0;
end
if nargin < 3
  pctThresh = 0.75;
end
if nargin < 4
  flgInvert = 1;
end

if nargin < 5
  pixelSize = 1;
end

if length(pixelSize) == 1;
  pixelSize = pixelSize * [ 1 1 1];
end

clf
% make sure the volume is in double format
if ~ isa(volume, 'double')
  volume = double(volume);
end

% Set the data range from zero to 1
% invert the volume since we are negatively stained

if flgInvert
  volume = volume - max(volume(:));
  volume = volume ./ min(volume(:));
else
  volume = volume - min(volume(:));
  volume = volume ./ max(volume(:));
end

% smooth the volume
if flgSmooth
  volume = smooth3(volume);
end

szVol = size(volume);
[Y X Z] = ndgrid([0:szVol(1)-1]*pixelSize(1), ...
                 [0:szVol(2)-1]*pixelSize(2), ...
                 [0:szVol(3)-1]*pixelSize(3));
volPatch = patch(isosurface( X, Y, Z, volume, pctThresh));
caps = patch(isocaps(X, Y, Z, volume, pctThresh), ...
             'FaceColor', 'interp', 'EdgeColor', 'none');
isonormals(X, Y, Z, volume, volPatch, 'negate');
set(volPatch, 'FaceColor', 'red', 'EdgeColor', 'none');
view(3)
daspect([1 1 1])
lighting phong
camlight headlight
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: volShow.m,v $
%  Revision 1.3  2005/05/09 17:30:29  rickg
%  Comment updates
%
%  Revision 1.2  2004/08/10 21:40:25  rickg
%  Added
%  * data normalization
%  * pixel size
%  * comments
%  * arg handling
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
