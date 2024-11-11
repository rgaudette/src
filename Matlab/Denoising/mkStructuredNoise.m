%mkStructuredNoise  Given an MTF curve create a structured noise image
%
%  noise = mkStructuredNoise(mtf, nElem)
%
%  noise   The strcutured noise array
%
%  mtf     A [Nx2] array containing the frequencies and MTF values
%
%  nElem   The dimension of the noise image to generate, single int since it is
%          square

function noise = mkStructuredNoise(mtf, nElem)

% extend the MTF from 0 to 0.5 if necessary
if mtf(1, 1) > 0.0
  mtf = [0 1.0; mtf];
end
if mtf(end, 1) < 0.5
  mtf = [mtf; 0.5 0.0];
end

% Create a frequency grid to interpolate the MTF fuction
fxStart = - ceil((nElem-1) / 2);
fxEnd = floor((nElem-1) / 2);
f = linspace(fxStart, fxEnd, nElem) / nElem;
[fX fY] = meshgrid(f, f);
fMag = sqrt(fX.^2 + fY.^2);

% Generate an interpolated MTF spectrum, anything abs > 0.5 is zero
filt = interp1(mtf(:,1), mtf(:,2), fMag(:));
filt(fMag > 0.5) = 0;
filt = reshape(filt, nElem, nElem);

% Create a white noise image and filter it with the MTF curve
N2D = fft2(randn(nElem));
F2D = fftshift(N2D) .* filt;
noise = real(ifft2(ifftshift(F2D)));


