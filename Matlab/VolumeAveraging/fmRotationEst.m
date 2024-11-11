%fmRotationEst  Fourier-Mellin image rotation estimate
%
%  rot = fmRotationEst(ref, test)

function rot = fmRotationEst(ref, test)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: fmRotationEst.m,v 1.3 2005/08/15 23:17:36 rickg Exp $\n');
end

% Compute the DFT of both images
ref = ref - mean(ref(:));

REF = fftshift(abs(fftn(ref)));
figure(1)
imagesc(REF)

test = test - mean(test(:));
TEST = fftshift(abs(fftn(test)));
szRef = size(REF);
fx = ([0:szRef(2)-1] - floor(szRef(2) / 2)) / szRef(2);
fy = ([0:szRef(1)-1] - floor(szRef(1) / 2)) / szRef(1);
nRadius = 100;
r = [1:nRadius]' ./ nRadius * max(matmax(fx), matmax(fy));
theta = [0:0.25:180] * (pi / 180);
nTheta = length(theta);
R = repmat(r, 1, nTheta);
THETA = repmat(theta, nRadius, 1);


% Interpolate the magnitude of the DFT along r and theta axis
iy = R .* sin(THETA);
ix = R .* cos(THETA);
fmREF = interpn(fy, fx, REF, iy, ix);
figure(2)
imagesc(theta/pi*180, r, fmREF)

figure(3)
imagesc(TEST);


fmTEST = interpn(fy, fx, TEST, iy, ix);
figure(4)
imagesc(theta/pi*180, r, fmTEST)

figure(5)
clf
thetaSigREF = sum(fmREF);
thetaSigTEST = sum(fmTEST);
plot(theta, thetaSigREF);
hold on
plot(theta, thetaSigTEST, 'r');
figure(6)
plot(theta*180/pi, real(ifft(fft(thetaSigREF) .* conj(fft(thetaSigTEST)))))
%[xcf peak shift] = maskedCCC2(fmREF, fmTEST, 20);
%peak
%shift
keyboard

