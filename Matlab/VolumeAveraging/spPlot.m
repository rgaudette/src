%spPlot  Spectral plot
%
%   hLines = spPlot(freq, value, flgInverse)
%
%   freq        The upper value of each frequency band.  This will be averaged
%               with the lower value (previous band upper value) to generate
%               the x axis.
%
%   value       The value of each frequency band
%
%   flgInverse  Invert the direction of the X-axis for spatial resolution
%               plots (default: 0);
%
%   flgSpatial  Plot the value versus the spatial resolution (default: 1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/10/24 21:55:49 $
%
%  $Revision: 1.9 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hLines = spPlot(freq, value, flgInverse, flgSpatial, flgColor)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: spPlot.m,v 1.9 2005/10/24 21:55:49 rickg Exp $\n');
end

% Get middle of the frequency band
freq = freq(:)';
freq = mean([0 freq(1:end-1) 
  freq]);

if nargin < 3
  flgInverse = 0;
end
if nargin < 4
  flgSpatial = 1;
end


if nargin < 5
  flgColor = 0;
end

if flgSpatial
  hLines = plot(1./freq, value);
  hLabel = xlabel('Resolution (pixels)');
else
  hLines = plot(freq, value);
  hLabel = xlabel('Frequency (cycles/sample)');
end

if flgInverse
  set(gca, 'xdir', 'reverse');
end
grid on
  
vecStyle = {'-', ':', '--', '-.'};
markerStyle = {'+' 'o' '*' '.' 'x' 'square' 'diamond' 'v' '^' '>' '<' ...
    'pentagram' 'hexagram' };
nLines = length(hLines);
for iLine = 1:nLines
  set(hLines(iLine), 'LineWidth', 2);
  set(hLines(iLine), 'Marker', ...
    markerStyle{ceil(iLine / length(vecStyle))});
  if ~ flgColor
    set(hLines(iLine), 'LineStyle', ...
      vecStyle{mod(iLine-1, length(vecStyle)) + 1});
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: spPlot.m,v $
%  Revision 1.9  2005/10/24 21:55:49  rickg
%  Added CVS header
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
