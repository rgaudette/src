% This experiment uses a sidelobe surpressing window on the projections
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
im = im - mean(im(:));
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

nWind = 10;
taper = hamming(nWind*2)';
nMiddle = length(tilts) - 2 * nWind;
wind = [taper(1:nWind) ones(1, nMiddle) taper(nWind+1:2*nWind)];
wRadon = rad .* repmat(wind, size(rad,1), 1);
wInvRadon = iradon(wRadon, tilts);
wInvRadon = wInvRadon(2:end-1, 2:end-1);

figure(6)
set(6, 'position', get(3, 'position'));
imagesc(wInvRadon)
colormap(gray(256))
axis('image')

% Interpolate the radon transform to attempt to remove the artifacts
% figure(7)
% set(7, 'position', get(3, 'position'));
% tiltsInterp = [-70:0.5:70];
% zEnd = zeros(length(idxY), 1);
% radInterp = interpn(idxY', [-70 tilts 70], [zEnd rad zEnd], idxY', tiltsInterp);
% iradInterp = iradon(radInterp, tiltsInterp);
% iradInterp = iradInterp(2:end-1, 2:end-1);
% imagesc(iradInterp)
