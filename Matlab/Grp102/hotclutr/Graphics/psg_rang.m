%%PSG_RANG        Plot power, sigma & gamma vs radial range.
%%
%%
clf
axes('Position', [0.18 0.6 0.7 0.27])
set(gca, 'box', 'on')

hpower = plot(Range/1000, db(v2p(BeamformMF)) - db(DirPath), '-r');
set(hpower, 'LineWidth', 1);
axis([0 200 -120 -40]);
hold on
grid on

hnoise = plot(dRange/1000, db(NoisePow) - db(DirPath) * ones(1651,1), '--w');
set(hnoise, 'LineWidth', 2)

set(gca, 'FontSize', 14);
set(gca, 'FontWeight', 'bold');

xlabel('RADIAL RANGE (kilometers)')
hXLabel = get(gca, 'xlabel');
set(hXLabel, 'FontSize', 14);
set(hXLabel, 'FontWeight', 'bold');
set(hXLabel, 'VerticalAlignment' , 'top')

ylabel('AMPLITUDE (dB)')
hYLabel = get(gca, 'ylabel');
set(hYLabel, 'FontSize', 14);
set(hYLabel, 'FontWeight', 'bold');
set(hYLabel, 'VerticalAlignment' , 'bottom')

title(['POWER RELATIVE TO DIRECT PATH SIGNAL:  SOCORRO PEAK, AZ=' ...
    int2str(Azimuth(1))])
hTitle = get(gca, 'title');
set(hTitle, 'FontSize', 16);
set(hTitle, 'FontWeight', 'bold');

%%
%%    Bottom Plot
%%
axes('Position', [0.18 0.20 0.7 0.27])
set(gca, 'box', 'on')

hSigma = plot(Range/1000, db(abs(Sigma0)), '-r');
set(hSigma, 'LineWidth', 1);
axis([0 200 -60 20])  
grid

hold on
hGamma = plot(Range/1000, db(real(Gamma)), '-b');
set(hGamma, 'LineWidth', 1);

hnoise = plot(Range/1000, db(NoiseFlr), '--w');
set(hnoise, 'LineWidth', 2)

set(gca, 'FontSize', 14);
set(gca, 'FontWeight', 'bold');

xlabel('RADIAL RANGE (kilometers)')
hlabel = get(gca, 'xlabel');
set(hlabel, 'FontSize', 14);
set(hlabel, 'FontWeight', 'bold');
set(hlabel, 'VerticalAlignment' , 'top')

ylabel('AMPLITUDE (dB)')
hlabel = get(gca, 'ylabel');
set(hlabel, 'FontSize', 14);
set(hlabel, 'FontWeight', 'bold');
set(hlabel, 'VerticalAlignment' , 'bottom')

title(['     :  SOCORRO PEAK, AZ=' int2str(Azimuth(1))]);
hTitle = get(gca, 'title');
set(hTitle, 'FontSize', 16);
set(hTitle, 'FontWeight', 'bold');
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
xLegStart = 100;
yLegStart = 14;
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
