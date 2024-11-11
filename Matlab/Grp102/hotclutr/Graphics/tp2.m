%%
%%    Process raw dipole
%%
tplot(20*log10(abs(dipole(1:wrecord))),  ...
'Simulated Receiver Noise.', ...
'RSTER Azimuth: 302', ...
'Channel 1 (dipole)', ...
'BQS Data', ...
['Mean Power: ' ...
num2str(10 * log10(mean(real(dipole .* conj(dipole))))) ' dB'], ...
'66.7km @ 302 degrees', ...
'File: acal101v1')
title('M Mountain')
xlabel('Time (uSecs)')
ylabel('Amplitude (dB)')
grid
disp('Change axis ?')
keyboard
print

%%
%%    Integrated Dipole
%%
tplot(20*log10(abs(dipole_ci)),  ...
'Simulated Receiver Noise.', ...
'RSTER Azimuth: 302', ...
'Channel 1 (dipole)', ...
'64 Pulse Integration', ...
['Mean Power: ' ...
num2str(10 * log10(mean(real(dipole_ci .* conj(dipole_ci))))) ' dB'], ...
'66.7km @ 302 degrees', ...
'File: acal101v1')
title('M Mountain')
xlabel('Time (uSecs)')
ylabel('Amplitude (dB)')
disp('Change axis ?')
grid
keyboard
print

%%
%%    Match filtered dipole
%%
tplot(20*log10(abs(DipoleMF)),  ...
'Simulated Receiver Noise.', ...
'RSTER Azimuth: 302', ...
'Channel 1 (dipole)', ...
'Matched Filter Output', ...
'64 Pulse Integration', ...
['Mean Power: ' ...
num2str(10 * log10(mean(real(DipoleMF .* conj(DipoleMF))))) ' dB'], ...
'66.7km @ 302 degrees', ...
'File: acal101v1')
title('M Mountain')
xlabel('Time (uSecs)')
ylabel('Amplitude (dB)')
disp('Change axis ?')
grid
keyboard
print

%%
%%    Process beamformer output
%%
tplot(20*log10(abs(bfcpi(1:wrecord))),  ...
'Simulated Receiver Noise.', ...
'RSTER Azimuth: 302', ...
'Beamformer Output', ...
['Mean Power: ' ...
num2str(10 * log10(mean(real(bfcpi .* conj(bfcpi))))) ' dB'], ...
'66.7km @ 302 degrees', ...
'File: acal101v1')
title('M Mountain')
xlabel('Time (uSecs)')
ylabel('Amplitude (dB)')
grid
disp('Change axis ?')
keyboard
print

%%
%%    Integrated Beamformer Output
%%
tplot(20*log10(abs(bfcpi_ci)),  ...
'Simulated Receiver Noise.', ...
'RSTER Azimuth: 302', ...
'Beamformer Output', ...
'64 Pulse Integration', ...
['Mean Power: ' ...
num2str(10 * log10(mean(real(bfcpi_ci .* conj(bfcpi_ci))))) ' dB'], ...
'66.7km @ 302 degrees', ...
'File: acal101v1')
title('M Mountain')
xlabel('Time (uSecs)')
ylabel('Amplitude (dB)')
disp('Change axis ?')
grid
keyboard
print

%%
%%    Match filtered dipole
%%
tplot(20*log10(abs(mfout)),  ...
'Simulated Receiver Noise.', ...
'RSTER Azimuth: 302', ...
'Beamformer Output', ...
'64 Pulse Integration', ...
'Matched Filter Output', ...
['Mean Power: ' ...
num2str(10 * log10(mean(real(mfout .* conj(mfout))))) ' dB'], ...
'66.7km @ 302 degrees', ...
'File: acal101v1')
title('M Mountain')
xlabel('Time (uSecs)')
ylabel('Amplitude (dB)')
disp('Change axis ?')
grid
keyboard
print