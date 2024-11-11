clg
axes('Position', [0.18 0.6 0.7 0.27])
set(gca, 'box', 'on')

hpower = plot(matRange(:,2)/1000, 20*log10(abs(MfoutAz(:,2)))-DirPathdB, '-r');
axis([0 200 -120 -40]);
hold on
grid on

hnoise = plot(matRange(:,2), (NoisedB - DirPathdB) * ones(1651,1), '--w');
set(hnoise, 'LineWidth', 2)

xlabel('Range (kilometers)')
hlabel = get(gca, 'xlabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'top')

ylabel('Amplitude (dB)')
hlabel = get(gca, 'ylabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'bottom')

title('Received Power (Az: 240 Degrees, Socorro Peak)')
hlabel = get(gca, 'title');
set(hlabel, 'FontSize', 16);

%set(gca, 'Clipping', 'off');

hleg1 = plot([150 160], [-46 -46], '-r');
text(163, -46.5, 'Received Power')

hleg1 = plot([150 160], [-52 -52], '--w');
set(hleg1, 'LineWidth', 2)
text(163, -52.5, 'Noise Floor')



%%
%%    Bottom Plot
%%
axes('Position', [0.18 0.15 0.7 0.27])
set(gca, 'box', 'on')

hsig = plot(matRange(:,2)/1000, 10*log10(abs(matSigma0(:,2))), '-R');
axis([0 200 -80 -0])  

xlabel('Range (kilometers)')
hlabel = get(gca, 'xlabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'top')

ylabel('Amplitude (dB)')
hlabel = get(gca, 'ylabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'bottom')

title('   (Az: 240 Degrees, Socorro Peak)')            
hlabel = get(gca, 'title');
set(hlabel, 'FontSize', 16);

hold on
grid on

hgamma = plot(matRange(:,2)/1000, 10*log10(abs(Gamma(:,2))), '-b');
  

hnoisebot = plot(matRange(:,2)/1000, 10*log10(abs(matNoiseFlr(:,2))), '--w');
set(hnoisebot, 'LineWidth', 2)

htext = text(43.5, 10, 's , g');
set(htext, 'FontSize', 16)
set(htext, 'FontName', 'symbol')
set(htext, 'position', [43.5 10])


hnaught = text(46,6,'o');
set(hnaught, 'position', [46 7])

LegStart = 98;
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
