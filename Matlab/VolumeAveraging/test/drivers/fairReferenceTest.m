volume = MRCImage('thyl_3_2.rec', 0);
imodParticle = ImodModel('sideview_head.mod');
motiveList = loadMOTL('postRotateMembraneW_MOTL_2.em');
szVol = [36 36 36];
vDeltaPhi = [-10:2:10];
vDeltaTheta = [-10:2:10];
vDeltaPsi = [0];
searchRadius = 5;
lowCutoff = 0
hiCutoff = 0.35

select = [1:4]
debugLevel = 2;

[ccMeasure] = fairReference(volume, imodParticle, ...
  select, motiveList, szVol, vDeltaPhi, vDeltaTheta, vDeltaPsi, searchRadius, ...
  lowCutoff, hiCutoff, debugLevel)