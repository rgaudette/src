%%
%%
%%
clf
axes('Position', [0.18 0.6 0.7 0.27])
set(gca, 'box', 'on')

Peak = max(max(v2p(bfrd_norm)));
hpower = plot(dRange/1000, db(max(v2p(bfrd_norm.'))) - db(Peak), '-r');
set(hpower, 'LineWidth', 1);
axis([0 200 -60 20]);
hold on
grid on

hnoise = plot(dRange/1000, db(NoisePow) - db(Peak) * ones(1651,1), '--w');
set(hnoise, 'LineWidth', 2)

set(gca, 'FontSize', 14);
set(gca, 'FontWeight', 'bold');

xlabel('BISTATIC DELTA RANGE (kilometers)')
hXLabel = get(gca, 'xlabel');
set(hXLabel, 'FontSize', 14);
set(hXLabel, 'FontWeight', 'bold');
set(hXLabel, 'VerticalAlignment' , 'top')

ylabel('AMPLITUDE (dB)')
hYLabel = get(gca, 'ylabel');
set(hYLabel, 'FontSize', 14);
set(hYLabel, 'FontWeight', 'bold');
set(hYLabel, 'VerticalAlignment' , 'bottom')

title(['NORMALIZED POWER:  AIRCRAFT, RSTER AZ=' int2str(azxmit(1))])
hTitle = get(gca, 'title');
set(hTitle, 'FontSize', 16);
set(hTitle, 'FontWeight', 'bold');

%%
%%    Bottom Plot
%%
axes('Position', [0.18 0.20 0.7 0.27])
set(gca, 'box', 'on')

hpower = plot(R2/1000, db(max(v2p(bfrd_norm.'))) - db(Peak), '-r');
set(hpower, 'LineWidth', 1);
axis([0 200 -60 20])  
grid

hold on
hnoise = plot(R2/1000, db(NoisePow) - db(Peak) * ones(1651,1), '--w');
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
drwlogo