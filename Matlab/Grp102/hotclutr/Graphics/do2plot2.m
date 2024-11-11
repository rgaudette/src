%%
%%    index code 6: 200    14: 240
%%
index = 6;
clg
axes('Position', [0.18 0.6 0.7 0.27])
set(gca, 'box', 'on')

hpower = plot(dRange/1000, db(v2p(matBeamformMF(:,index))) - db(DirPath), ...
    '-r');
set(hpower, 'LineWidth', 1);
axis([0 200 -120 -40]);
hold on
grid on

hnoise = plot(dRange/1000, db(NoisePow) - db(DirPath) * ones(1651,1), '--w');
set(hnoise, 'LineWidth', 2)

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

title('POWER RELATIVE TO DIRECT PATH SIGNAL:  SOCORRO PEAK, AZ=240')
hTitle = get(gca, 'title');
set(hTitle, 'FontSize', 16);
set(hTitle, 'FontWeight', 'bold');

%%
%%    Bottom Plot
%%
axes('Position', [0.18 0.20 0.7 0.27])
set(gca, 'box', 'on')

hpower = plot(matRange(:,index)/1000, ...
    db(v2p(matBeamformMF(:,index))) - db(DirPath), '-r');
set(hpower, 'LineWidth', 1);
axis([0 200 -120 -40])  
grid

hold on
hnoise = plot(dRange/1000, db(NoisePow) - db(DirPath) * ones(1651,1), '--w');
set(hnoise, 'LineWidth', 2)

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


