%peakInterp3Test   Test the peakInterp3 function

% generate a simple second order 3D hyper-surface
nX = 8;
domX = [-3 4];
idxX = linspace(domX(1), domX(2), nX);

nY = 5;
domY = [3 7];
idxY = linspace(domY(1), domY(2), nY);

nZ = 5;
domZ = [-2 2];
idxZ = linspace(domZ(1), domZ(2), nZ);

[locX locY locZ] = ndgrid(idxX, idxY, idxZ);

locPeak = [-1.7 4.1 -0.2];
ax = -0.02;
ay = -0.03;
az = -0.07;
vol = 1 ... 
  + ax * (locX - locPeak(1)).^2 ...
  + ay * (locY - locPeak(2)).^2 ...
  + az * (locZ - locPeak(3)).^2;

[val extPeak] = peakInterp3(locX, locY, locZ, vol, 0.1)


[val2 loc] = peakInterpSO3(locX, locY, locZ, vol)