%simRTransformTest
shiftLimit = 6

% Load in the input data
mrcVolume = MRCImage('rTransformTest.mrc');
mrcFullRef = MRCImage('rTransformTest_InitRef.mrc');
fullRef = getVolume(mrcFullRef);
szFullRef = size(fullRef);

motl = loadMOTL('rTransformTest_MOTL_1.em');
% Load in the true model and add some error
modTrue = ImodModel('rTransformTrue.mod');
ptsTrue = getPoints(modTrue, 1, 1);
offset = 2 * (shiftLimit - 1) * (rand(size(ptsTrue)) - 0.5)
%offset = zeros(size(offset))
%offset = [-1 -1 -1; 1*[1 1 1]];
modParticle = ImodModel((ptsTrue - offset));
write(modParticle, 'rTransformTest.mod');

outMotl3 = particleAlign3(mrcVolume, fullRef, modParticle, szFullRef, motl, ...
  [0], [0], 0, shiftLimit, 0, 0.866, 2);

rTransformDiff3 = outMotl3(11:13, :) - offset
avgVol3 = motlAverage3(mrcVolume, modParticle, szFullRef, outMotl3, 0);

outMotl4 = particleAlign4(mrcVolume, fullRef, modParticle, szFullRef, motl, ...
  [0], [0], 0, shiftLimit, 0, 0.866, 2);
rTransformDiff4 = outMotl4(11:13, :) - offset
avgVol4 = motlAverage3(mrcVolume, modParticle, szFullRef, outMotl4, 0);

rTransformDiff4 - rTransformDiff3