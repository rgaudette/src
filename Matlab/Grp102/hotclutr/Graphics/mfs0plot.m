%%MFS0PLOT          Multiple-frequency sigma0 plotting routine.
%%
%%    Input variables
%%        Polarization
%%        PlotAz
%%        TitleBase
 
%%
%%    Initialization 
%%
clf
set(gca, 'Position', [0.2 0.2 0.6 0.6]);

%%
%%    Load 434.8 Response
%%
load(['MMtn4348PCW13' Polarization])

%%
%%    Find correct azimuth data
%%
vAz = mean(Azimuth);
idx = find(vAz > PlotAz - 2.5 & vAz < PlotAz + 2.5);

%%
%%    Plot sigma0 response for this frequency
%%
hLine1 = plot(matRange(:,idx(1))/1000, db(matSigma0(:,idx(1))), 'r');
set(hLine1, 'LineWidth', 1);
hold on
axis([0 100 -70 -10]);
grid


%%
%%    Load & plot 435.0 MHz response
%%
load(['MMtn4350PCW13' Polarization])
vAz = mean(Azimuth);
idx = find(vAz > PlotAz - 2.5 & vAz < PlotAz + 2.5);
hLine2 = plot(matRange(:,idx(1))/1000, db(matSigma0(:,idx(1))), 'b');
set(hLine2, 'LineWidth', 1);


%%
%%    Load & plot 435.2 MHz response
%%
load(['MMtn4352PCW13' Polarization])
vAz = mean(Azimuth);
idx = find(vAz > PlotAz - 2.5 & vAz < PlotAz + 2.5);
hLine3 = plot(matRange(:,idx(1))/1000, db(matSigma0(:,idx(1))), 'g');
set(hLine3, 'LineWidth', 1);

%%
%%    Load & plot 435.4 MHz response
%%
load(['MMtn4354PCW13' Polarization])
vAz = mean(Azimuth);
idx = find(vAz > PlotAz - 2.5 & vAz < PlotAz + 2.5);
hLine4 = plot(matRange(:,idx(1))/1000, db(matSigma0(:,idx(1))), 'c');
set(hLine4, 'LineWidth', 1);

%%
%%    Load & plot Mean Sigma0 response
%%
load(['MMtn4FreqPCW13' Polarization])
idx2 = find(vMeanAz > PlotAz - 2.5 & vMeanAz < PlotAz + 2.5);
hMean = plot(matRange(:,idx(1))/1000, db(mMeanSigma0(:,idx2)), 'w');
set(hMean, 'LineWidth', 2);

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
legXStart = 72;
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
    [legYStart+2*legYStep legYStart+2*legYStep], 'g');
hlegl4 = plot([legXStart legXStart+legXWidth], ...
    [legYStart+3*legYStep legYStart+3*legYStep], 'c');
hlegl5 = plot([legXStart legXStart+legXWidth], ...
    [legYStart+4*legYStep legYStart+4*legYStep], 'w');
set(hlegl1,'LineWidth', 1);
set(hlegl2,'LineWidth', 1);
set(hlegl3,'LineWidth', 1);
set(hlegl4,'LineWidth', 1);
set(hlegl5,'LineWidth', 2);

legxtst = legXStart+legXWidth + 2;

hlegt1 = text(legxtst, legYStart, '434.8 MHz');
set(hlegt1, 'FontWeight', 'bold');

hlegt2 = text(legxtst, legYStart+legYStep, '435.0 MHz');
set(hlegt2, 'FontWeight', 'bold');

hlegt3 = text(legxtst, legYStart+2*legYStep, '435.2 MHz');
set(hlegt3, 'FontWeight', 'bold');

hlegt4 = text(legxtst, legYStart+3*legYStep, '435.4 MHz');
set(hlegt4, 'FontWeight', 'bold');

hlegt5 = text(legxtst, legYStart+4*legYStep, '4 Freq. Mean');
set(hlegt5, 'FontWeight', 'bold');

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

hSigma = text(0.22, -.03, 's');
set(hSigma, 'HorizontalAlignment', 'center');
set(hSigma, 'VerticalAlignment', 'bottom');
set(hSigma, 'FontSize', 22);
set(hSigma, 'FontWeight', 'bold')
set(hSigma, 'FontName', 'symbol')

hNaught = text(0.23, 0.4, 'o');
set(hNaught, 'FontSize', 14);
set(hNaught, 'FontWeight', 'bold')






