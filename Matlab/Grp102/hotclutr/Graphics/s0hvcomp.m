%%
%%    Input variables
%%        PlotAz
%%        TitleBase
 
%%
%%    Initialization 
%%
clf
set(gca, 'Position', [0.2 0.2 0.6 0.6]);

%%
%%    Load & plot mean sigma0 vertical response
%%
load('MMtn4FreqPCW13V')
idx = find(vMeanAz > PlotAz - 2.5 & vMeanAz < PlotAz + 2.5);
hVert = plot(matRange(:,idx(1)+1)/1000, db(mMeanSigma0(:,idx)), 'r');
set(hVert, 'LineWidth', 2);
hold on
axis([0 100 -70 -10]);
grid

%%
%%    Load & plot mean sigma0 horizontal response
%%
load('MMtn4FreqPCW13H')
idx = find(vMeanAz > PlotAz - 2.5 & vMeanAz < PlotAz + 2.5);
hHorz = plot(matRange(:,idx(1)+1)/1000, db(mMeanSigma0(:,idx)), 'b');
set(hHorz, 'LineWidth', 2);

hNoise = plot(matRange(:,idx(1)+1)/1000, db(matNoiseFlr(:,idx(1)+1)), '--w');
set(hNoise, 'LineWidth', 2);

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

ylabel('AMPLITUDE (dB)')
hYLabel = get(gca, 'ylabel');
set(hYLabel, 'FontSize', 16);
set(hYLabel, 'FontWeight', 'bold');
set(hYLabel, 'VerticalAlignment', 'bottom')


%%
%%    Generate the legend
%%
legXStart = 42;
legXWidth = 8;
legYStart = -14;
legYStep = -3;

%%
%%    Plot lines for legend
%%
hlegl1 = plot([legXStart legXStart + legXWidth], [legYStart legYStart], 'r');
hlegl2 = plot([legXStart legXStart+legXWidth], ...
    [legYStart+legYStep legYStart+legYStep], 'b');
hlegl3 = plot([legXStart legXStart+legXWidth], ...
    [legYStart+2*legYStep legYStart+2*legYStep], '--w');

set(hlegl1,'LineWidth', 2);
set(hlegl2,'LineWidth', 2);
set(hlegl3,'LineWidth', 2);

legxtst = legXStart+legXWidth + 2;

hlegt1 = text(legxtst, legYStart, 'Vertical Polarization');
set(hlegt1, 'FontWeight', 'bold');

hlegt2 = text(legxtst, legYStart+legYStep, 'Horizontal Polarization');
set(hlegt2, 'FontWeight', 'bold');

hlegt3 = text(legxtst, legYStart+2*legYStep, 'Noise Floor');
set(hlegt3, 'FontWeight', 'bold');

%%
%%    Place title as text object in new axes.
%%
OldAxes = gca;
hTitleAxes = axes('Position', [0 0.85 1 0.1]);
set(hTitleAxes, 'Visible', 'off');
hNewTitle = text(0.525, 0, TitleBase);
set(hNewTitle, 'HorizontalAlignment', 'center');
set(hNewTitle, 'VerticalAlignment', 'bottom');
set(hNewTitle, 'FontSize', 20);
set(hNewTitle, 'FontWeight', 'bold')

XSigma = 0.25;
YSigma = -.03;
hSigma = text(XSigma, YSigma, 's');
set(hSigma, 'HorizontalAlignment', 'center');
set(hSigma, 'VerticalAlignment', 'bottom');
set(hSigma, 'FontSize', 22);
set(hSigma, 'FontWeight', 'bold')
set(hSigma, 'FontName', 'symbol')

hNaught = text(XSigma + 0.01, YSigma + 0.43, 'o');
set(hNaught, 'FontSize', 14);
set(hNaught, 'FontWeight', 'bold')
