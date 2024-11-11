strDate = '16-Aug-93';

time = [-825:825];

plot(time,fftshift(db(v2p(matBeamformMF(:,1)))), 'b', ...
    time, fftshift(db(v2p(matBeamformMF(:,4)))), 'r')

axis([-20 20 135  145])
xlabel('Time (uSec)')  
ylabel('Amplitude (dB)')
title([strTitle '  ' strWfm '  ' strDate '  Direct Path Power Level'])
grid on
hold on
plot([7 11], [149.3 149.3], 'b') 
text(11.5, 149.3, fnData(:,1)');
plot([7 11], [148.6 148.6], 'r') 
text(11.5, 148.6, fnData(:,4)');
tag
