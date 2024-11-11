clf
plot(Az, db(AP0), 'w')
grid
axis([180 360 -80 0])
hold on
plot(Az, db(AP10), 'r')
plot(Az, db(AP15), 'g')
plot(Az, db(AP20), 'b')
xlabel('AZIMUTH (degrees)')
ylabel('AMPLITUDE (dB)')
xlstart = 200;
xlstop = 220;
xltstart = 223;
ylstart = -8;
ylstep = -3;
hl1 = plot([xlstart xlstop], [ylstart ylstart], 'w');
hLeg1 = text(xltstart, ylstart, 'All Range Gates');
set(hLeg1, 'FontSize', 12);
set(hLeg1, 'FontWeight', 'bold');

hl2 = plot([xlstart xlstop], [ylstart+ylstep ylstart+ylstep], 'r');
hLeg2 = text(xltstart, ylstart+ylstep, 'Range Gates > 10 km')
set(hLeg2, 'FontSize', 12);
set(hLeg2, 'FontWeight', 'bold');

hl3 = plot([xlstart xlstop], [ylstart+2*ylstep ylstart+2*ylstep], 'g');
hLeg3 = text(xltstart, ylstart+2*ylstep, 'Range Gates > 15 km')
set(hLeg3, 'FontSize', 12);
set(hLeg3, 'FontWeight', 'bold');

hl4 = plot([xlstart xlstop], [ylstart+3*ylstep ylstart+3*ylstep], 'b');
hLeg4 = text(xltstart, ylstart+3*ylstep, 'Range Gates > 20 km')
set(hLeg4, 'FontSize', 12);
set(hLeg4, 'FontWeight', 'bold');

mkvg1

ht1 = text(0.5, 20, 'EFFECTIVE RSTER SIDELOBE LEVELS DUE TO BISTATIC');
set(ht1, 'position', [0.5 .5])
set(ht1, 'FontWeight' , 'bold')
set(ht1, 'FontSize' , 20)
set(ht1, 'HorizontalAlignment', 'center')
ht2 = text(0.5, 0, 'JAMMING, SOCORRO PEAK, V-POLARIZATION, 435 MHz');
set(ht2, 'HorizontalAlignment', 'center')
set(ht2, 'FontSize' , 20)
set(ht2, 'FontWeight' , 'bold')
