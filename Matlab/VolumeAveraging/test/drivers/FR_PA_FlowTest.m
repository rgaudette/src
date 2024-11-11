% FR_PA_FlowTest

% Load up the input data
load FR_PA_Params
volume = MRCImage('FR_PA_FlowTest_SNR0p5.mrc', 0);
imodParticle = ImodModel('FR_PA_Flow_True_SNR0p5.mod');
motiveList = loadMOTL('FR_PA_FlowTest_SNR0p5_MOTL_1.em')

maxShift = floor(searchRadius/2);
points = getPoints(imodParticle, 1, 1)

% Specify the amount of error in the particle locations
pointsShift = 2*(rand(size(points))-0.5) * (maxShift);
% Set the first half of the particles to be off by the maximum shift
pointsShift(:,9:16) = [ ...
  0 -maxShift maxShift -maxShift maxShift -maxShift maxShift -maxShift
  0 0     -maxShift maxShift 0    0     -maxShift maxShift
  0 0     0    -maxShift maxShift -maxShift  maxShift maxShift]

pointErr = points + pointsShift
imodParticle = ImodModel(pointErr);


% Euler angle search specification
vDeltaPhi = [-10:10:10]
vDeltaTheta = [-10:10:10]
vDeltaPsi = [0]

% Turn of filtering
lowCutoff = 0
hiCutoff = [0.9 0.05]


select = [1 10:16]
debugLevel = 2;

% Compute a fair reference from the volume
st=clock;
[refVol selectOut eulerOffset strcTransform ] = ...
  fairReference(volume, imodParticle, select, motiveList, szVol, ...
  vDeltaPhi, vDeltaTheta, vDeltaPsi, searchRadius, ...
  lowCutoff, hiCutoff, debugLevel);
fprintf('Elapsed time: %f seconds\n', etime(clock,st))

% Display the fair reference
figure(1)
stackGallery(volumeRotateInv(refVol, -1* eulerOffset));


% Compute the best alignement of all particles using
[motiveListOut, peakParams] = particleAlign4(volume, refVol, eulerOffset, ....
  imodParticle, szVol, motiveList, vDeltaPhi, vDeltaTheta, vDeltaPsi, ...
  searchRadius,  lowCutoff, hiCutoff, debugLevel);

% Compute the volume average from the best alignment of all of the
% particles
refThreshold = 0;
[avgVol nAvg threshold idxSelected] = ...
  motlAverage3(volume, imodParticle, szVol, motiveListOut, refThreshold, ...
  [], debugLevel);

figure(2)
stackGallery(avgVol);
save FR_PA_FlowTest motiveList peakParams avgVol nAvg threshold idxSelected ...
  refVol selectOut eulerOffset strcTransform pointErr vDelta* lowCutoff hiCutoff
