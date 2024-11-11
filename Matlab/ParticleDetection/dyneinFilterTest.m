%dyneinFilterTest   Test script dyneinFilter
tubeDim = [100 40];
interpMethod = 'linear';
nXYFilt = 21;
nZFilt = 10;
nLength = 10;
idxDyn = 1;


% get the tube that lies on the contour containing the known dynein locations
sectContour = ax6Contour(8:9,:);

[sectTube sectCoords sectPlanes] = ...
    interpTube(ax6, sectContour, [1 1 1], tubeDim, interpMethod);

[nXY nZ nL] = size(sectTube);

% get the matched filter from the volume
dynLocs = findTubeIndex(sectContour, ax6dyn)
idxXYFilt = round((nXY-nXYFilt)/2:(nXY+nXYFilt)/2);
idxZFilt = round((nZ-nZFilt)/2:(nZ+nZFilt)/2);
dynFiltCenter = dynLocs(idxDyn);
idxLFilt = round(dynFiltCenter-nXYFilt/2:dynFiltCenter+nXYFilt/2);
dynFilt = sectTube(idxXYFilt, idxZFilt, idxLFilt);

%filter the tube
xcTube = xcorr3d(sectTube, dynFilt, 'valid');
