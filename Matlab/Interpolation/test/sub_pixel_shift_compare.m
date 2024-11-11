% Create a bandlimited random sequence
nSamples = 1024;
zfull = randn(nSamples,1);
hLPF = firpm(nSamples / 8, [0 0.075 0.1 1], [1 1 0 0]);
ZBL = fft(zfull) .* fft(hLPF', nSamples);
zbl = ifft(ZBL);

% Subsample it
subsample = 10;
zbl_deci = zbl(1:subsample:end);
nSubSample = length(zbl_deci);

shift = .5;
% Get the nearest neighbor shifted sequence from the band limited sequence
idxShift = [1:subsample:nSamples] + shift * subsample;
idxShift = round(idxShift);
idxShift = idxShift((idxShift >= 1 & idxShift <= nSamples));
zbl_deci_shift = zbl(idxShift);

% Compute the fourier transform approximation of the sub pixel shift
ZBL_DECI = fft(zbl_deci);
nFFT = length(ZBL_DECI);
w = 2*pi*[0:nFFT-1]'./nFFT;
zbl_d10_shift = real(ifft(exp(-j*w*shift) .* ZBL_DECI));

% Display the shifted signal
clf
plot(zbl_deci, 'b--');
hold on
plot(zbl_deci_shift, 'b');
plot(zbl_d10_shift, 'r');
set(gca, 'xlim', [1 15]);
grid on

% Compute the linear interpolation sub pixel shift
zbl_d10_interp = interp1([1:nSubSample], zbl_deci, [1:nSubSample]+shift);
plot(zbl_d10_interp, 'g');

% Compute the cubic interpolation sub pixel shift
zbl_d10_cubic = interp1([1:nSubSample], zbl_deci, [1:nSubSample]+shift, 'cubic');
plot(zbl_d10_cubic, 'm');

legend('Original subsample', ...
  'Shifted subsample', ...
  'Fourier shift', ...
  'Linear interpolated shift', ...
  'Cubic interpolated shift');