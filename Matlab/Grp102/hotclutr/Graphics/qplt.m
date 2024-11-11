plot(matRange(:,index)/1000, db(matSigma0(:,index)), ...
matRange(:,index)/1000,db(matNoiseFlr(:,index)), '--r')
axis([0 200 -80 -10])
grid
xlabel('Radial Range (kilometers)')
ylabel('Amplitude (dB)')
title(['Sigma0: Socorro Peak, 435.0 MHz, H Polarization, 13 uSec PCW' ...
' Azimuth : ' num2str(mean(Azimuth(:,index)))])                  
%eval(['print -dps sig0_' num2str(mean(Azimuth(:,index)))]);

