%PCOLORB
function pcolorb(XVal, YVal, ZVal, CAxis)

if nargin < 4,
    CAxis = [min(ZVal) max(ZVal)];
end

%%
%%    Generate legend on side of plot
%%
hold off
clg
axes('position', [.88 .17 .03 .6])
axis([0 1 min(CAxis) max(CAxis)])
caxis(CAxis);
vecLegend = linspace(min(CAxis), max(CAxis), length(colormap))';
pcolor([0 1], vecLegend, [vecLegend vecLegend]);
set(gca, 'XTickLabels', ' ');
shading('flat')

%%
%%    Plotting area for map.
%% 
axes('position', [.17 .17 .6 .6])
set(gca, 'Box', 'on')
caxis(CAxis);
hold on
pcolor(XVal, YVal, ZVal);
shading('flat')
hold off
