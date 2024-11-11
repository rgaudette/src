%particleAlign2Test  Tests for particle align 2

% Create the empty MRC Test volume
szTest = [256 256 200];
testVolume = MRCImage(zeros(szTest));

% Insert the particles in the volume
nVol = 32
ref = zeros(nVol, nVol, nVol);
idxOrigin = floor(size(ref) / 2 ) + 1;
lx = floor(nVol/4);
ref(idxOrigin(1):idxOrigin(1)+lx-1, idxOrigin(2)+[-1 0 1], idxOrigin(3)+[-1 0 1]) = 1;
ly = floor(nVol/3);
ref(idxOrigin(1)+[-1 0 1], idxOrigin(2):idxOrigin(2)+ly-1, idxOrigin(3)+[-1 0 1]) = 1;
lz = floor(nVol/2);
ref(idxOrigin(1)+[-1 0 1], idxOrigin(2)+[-1 0 1], idxOrigin(3):idxOrigin(3)+lz-1) = 1;

testVolume = setVolume(testVolume, ref, floor(szTest ./ 2) + 1);

% Save the volume
testVolume = setFilename(testVolume, 'testVolume.mrc');
testVolume = calcStatistics(testVolume);
save(testVolume);

% Run particleAlign2 on it
