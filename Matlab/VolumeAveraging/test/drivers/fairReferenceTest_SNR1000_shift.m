volume = MRCImage('fairReferenceTest_SNR1000.mrc', 0);
imodParticle = ImodModel('fairReference_True_SNR1000.mod');
searchRadius = 10;
maxShift = floor(searchRadius/2);
points = getPoints(imodParticle, 1, 1);
pointsShift = 2*(rand(size(points))-0.5) * (maxShift);

% Set the first half of the particles to be off by the maximum shift
pointsShift(:,1:8) = [ ...
  0 -maxShift maxShift -maxShift maxShift -maxShift maxShift -maxShift
  0 0     -maxShift maxShift 0    0     -maxShift maxShift
  0 0     0    -maxShift maxShift -maxShift  maxShift maxShift]

pointErr = points + pointsShift
imodParticle = ImodModel(pointErr);
motiveList = loadMOTL('fairReferenceTest_SNR1000_MOTL_1.em');
szVol = [36 36 36]
vDeltaPhi = [-20:10:20]
vDeltaTheta = [-20:10:20]
vDeltaPsi = [-20:10:20]

% Turn off filtering
lowCutoff = 0
hiCutoff = [0.9 0.05]


select = [1:8]
debugLevel = 2;
st=clock;
[refVol selectOut eulerOffset strcTransform ] = ...
  fairReference(volume, imodParticle, select, motiveList, szVol, ...
  vDeltaPhi, vDeltaTheta, vDeltaPsi, searchRadius, ...
  lowCutoff, hiCutoff, debugLevel);
fprintf('Elapsed time: %f seconds\n', etime(clock,st))

stackGallery(volumeRotateInv(refVol, -1* eulerOffset));

save fairReferenceTest_SNR1000_shift_wideband ...
  refVol selectOut eulerOffset strcTransform pointErr vDelta* lowCutoff hiCutoff
