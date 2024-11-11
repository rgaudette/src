%%galt_SIG
%%
%%
clf
axes('Position', [0.18 0.6 0.7 0.27])
set(gca, 'box', 'on')

hpower = plot(D240, V240, '-r');
set(hpower, 'LineWidth', 1);
axis([0 max(D240) 1000 2500]);
hold on
grid on

set(gca, 'FontSize', 14);
set(gca, 'FontWeight', 'bold');

xlabel('RADIAL RANGE (kilometers)')
hXLabel = get(gca, 'xlabel');
set(hXLabel, 'FontSize', 14);
set(hXLabel, 'FontWeight', 'bold');
set(hXLabel, 'VerticalAlignment' , 'top')

ylabel('ALTITUDE (meters)')
hYLabel = get(gca, 'ylabel');
set(hYLabel, 'FontSize', 14);
set(hYLabel, 'FontWeight', 'bold');
set(hYLabel, 'VerticalAlignment' , 'bottom')

title(['ALTITUDE ALONG 240 DEGREE RADIAL'])

hTitle = get(gca, 'title');
set(hTitle, 'FontSize', 16);
set(hTitle, 'FontWeight', 'bold');

%%
%%    Bottom Plot
%%
axes('Position', [0.18 0.20 0.7 0.27])
set(gca, 'box', 'on')

hSigma = plot(R2/1000, db(abs(Sigma0)), '-r');
set(hSigma, 'LineWidth', 1);
axis([0 max(D240) -80 0])  
grid

hold on

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

title(['     :  AIRCRAFT, RSTER AZ=240'])
hTitle = get(gca, 'title');
set(hTitle, 'FontSize', 16);
set(hTitle, 'FontWeight', 'bold');
xSymbolStart = 42;
ySymbolStart = 10;
htext = text(xSymbolStart, ySymbolStart, 's');
set(htext, 'FontSize', 18)
set(htext, 'FontWeight', 'bold')
set(htext, 'FontName', 'symbol')
hnaught = text(xSymbolStart + 2.7, ySymbolStart + 2,'o');


drwlogo
