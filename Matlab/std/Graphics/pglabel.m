%PGLABEL        Label a page at the bottom.
%
%   h = pglabel('string')
%
%   Note: The paper orientation should be set before calling this function for
%         accurate placement of the label.
function h = pglabel(string)
OldGCA = gca;
Orientation = get(gcf, 'PaperOrientation')
if strcmp(Orientation, 'portrait'),
    hAx = axes('position', [.13 .0 .7750 .05]);
else
    hAx = axes('position', [.13 .055 .7750 .05]);
end
set(hAx, 'visible', 'off');
h = text(0.5, 0, string);
set(h, 'HorizontalAlignment', 'Center');
set(h, 'VerticalAlignment', 'BaseLine')

set(gcf, 'CurrentAxes', OldGCA);
