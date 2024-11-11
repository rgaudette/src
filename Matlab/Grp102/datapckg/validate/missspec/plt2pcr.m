function plt2pcr(cpi, npulses, Channel, Title)
[nSamp nChan] = size(cpi);
wrecord = nSamp / npulses;

for idxPulse = 2:16,

clf
subplot(211);
idxRg = [((idxPulse - 1) * wrecord + 1):(idxPulse * wrecord)];
idxCancel = [((idxPulse - 2) * wrecord + 1):((idxPulse - 1)* wrecord)];
Pulse = cpi(idxRg, Channel);
Canceller = cpi(idxCancel, Channel);
plot(20*log10(abs(Pulse)))
hold on
plot(20*log10(abs(Pulse - Canceller)), 'r-')
grid
title([ Title '  Pulse #' int2str(idxPulse)]);

subplot(212);
plot(20*log10(abs(Pulse)) - 20*log10(abs(Pulse - Canceller)));
grid
drawnow;
print
end
