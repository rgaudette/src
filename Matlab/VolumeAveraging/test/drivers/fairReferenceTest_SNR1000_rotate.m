volume = MRCImage('fairReferenceTest_SNR1000.mrc', 0);
imodParticle = ImodModel('fairReference_True_SNR1000.mod');
searchRadius = 10;
maxShift = floor(searchRadius/2);
points = getPoints(imodParticle, 1, 1)
pointsShift = zeros(size(points));
pointErr = points + pointsShift;
imodParticle = ImodModel(pointErr);
motiveList = loadMOTL('fairReferenceTest_SNR1000_MOTL_1.em');
szVol = [36 36 36]
vDeltaPhi = [-20:10:20]
vDeltaTheta = [-20:10:20]
vDeltaPsi = [-20:10:20]

% Turn off filtering
lowCutoff = 0
hiCutoff = [0.9 0.05]

select = [1 10:16]
debugLevel = 2;
st=clock;
[refVol selectOut eulerOffset strcTransform ] = ...
  fairReference(volume, imodParticle, select, motiveList, szVol, ...
  vDeltaPhi, vDeltaTheta, vDeltaPsi, searchRadius, ...
  lowCutoff, hiCutoff, debugLevel);
fprintf('Elapsed time: %f seconds\n', etime(clock,st))

stackGallery(volumeRotateInv(refVol, -1* eulerOffset));

save fairReferenceTest_SNR1000_rotate_wideband ...
  refVol selectOut eulerOffset strcTransform pointErr vDelta* lowCutoff hiCutoff
