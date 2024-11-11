%LEADLBL        Label a lead array plot.
%
%   [hXText hYText hFigText] = leadlbl(XText, YText, FigText)
%
%
function [hXText, hYText, hFigText] = leadlbl(XText, YText, FigText)

%%
%%  Create an invisible axes for the Text objects
%%
hax = axes('position', [0.0 0.0 1 1]);
set(hax, 'visible', 'off')

hXText = text(0.5, 0.07, XText);

%%
%%  Y label if requested
%%
if nargin >1,
    hYText = text(0.07, 0.5, YText);
    set(hYText, 'Rotation', 90);
    set(hYText, 'HorizontalAlignment', 'center');
end

%%
%%  Right side figure label if requested
%%
if nargin >2,
    hFigText = text(0.93, 0.5, FigText);
    set(hFigText, 'Rotation', -90);
    set(hFigText, 'HorizontalAlignment', 'center');
end

