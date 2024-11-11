load lavqrd
plot(rate, -10*log10(dist), 'r')
hold on

load -ascii rd2b.txt
plot(rd2b(:,1), -10*log10(rd2b(:,2)/2), 'g')

load -ascii rd2c.txt
plot(rd2c(:,1), -10*log10(rd2c(:,2)/2), 'b')

load -ascii rd2d.txt
plot(rd2d(:,1), -10*log10(rd2d(:,2)/2), 'w')

load -ascii rd4b.txt
plot(rd4b(:,1), -10*log10(rd4b(:,2)/4), 'c')

load -ascii rd8b.txt
plot(rd8b(:,1), -10*log10(rd8b(:,2)/8), 'm')

grid

xlabel('Rate (Bits/Sample)')

ylabel('SQNR (dB)')


legend('Full Search VQ (LBG)', 'ECVQ - K=2, #1', 'ECVQ - K=2, #2', ...
 'ECVQ - K=2, #3', 'ECVQ - K=4', 'ECVQ - K=8');
title('Rate-Distortion Comparison ECVQ/LBG - Laplacian Source Generated Codebooks');

orient landscape

