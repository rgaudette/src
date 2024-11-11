volume = MRCImage('fairReferenceTest.mrc', 0);
imodParticle = ImodModel('fairReferenceTrue.mod');
searchRadius = 6;
srm1 = searchRadius - 1;
points = getPoints(imodParticle, 1, 1)
pointsShift = 2*(rand(size(points))-0.5) * (srm1);
pointsShift(:,1:4) = [ ...
  0 -srm1 srm1 -srm1
  0 0     -srm1 srm1
  0 0     0    -srm1 ];

pointsShift = [ ...
  0 -srm1 srm1 -srm1 srm1 -srm1 srm1 -srm1
  0 0     -srm1 srm1 0    0     -srm1 srm1
  0 0     0    -srm1 srm1 -srm1  srm1 srm1]

%pointsShift = zeros(size(points))
pointErr = points + pointsShift
imodParticle = ImodModel(pointErr);
motiveList = loadMOTL('fairReferenceTest_MOTL_1.em')
szVol = [36 36 36]
vDeltaPhi = [0]
vDeltaTheta = [0]
vDeltaPsi = [0]
lowCutoff = 0
hiCutoff = [0.9 0.05]


select = [1:8]
debugLevel = 2;

[volumes selectOut eulerOffset strcTransform ] = fairReference(volume, imodParticle, ...
  select, motiveList, szVol, vDeltaPhi, vDeltaTheta, vDeltaPsi, searchRadius, ...
  lowCutoff, hiCutoff, debugLevel);


save simFairReferenceTest_wideband volumes selectOut eulerOffset strcTransform pointErr vDelta* lowCutoff hiCutoff
