%volumeRotateTest      Test the volumeRotate function
function volumeRotateShiftTest
% Create a simple volume with particle orientation that is clearly
% identifiable
nX = 25;
nY = 25;
nZ = 25;
length = 15;
width = 3;
slope = 2/length;
frequency = 0.1;
phase = 0;

coordX = [0:nX-1] - floor(nX /2);
coordY = [0:nY-1] - floor(nY /2);
coordZ = [0:nZ-1] - floor(nZ /2);
[argX argY argZ] = ndgrid(coordX, coordY, coordZ);

vol = srsxyz(argX, argY, argZ, length, width, slope, frequency, phase);

% Display the un-rotated volume
cmap = bone(256);
figure(1)
colormap(cmap)
stackGallery(vol);

% A simple 90 degree rotation around Z and then a 5 pixel shift in X
rotVol = volumeShiftRotateInv(vol, [5 0 0], [90 0 0] * pi / 180);
figure(2)
colormap(cmap)
stackGallery(rotVol);
