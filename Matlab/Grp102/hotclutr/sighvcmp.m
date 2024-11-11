clf
plot(matRange(:,index+1)/1000, db(mMeanSigma0V(:,index)), 'r');
hold on
plot(matRange(:,index+1)/1000, db(mMeanSigma0H(:,index)), '--b');
plot(matRange(:,index+1)/1000, db(matNoiseFlr(:,index+1)), '-.g');
xlabel('RADIAL RANGE (KILOMETERS)')
ylabel('AMPLITUDE (dB)')
grid
axis([0 200 -70 -10])
title(['Sigma0: Socorro Peak, 13 uSec PCW, 4 Freq Mean, Az: ' ...
    int2str(mean(Azimuth(:,index+1)))]);
plot([122 135], [-14 -14], 'r')
text(136, -14, 'Vertical Polarization')
plot([122 135], [-17 -17], 'b')
text(136, -17, 'Horizontal Polarization')
mkvg1
hold off