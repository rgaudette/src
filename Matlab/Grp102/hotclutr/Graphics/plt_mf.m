%PLT_MF
axis([0 1651 0 100])
plot(tDelta * 1e6, 20 *log10(abs(mfout_nonalign)));
hold on
plot(tDelta * 1e6, 20 *log10(abs(DipoleMF)), '--g')
grid
xlabel('Time (uSec)')
ylabel('Amplitude (dB)')
title('Pulse Compressor Output')
hold off
