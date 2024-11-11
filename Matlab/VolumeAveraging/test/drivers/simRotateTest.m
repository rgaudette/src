%simRotateTest

% Add some small errors to the model
offset = zeros(size(iPoints));
%offset = 2 * (shiftLimit - 1) * (rand(size(iPoints)) - 0.5);
modParticle = ImodModel((iPoints - offset)');
write(modParticle, 'rotateTest.mod');

% Create the accurate motive list
motl = zeros(20, nPoints);
motl(1,:) = 1;
motl(4,:) = 1:nPoints;
motl(5,:) = 1;
motl([17 19 18], :) = euler' * 180 / pi;
tom_emwrite('rotateTest_MOTL_1.em', tom_emheader(motl));

outMotl = particleAlign3(mrcVolume, 2, modParticle, szFullRef, motl, ...
  [-10:10:10], [-10:10:10], [-10:10:10], shiftLimit, 0, 0.866, 2);

shiftDiff = outMotl(11:13, :)' - offset
avgVol = motlAverage3(mrcVolume, modParticle, szFullRef, outMotl, 0);

figure(1)
showMRCImage(avgVol(:,:,17));
grid on
colorbar('vert');

figure(2)
avgVolDiff = avgVol - fullRef;
showMRCImage(avgVolDiff(:,:,17));
grid on
colorbar('vert');
