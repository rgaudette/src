%%
%%    Input variables:
%%
%%        PlotAz
%%

%%
%%    Default values
%%
strTitle1 = [': Temporal Stability'];
strTitle2 = 'Socorro Peak, 435.2 MHz, Vertical Polarization, Az:240';
LineWidth = 2;

%%
%%    Initialization
%%
clf
hAxes = axes('Position', [0.2 0.17 0.6 0.6]);

%%
%%    Find indicies of azimuth of interest.
%%
idxAzimuth = find((Azimuth(1,:) > (PlotAz - 2.5)) & ...
             (Azimuth(1,:) < (PlotAz + 2.5)));

%%
%%    Plot all of the matched filter output powers
%%    (relative to the direct path).
%%
hLineVec = plot(matRange(:,idxAzimuth)/1000, db(matSigma0(:,idxAzimuth)));
set(hLineVec, 'LineWidth', LineWidth);
set(hLineVec(1), 'Color', 'r');
set(hLineVec(2), 'Color', 'b');
set(hLineVec(3), 'Color', 'g');

axis([0 100 -70 -10])
grid
hold on

%%
%%    Correct font for axes labels
%%
set(gca,  'FontSize', 12);
set(gca,  'FontWeight', 'bold');

%%
%%    Label X & Y axes
%%
xlabel('RADIAL RANGE (kilometers)')
hXLabel = get(gca, 'xlabel');
set(hXLabel, 'FontSize', 16);
set(hXLabel, 'FontWeight', 'bold');
set(hXLabel, 'VerticalAlignment', 'top')

ylabel('Amplitude (dB)')
hYLabel = get(gca, 'ylabel');
set(hYLabel, 'FontSize', 16);
set(hYLabel, 'FontWeight', 'bold');
set(hYLabel, 'VerticalAlignment', 'bottom')


%%
%%    Create legend
%%
xLegStart = 42;
xLegWidth = 8;
yLegStart = -14;
yLegStep = -3;
xTextOffset = 2;
hL1 = plot([xLegStart xLegStart+xLegWidth], [yLegStart yLegStart], 'r');
set(hL1, 'LineWidth', LineWidth);
hT1 = text(xLegStart + xLegWidth + xTextOffset, yLegStart, 'T = 0');
set(hT1, 'FontWeight', 'bold');

hL2 = plot([xLegStart xLegStart+xLegWidth], ...
    [yLegStart+yLegStep yLegStart+yLegStep], 'b');
set(hL2, 'LineWidth', LineWidth);
hT2 = text(xLegStart + xLegWidth + xTextOffset, yLegStart + yLegStep, ...
    ['T = ' num2str(etime(matCPITime(idxAzimuth(2),:), ...
    matCPITime(idxAzimuth(1),:)) / 60) ' mins']);
set(hT2, 'FontWeight', 'bold');

hL3 = plot([xLegStart xLegStart+xLegWidth], ...
    [yLegStart+2*yLegStep yLegStart+2*yLegStep], 'g');
set(hL3, 'LineWidth', LineWidth);
hT3 = text(xLegStart + xLegWidth + xTextOffset, yLegStart + 2 * yLegStep, ...
    ['T = ' num2str(etime(matCPITime(idxAzimuth(3),:), ...
    matCPITime(idxAzimuth(1),:)) / 60) ' mins']);
set(hT3, 'FontWeight', 'bold');

%%
%%    Place title as text object in new axes.
%%
OldAxes = gca;
hTitle1Axes = axes('Position', [0 0.85 1 0.1]);
set(hTitle1Axes, 'Visible', 'off');
hTitle1 = text(0.525, 0, strTitle1);
set(hTitle1, 'HorizontalAlignment', 'center');
set(hTitle1, 'VerticalAlignment', 'bottom');
set(hTitle1, 'FontSize', 20);
set(hTitle1, 'FontWeight', 'bold')

SigmaXStart = 0.38;
hSigma = text(SigmaXStart, -.03, 's');
set(hSigma, 'HorizontalAlignment', 'center');
set(hSigma, 'VerticalAlignment', 'bottom');
set(hSigma, 'FontSize', 22);
set(hSigma, 'FontWeight', 'bold')
set(hSigma, 'FontName', 'symbol')

hNaught = text(SigmaXStart+0.01, 0.4, 'o');
set(hNaught, 'FontSize', 14);
set(hNaught, 'FontWeight', 'bold')

hTitle2Axes = axes('Position', [0 0.80 1 0.1]);
set(hTitle2Axes, 'Visible', 'off');
hTitle2 = text(0.5, 0, strTitle2);
set(hTitle2, 'HorizontalAlignment', 'center');
set(hTitle2, 'VerticalAlignment', 'bottom');
set(hTitle2, 'FontSize', 18);
set(hTitle2, 'FontWeight', 'bold')
