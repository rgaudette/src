%diskfft
%
% im = diskfft(im, radius);
%
% im           input image
%
% radius       cutoff relative the Nyquist frequency
function im = diskfft(im, radius);

% Get the 2D FFT and normalized frequency plane values
im = fft2(im);
[nY nX] = size(im);

% Shift freq done +/- 0.5
Fx = [0:nX-1]/nX;
idxNeg = find(Fx >=0.5);
Fx(idxNeg) = Fx(idxNeg) - 1;

Fy = [0:nY-1]/nY;
idxNeg = find(Fy >=0.5);
Fy(idxNeg) = Fy(idxNeg) - 1;

[FX FY] = meshgrid(Fx, Fy);
Fr = abs(FX+j*FY);

im = im .* (Fr < (radius / 2));

im = abs(ifft2(im));
