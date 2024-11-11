%showMRCContour   Display a contour map of a single MRC Image 
%
%  showMRCContour(im, contourArgs)
%
%  im             The MRC Image slice to display
%
%  contourArgs    All remaining arguments are passed to the contour command
%
%  showMRCContour performs a rot90 then a flipud on the image data to orient it
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
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function showMRCContour(im, varargin)

%  Columns and rows need to be reversed,  MATLAB represents an
%  image as a  matrix with rows indexed the fastest.  MRC images
%  are stored in raster form
set(gcf, 'Renderer', 'openGL')
contour(flipud(rot90(im)), varargin{:})
set(gca, 'ydir', 'normal');
axis('image')
xlabel('X axis');
ylabel('Y axis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: showMRCContour.m,v $
%  Revision 1.3  2005/05/09 17:30:29  rickg
%  Comment updates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%