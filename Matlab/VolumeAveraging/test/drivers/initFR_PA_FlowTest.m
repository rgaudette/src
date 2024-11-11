%initFR_PA_FlowTest
szFullVol = [400 400 100];

% Set the length to be odd so that particle is initially exactly aligned
% with the sampling grid
length = 19;
width = 3;
nParticles = 32;
szFullRef = [36 36 36];

% Set the minimum distance between particles and the edge of the volume
searchRadius = 6;
bufferDist = length + 2 * searchRadius;

% SNR is defined as the standard deviation of the particle in the sub
% volume over the standard deviation of the noise in the subvolume
SNR = 0.5;
intensityOffset = 1000;

% The orientation of the first particles
orient = zeros(3, 1);


% Create the random test volume
[volume, reference, modParticle, motiveList] = ...
  randomTestVolume(szFullVol, nParticles, length, width, bufferDist, orient);

% Add a constant offset to the volume, gives a similar range values as the
% microscope data
volume = volume + intensityOffset;

% Map the limited reference volume to the full size typically used
szRef = size(reference);
fullRef = zeros(szFullRef);
refShift = floor((szFullRef - szRef) / 2) + 1;
fullRef(refShift(1)+[1:szRef(1)], ...
  refShift(2)+[1:szRef(2)], refShift(3)+[1:szRef(3)]) = reference;

%  Add the specified noise to the volume
stdSignal = std(reference(:))
stdNoise = stdSignal / SNR
volume = volume + stdNoise * randn(size(volume));

% Save the results to the appropriate files
mrcVolume = MRCImage(volume);
save(mrcVolume, 'FR_PA_FlowTest_SNR0p5.mrc');
save(MRCImage(fullRef), 'FR_PA_FlowTest_InitRef_SNR0p5.mrc');
write(modParticle, 'FR_PA_Flow_True_SNR0p5.mod');
tom_emwrite('FR_PA_FlowTest_SNR0p5_MOTL_1.em', tom_emheader(motiveList));

szVol = szFullRef;
save FR_PA_Params szVol searchRadius