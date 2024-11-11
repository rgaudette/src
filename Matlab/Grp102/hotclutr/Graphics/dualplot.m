%DUALPLOT          Generic dual plotting algorithm for viewgraphs
%
%       This routine draws a a pair of plots on the screen.  The upper
%   has two curves, the bootom has three and a legend.  The values below
%   provide what is to be plotted.  All of the lines and text are thickened
%   to be appropriate for a viewgraph.


%%
%%    Values to be plotted
%%
XTopCurve1 = R2 / 1000;
Peak = max(max(v2p(bfrd_norm)));
YTopCurve1 = db(max(v2p(bfrd_norm.'))) - db(Peak);
XTopCurve2 = R2 / 1000;
YTopCurve2 = db(NoisePow) - db(Peak) * ones(1651,1);

XBottomCurve1 = R2 / 1000;
YBottomCurve1 = db(abs(Sigma0));
XBottomCurve2 = R2 / 1000;
YBottomCurve2 = db(abs(Gamma));
XBottomCurve3 = R2 / 1000;
YBottomCurve3 = db(NoiseFlr);

%%
%%    Set up the top axes area, increase font size and weight
%%
clf

hTopAxes = axes('Position', [0.18 0.6 0.7 0.27]);
set(hTopAxes, 'box', 'on')

%%
%%    Plot curve # 1 on top axes
%%
hTopCurve1 = plot(XTopCurve1, YTopCurve1, 'r');

%%
%%    Increase line width of curve #1, change axis and ad grid.
%%
set(hTopCurve1, 'LineWidth', 1);
axis([0 200 -60 20]);
grid on

hold on

%%
%%    Plot curve # 2 on top axes
%%
hTopCurve2 = plot(XTopCurve2, YTopCurve2, '--w');

%%
%%    set line width for top curve # 2
%%
set(hTopCurve2, 'LineWidth', 2)

%%
%%    Setup axis fonts
%%
set(hTopAxes, 'FontSize', 14);
set(hTopAxes, 'FontWeight', 'bold');

%%
%%    Label x axis of graph
%%
xlabel('RADIAL RANGE (kilometers)')
hTopXLabel = get(hTopAxes, 'xlabel');
set(hTopXLabel, 'FontSize', 14);
set(hTopXLabel, 'FontWeight', 'bold');
set(hTopXLabel, 'VerticalAlignment' , 'top')

%%
%%    Label y axis of graph
%%
ylabel('AMPLITUDE (dB)')
hTopYLabel = get(hTopAxes, 'ylabel');
set(hTopYLabel, 'FontSize', 14);
set(hTopYLabel, 'FontWeight', 'bold');
set(hTopYLabel, 'VerticalAlignment' , 'bottom')

%%
%%    Title graph
%%
title(['NORMALIZED POWER:  AIRCRAFT, AZ=' int2str(azxmit(1))])
hTopTitle = get(hTopAxes, 'title');
set(hTopTitle, 'FontSize', 16);
set(hTopTitle, 'FontWeight', 'bold');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%    Bottom Plot
%%
hBottomAxes = axes('Position', [0.18 0.20 0.7 0.27]);
set(hBottomAxes, 'box', 'on')

%%
%%    Plot curve # 1 on bottom axes
%%
hBottomCurve1 = plot(XBottomCurve1, YBottomCurve1, '-r');

%%
%%    Increase line width of curve #1, change axis and ad grid.
%%
set(hBottomCurve1, 'LineWidth', 1);
axis([0 200 -60 20])  
grid

hold on

%%
%%    Plot curve # 2 on bottom axes
%%
hBottomCurve2 = plot(XBottomCurve2, YBottomCurve2, '-b');
set(hBottomCurve2, 'LineWidth', 1);

%%
%%    Plot curve # 3 on bottom axes
%%
hBottomCurve3 = plot(XBottomCurve3, YBottomCurve3, '--w');
set(hBottomCurve3, 'LineWidth', 2)

%%
%%    Setup axis fonts
%%
set(hBottomAxes, 'FontSize', 14);
set(hBottomAxes, 'FontWeight', 'bold');

%%
%%    X Label
%%
xlabel('RADIAL RANGE (kilometers)')
hXLabelBottom = get(hBottomAxes, 'xlabel');
set(hXLabelBottom, 'FontSize', 14);
set(hXLabelBottom, 'FontWeight', 'bold');
set(hXLabelBottom, 'VerticalAlignment' , 'top')

%%
%%    Y Label
%%
ylabel('AMPLITUDE (dB)')
hYLabelBottom = get(hBottomAxes, 'ylabel');
set(hYLabelBottom, 'FontSize', 14);
set(hYLabelBottom, 'FontWeight', 'bold');
set(hYLabelBottom, 'VerticalAlignment' , 'bottom')

%%
%%    Title
%%
title(['     :  AIRCRAFT, AZ=' int2str(azxmit(1))]);
hTitle = get(hBottomAxes, 'title');
set(hTitle, 'FontSize', 16);
set(hTitle, 'FontWeight', 'bold');

%%
%%    Place sigma-naught and gamma as seperate objects in the title area
%%
xSymbolStart = 55;
ySymbolStart = 30;
htext = text(xSymbolStart, ySymbolStart, 's , g');
set(htext, 'FontSize', 18)
set(htext, 'FontWeight', 'bold')
set(htext, 'FontName', 'symbol')
hnaught = text(xSymbolStart + 3, ySymbolStart + 2,'o');


%%
%%    Legend
%%
Axis = axis;
xLegStart = Axis(1) + 0.75 * (Axis(2) - Axis(1));
yLegStart = Axis(3) + 0.90 * (Axis(4) - Axis(3));
hleg1 = plot([xLegStart xLegStart+10], [yLegStart yLegStart], '-r');
set(hleg1, 'LineWidth', 1);
ht = text(xLegStart + 13, yLegStart - 0.5, 's');
set(ht, 'FontName', 'symbol');
set(htext, 'FontSize', 14)
set(htext, 'FontWeight', 'bold')

hnaught = text(xLegStart+15.5, yLegStart + 1.5,'o');

hleg1 = plot([xLegStart xLegStart+10], [yLegStart-6 yLegStart-6], '-b');
set(hleg1, 'LineWidth', 1);
ht = text(xLegStart + 13, yLegStart - 6.3, 'g');
set(htext, 'FontSize', 14)
set(htext, 'FontWeight', 'bold')
set(ht, 'FontName', 'symbol');

hleg1 = plot([xLegStart xLegStart+10], [yLegStart-12 yLegStart-12], '--w');
set(hleg1, 'LineWidth', 2);
set(htext, 'FontSize', 14)
set(htext, 'FontWeight', 'bold')
text(xLegStart + 13, yLegStart - 12.5, 'Noise Floor');

%%
%%    Draw the Lincoln Laboratory Logo on bottom right of plot.
%%
drwlogo;