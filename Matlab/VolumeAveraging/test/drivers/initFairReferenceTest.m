%initTransformTest
szVol = [256 256 100];

% Set the length to be odd so that particle is initially exactly aligned
% with the sampling grid
length = 19;
width = 3;
nParticles = 8;
szFullRef = [36 36 36];

% Set the minimum distance between particles and the edge of the volume
searchRadius = 6;
bufferDist = length + 2 * searchRadius;

% SNR is defined as the standard deviation of the particle in the sub
% volume over the standard deviation of the noise in the subvolume
SNR = 10000;

% The orientation of the particles
orient = zeros(3, nParticles);
[volume, reference, modParticle, motiveList] = ...
  randomTestVolume(szVol, nParticles, length, width, bufferDist, orient);

% Add a constant offset to the volume
volume = volume + 1000;

% Map the limited reference volume to the full size typically used
szRef = size(reference);
fullRef = zeros(szFullRef);
refShift = floor((szFullRef - szRef) / 2) + 1;
fullRef(refShift(1)+[1:szRef(1)], ...
  refShift(2)+[1:szRef(2)], refShift(3)+[1:szRef(3)]) = reference;

%  Add some noise to the volume to prevent divide by zero errors when
%  calculating the masked particle energy in particleAlign3
stdSignal = std(reference(:))
stdNoise = stdSignal / SNR
volume = volume + stdNoise * randn(size(volume));


mrcVolume = MRCImage(volume);
save(mrcVolume, 'fairReferenceTest.mrc');
save(MRCImage(fullRef), 'fairReferenceTest_InitRef.mrc');
write(modParticle, 'fairReferenceTrue.mod');
tom_emwrite('fairReferenceTest_MOTL_1.em', tom_emheader(motiveList));