%fitImage       Fit the figure and axes dimensions to the current image
%
%  fitImage(scale)
%
%  scale        The number of scale factor of image pixels to screen pixels
%               (default: 1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:30:29 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fitImage(scale)

if nargin < 1
  scale = 1;
end

% Get the units to reset it them at the end of the function
figUnits = get(gcf, 'units');
axesUnits = get(gca, 'units');
set(gca, 'DataAspectRatioMode', 'manual');
set(gca, 'PlotBoxAspectRatioMode', 'manual');

% Get the current figure position, the current axes, and axis dimensions
set(gcf, 'units', 'pixels');
set(gca, 'units', 'pixels')
figPosition = get(gcf, 'position');
axesPosition = get(gca, 'position');
axisSize = axis;

% Calculate the new axes size
nAxesPixelsX = (axisSize(2) - axisSize(1)) * scale;
nAxesPixelsY = (axisSize(4) - axisSize(3)) * scale;
newAxesPosition = axesPosition;
newAxesPosition(3) = nAxesPixelsX;
newAxesPosition(4) = nAxesPixelsY;

% Calculate the new figure window size and set it, keeping the upper left
% corner of the window stationary
nFigPixelsY = 2 * axesPosition(2) + nAxesPixelsY;
windLocY = figPosition(2) + figPosition(4);
figPosition(2) = windLocY - nFigPixelsY;
figPosition(3) = 2 * axesPosition(1) + nAxesPixelsX;
figPosition(4) = nFigPixelsY;

% Need to set figure properties before the axis properties
set(gcf, 'position', figPosition);
set(gca, 'position', newAxesPosition);
%set(gcf, 'units', figUnits);
%set(gca, 'units', axesUnits);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: fitImage.m,v $
%  Revision 1.2  2005/05/09 17:30:29  rickg
%  Comment updates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%