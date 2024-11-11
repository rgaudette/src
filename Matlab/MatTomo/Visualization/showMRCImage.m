%showMRCImage   Display a MRC Image in the correct orientation
%
%  showMRCImage(im, xvalue, yvalue)
%
%  im             The MRC Image slice to display
%
%  xvalue         OPTIONAL: The values of the x and y pixels repsectively
%  yvalue         (default: 1:nElements for each dimension)
%
%  showMRCImage performs a rot90 then a flipud on the image data to orient it
%  correctly in an MATLAB graphics window.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:30:29 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function showMRCImage(im, xvalue, yvalue)

[nX nY] = size(im);

if nargin < 3
  yvalue = 1:nY;
end

if nargin < 2
  xvalue = 1:nX;
end

%  Columns and rows need to be reversed,  MATLAB represents an
%  image as a  matrix with rows indexed the fastest.  MRC images
%  are stored in raster form
set(gcf, 'Renderer', 'openGL')
imagesc(xvalue, yvalue, flipud(rot90(im)))
set(gca, 'ydir', 'normal');
axis('image')
xlabel('X axis');
ylabel('Y axis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: showMRCImage.m,v $
%  Revision 1.4  2005/05/09 17:30:29  rickg
%  Comment updates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%