%volumeRotateTest      Test the volumeRotate function
function volumeRotateTest
% Create a simple volume with particle orientation that is clearly
% identifiable
nX = 25;
nY = 25;
nZ = 25;
length = 20;
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

% A simple 45 degree rotation around Z
rotVol = volumeRotate(vol, [45 0 0] * pi / 180, [], 'linear', 0);
figure(2)
colormap(cmap)
stackGallery(rotVol);

% This should also produce the same result
rotVol = volumeRotate(vol, [0 0 45] * pi / 180, [], 'linear', 0);
figure(3)
colormap(cmap)
stackGallery(rotVol);

% A 90 degree rotation around Z (aligns the step with Y), -90 degree
% rotation around X ( aligns the step with -Z), 45 degree rotation around X
% ( the sine should go positve towards the NW)
rotVol = volumeRotate(vol, [90 -90 45] * pi / 180, [], 'linear', 0);
figure(4)
colormap(cmap)
stackGallery(rotVol);