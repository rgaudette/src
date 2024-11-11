clg
load sig0_240
axes('Position', [0.18 0.6 0.7 0.27])
set(gca, 'box', 'on')

hpower = plot(range_plot, rd_pwr0_plot, '-r');
axis([0 200 -210 -130]);
hold on
grid on

hnoise = plot(range_plot, bg_pwr0_plot, '--w');
set(hnoise, 'LineWidth', 2)

xlabel('Range (kilometers)')
hlabel = get(gca, 'xlabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'top')

ylabel('Amplitude (dB)')
hlabel = get(gca, 'ylabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'bottom')

title('Received Power (Az: 240 Degrees, Aircraft)')
hlabel = get(gca, 'title');
set(hlabel, 'FontSize', 16);

%set(gca, 'Clipping', 'off');
startTextLeg = -143;
hleg1 = plot([150 160], [ startTextLeg startTextLeg ], '-r');
text(163, startTextLeg-0.5, 'Received Power')

hleg1 = plot([150 160], [startTextLeg-6 startTextLeg-6], '--w');
set(hleg1, 'LineWidth', 2)
text(163, startTextLeg-6.5, 'Noise Floor')

%%
%%    Bottom Plot
%%
axes('Position', [0.18 0.15 0.7 0.27])
set(gca, 'box', 'on')

hsig = plot(range_plot, sigma0_plot, '-R');
axis([0 200 -80 0])  

xlabel('Range (kilometers)')
hlabel = get(gca, 'xlabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'top')

ylabel('Amplitude (dB)')
hlabel = get(gca, 'ylabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'bottom')

title('   (Az: 240 Degrees, Aircraft)')            
hlabel = get(gca, 'title');
set(hlabel, 'FontSize', 16);

hold on
grid on

hgamma = plot(range_plot, gamma_plot, '-b');
  

hnoisebot = plot(range_plot, bg_sigma0_plot, '--w');
set(hnoisebot, 'LineWidth', 2)

htext = text(48.5, 10, 's , g');
set(htext, 'FontSize', 16)
set(htext, 'FontName', 'symbol')
set(htext, 'position', [48.5 10])


hnaught = text(51,6,'o');
set(hnaught, 'position', [51 7])

LegStart = 150;
hleg1 = plot([LegStart LegStart+10], [-6 -6], '-r');
ht = text(LegStart+13, -6.5, 's');
set(ht, 'FontName', 'symbol');
get(ht, 'position')

hnaught = text(LegStart+15,-6.5,'o');
set(hnaught, 'position', [LegStart+15 -8])

hleg1 = plot([LegStart LegStart+10], [-12 -12], '-b');
ht = text(LegStart+13, -12.3, 'g');
set(ht, 'FontName', 'symbol');

hleg1 = plot([LegStart LegStart+10], [-18 -18], '--w');
set(hleg1, 'LineWidth', 2);
text(LegStart+13, -18.5, 'Noise Floor');
