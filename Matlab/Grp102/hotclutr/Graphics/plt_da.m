%PLT_DA         Plot direct path aligned matched filter output.
axis([0 200 0 100])
plot(Range / 1000, 20 *log10(abs(mfout)));
grid
xlabel('Range (kilometers)')
ylabel('Amplitude (dB)')
title('Direct Path Aligned Pulse Compressor Output')
