% Create a simple 1D signal
nElem = 32;
nPulse = 19;
xShift = -3;
pulseStart = floor((nElem - nPulse) / 2) + 1
pulseIdx = pulseStart:pulseStart+nPulse-1;
pulseEnd = max(pulseIdx)

rPulse = randn(nPulse,1);
x = randn(nElem,1);

x(pulseIdx + xShift) = rPulse;

% y is the reference signal
y = randn(nElem,1);
y(pulseIdx) = rPulse;

szArray = length(x);

searchRadius = floor((nElem - nPulse) / 2)

[spatialMask ccMask] = genMasks(szArray, searchRadius);
idxSpatial = find(spatialMask);
spatialStart = min(idxSpatial)
spatialStop = max(idxSpatial)

ccSeq = corrcoefseq(x, y, spatialMask, ccMask);
lag = (0:nElem-1)' - floor(nElem / 2);
minLag = min(lag)
maxLag = max(lag)

plot(lag, ccSeq)
axis([-searchRadius searchRadius -1 1])
[val idx] = max(ccSeq)
lag(idx)
