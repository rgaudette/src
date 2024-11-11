%	Required variables
%
% W		Beamformer coefficients
% MFC013n	Matched filter coefficients for noise sequence
% PhaseCorr	Phase correction applied to time sequence

%
%    Beamform all 4 cpis.
%
bfcpi = cpi1(:, 2:14) * conj(W);
bfcpi = [ bfcpi; cpi2(:, 2:14)*conj(W)];
bfcpi = [ bfcpi; cpi3(:, 2:14)*conj(W)];
bfcpi = [ bfcpi; cpi4(:, 2:14)*conj(W)];
%bfcpi = [ bfcpi; cpi5(:, 2:14)*conj(W)];
%bfcpi = [ bfcpi; cpi6(:, 2:14)*conj(W)];


%
%    Extract dipole from CPIs.
%
dipole = [cpi1(:,1); cpi2(:,1); cpi3(:,1); cpi4(:,1)];

%
%    Remove raw cpis.
%
%clear cpi1 cpi2 cpi3 cpi4

%
%    Coherently Integrate all 64 pulses.
%
bfcpi_ci = cpicint(bfcpi, wrecord);
dipole_ci = cpicint(dipole, wrecord);

%
%    Matched filter integrated output.
%
mfout = ifft(fft(bfcpi_ci(1:495)) .* MFC013n);
DipoleMF = ifft(fft(dipole_ci(1:495)) .* MFC013n);
[DipolePeak DipolePeakIdx] = max(20 * log10(abs(DipoleMF)));


