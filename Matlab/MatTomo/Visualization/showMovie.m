%showMovie      Display a movie of the planes in a volume or MRCImage object
%
%   [et fps] = showMovie(volume, nCycle)
%
%   et          The total time to execute the movie
%
%   fps         The frames per second the movie was displayed at.
%
%   volume      The volume to display, either a 3D array or an MRCImage object.
%   
%
%   Bugs: need to find the best most efficient way to render the images
%         is the image oriented correctly

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:30:29 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [et fps] = showMovie(volume, nCycle)

if nargin < 2
  nCycle = 1;
end 
set(gcf, 'Renderer', 'opengl')
if isa(volume, 'double')
  nz = size(volume, 3)
  vMax = max(volume(:));
  vMin = min(volume(:));
  cidx = uint8((volume - vMin) ./ (vMax - vMin) * 255);
else
  hdr = getHeader(volume);
  vMin = hdr.minDensity;
  vMax = hdr.maxDensity;
  
  cidx = uint8((getVolume(volume, [], [], []) - vMin) ./ (vMax - vMin) * 255);
end 
hImage = image(flipud(rot90(cidx(:, :, 1))), 'EraseMode','none');
set(gca, 'ydir', 'normal');

set(gca, 'units', 'pixels')
axis('image')

st = clock;
for iCylce = 1:nCycle
  for iz = 1:10
    set(hImage, 'CData', flipud(rot90(cidx(:, :, iz))))
    drawnow
  end 
end
et = etime(clock, st);
fps = 10 * nCycle / et;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: showMovie.m,v $
%  Revision 1.3  2005/05/09 17:30:29  rickg
%  Comment updates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
