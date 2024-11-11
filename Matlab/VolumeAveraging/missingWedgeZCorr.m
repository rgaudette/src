tilts = [-60:60];
% Create a simple image
imSize = 256;
im = zeros(imSize);
center = floor(size(im)/2) + 1;
r = imSize / 4;
for i=0:359
  idxX = floor(r * cos(i*pi/180) + center(1));
  idxY = floor(r * sin(i*pi/180) + center(2));
  im(idxX, idxY) = 1;
end
figure(1);
imagesc(im);
colormap(gray(256))
axis('image')

% Compute the radon transform
rad = radon(im, tilts);
idxY = [-floor(size(rad,1) /2):floor(size(rad,1) /2)];

figure(2)
imagesc(tilts, idxY, rad);
colormap(gray(256))

% Compute the inverse radon transform
irad = iradon(rad, tilts);
irad = irad(2:end-1, 2:end-1);
figure(3)
imagesc(irad)
colormap(gray(256))
axis('image')

% Compute the wedge masked image
%wedge = av3_wedge(zeros(imSize,1,imSize), min(tilts)+10, max(tilts)-10);
%wedge = squeeze(wedge(:,1,:))';
% Create a smoothed wedge mask
%g = gausswin(20);
%G = (g * g') ./ sum(g(:));
%smooth_wedge = conv2(wedge, G, 'same');
%wedge = smooth_wedge;

szIM = [imSize imSize];
center = floor(szIM / 2) + 1;
[fy fx] = ndgrid(([1:szIM(1)] - center(1)) ./ szIM(1), ...
                 ([1:szIM(2)] - center(2)) ./ szIM(2));

angle = atan2(fy, fx);
fmag = sqrt(fx .^ 2 + fy .^ 2);

% Missing wedge filter
maxTilt = max(tilts) * pi / 180;
minTilt = min(tilts) * pi / 180;

zeroMask = (fx >= 0) & (angle <= maxTilt) & (angle >= minTilt) ...
    | (fx < 0) & (angle <= maxTilt-pi)  ...
    | (fx < 0) & (angle >= minTilt+pi);
transwidth = 10 * pi /180;
transMaskMaxPlus = 1 - gaussian(atan2(fy, fx), maxTilt, transwidth);
transMaskMaxMinus = 1 - gaussian(atan2(fy, fx), maxTilt-pi, transwidth);
transMaskMinPlus = 1 - gaussian(atan2(fy, fx), minTilt, transwidth);
transMaskMinMinus = 1 - gaussian(atan2(fy, fx), minTilt+pi, transwidth);
wedge = zeroMask .* transMaskMaxPlus .* transMaskMaxMinus ...
    .* transMaskMinPlus .* transMaskMinMinus;% .* fMask;

figure(4)
imagesc(wedge)
colormap(gray(256))

IRAD = fftshift(fft2(irad));
wIRAD = IRAD .* wedge;
figure(5)
set(5, 'position', get(4, 'position'));
imagesc(log10(abs(wIRAD)))
colormap(gray(256))

wirad = ifft2(ifftshift(wIRAD));
figure(6)
set(6, 'position', get(3, 'position'));
imagesc(real(wirad))
colormap(gray(256))
axis('image')

% Interpolate the radon transform to attempt to remove the artifacts
figure(7)
set(7, 'position', get(3, 'position'));
tiltsInterp = [-70:0.5:70];
zEnd = zeros(length(idxY), 1);
radInterp = interpn(idxY', [-70 tilts 70], [zEnd rad zEnd], idxY', tiltsInterp);
iradInterp = iradon(radInterp, tiltsInterp);
iradInterp = iradInterp(2:end-1, 2:end-1);
imagesc(iradInterp)


% There is really no difference between masking and not masking
% what about noise?
% the missing wedge clearly affects the vertical direction ambiguity in the
% cross correlation
