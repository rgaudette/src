%PLT_S0         Plot sigma-0 
axis([0 200 -80 0])
plot(Range / 1000, 10 *log10(abs(Sigma0)));
grid
xlabel('Range (kilometers)')
ylabel('Amplitude (dB)')
title(['Sigma 0: ' num2str(Azimuth) ' degrees'])
