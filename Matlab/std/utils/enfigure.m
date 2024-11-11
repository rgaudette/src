%enfigure        Set the current figure parameters for the given size
%
%  enfigure(width, height)
%
%  width         The image width in inches.
%
%  height        The image width in inches.

function enfigure(varargin)
if nargin == 1
  width = varargin{1}(1);
  height = varargin{1}(2);
else
  width = varargin{1};
  height = varargin{2};
end

set(gcf, 'PaperPosition', [0 0 width height]);
pos = get(gcf, 'Position');
currentDPI = get(0, 'ScreenPixelsPerInch');
pos(3) = width * currentDPI;
pos(4) = height * currentDPI;

set(gcf, 'Position', pos);



