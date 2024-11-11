szVol = [64 64 64];
rotate = [pi/3 -pi/4 pi/5];

% create a random volume
randVol = randn(szVol);
length = 50;
width = 5;
pos = szVol / 2;
[randVol] = srsParticleVolume(szVol, length, width, pos', [0 0 0]');
diffVol = volumeRotate_DualTest(randVol, rotate, [ ], 'spline');

stackGallery(diffVol);
