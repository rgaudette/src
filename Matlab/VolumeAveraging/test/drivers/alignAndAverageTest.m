
fnVolume = '6f51.rec';
fnModParticle = 'IDA1.mod';
reference = 5;
szVol = [64 64 64];
fnOutput = 'junk';
listPhi = {[-4:4], [-4:4]};
listTheta= {[-4:4], [-4:4]};
listPsi = {[0], [0]};
listPhi = {[0], [0]};
listTheta = {[0], [0]};
listPsi = {[0], [0]};
searchRadius = 10;
lowCutoff = 0;
hiCutoff = 0.35;
refThreshold = 4;
lstThresholds = [2:10];
debugLevel = 1;

alignAndAverage(fnVolume, fnModParticle, reference, szVol, ...
  fnOutput, listPhi, listTheta, listPsi, searchRadius, ...
  lowCutoff, hiCutoff, refThreshold, lstThresholds, debugLevel)