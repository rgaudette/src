clg
axes('Position', [0.18 0.6 0.7 0.27])
set(gca, 'box', 'on')

%%
%%    Plot M Mountain Sigma-naught
%%
hsig = plot(matRange(:,2)/1000, 10*log10(abs(matSigma0(:,2))), '-R');
axis([0 200 -80 -0])  
grid on
hold on

%%
%%    Plot Aircraft sigma-naught
%%
hsig = plot(range_plot, sigma0_plot, '-B');

%%
%%    Label plot
%%
xlabel('Range (kilometers)')
hlabel = get(gca, 'xlabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'top')

ylabel('Amplitude (dB)')
hlabel = get(gca, 'ylabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'bottom')

title('   Socorro Peak / Aircraft')            
hlabel = get(gca, 'title');
set(hlabel, 'FontSize', 16);

htext = text(63, 10, 's');
set(htext, 'FontSize', 16)
set(htext, 'FontName', 'symbol')

hnaught = text(65.5,7,'o');

%%
%%    Legend for plot
%%
startTextLeg = -6;
hleg1 = plot([150 160], [ startTextLeg startTextLeg ], '-r');
text(163, startTextLeg-0.5, 'Socorro Peak')

hleg1 = plot([150 160], [startTextLeg-6 startTextLeg-6], '-b');
%set(hleg1, 'LineWidth', 2)
text(163, startTextLeg-6.5, 'Aircraft')





%%
%%    Bottom Plot
%%
axes('Position', [0.18 0.15 0.7 0.27])
set(gca, 'box', 'on')

%%
%%    Gamma for M Mountain
%%
hgammaG = plot(matRange(:,2)/1000, 10*log10(abs(Gamma(:,2))), '-r');
axis([0 200 -80 0])  
hold on
grid on

%%
%%    Gamma for the aircraft
%%
hgammaA = plot(range_plot, gamma_plot, '-b');

%%
%%    Axis labels
%%
xlabel('Range (kilometers)')
hlabel = get(gca, 'xlabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'top')

ylabel('Amplitude (dB)')
hlabel = get(gca, 'ylabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'bottom')

title('   Socorro Peak / Aircraft')            
hlabel = get(gca, 'title');
set(hlabel, 'FontSize', 16);

htext = text(65, 10, 'g');
set(htext, 'FontSize', 16)
set(htext, 'FontName', 'symbol')

%%
%%    Legend
%%
LegStartX = 150;
LegStartY = -58
hleg1 = plot([LegStartX LegStartX+10], [LegStartY LegStartY], '-r');
ht = text(LegStartX+13, LegStartY-0.5, 'Socorro Peak');

hleg1 = plot([LegStartX LegStartX+10], [LegStartY-6 LegStartY-6], '-b');
ht = text(LegStartX+13, LegStartY-6.5, 'Aircraft');

