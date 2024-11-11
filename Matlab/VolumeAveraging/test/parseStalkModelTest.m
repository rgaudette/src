% Load the stalk model
imodStalk = ImodModel('thyl3_2-ATP1.mod');

% parse the the stalk model
[imodHead imodCentroid initMotiveList] = parseStalkModel(imodStalk, 0);

% Test: make sure the rotation that is applied in motlAverage? results in
% the
stalks = getObject(imodStalk, 1);
nStalks = getNContours(stalks);

for iStalk = 1:size(initMotiveList, 2)
  ptsStalk = getPoints(stalks, iStalk);
  vecStalk = ptsStalk(:,2) - ptsStalk(:,1);
  rotVec = eulerRotateInv(vecStalk, initMotiveList([17 19 18], iStalk)' * -pi / 180)
end

volume = MRCImage('thyl_3_2.rec', 0);

% Extract the sub volumes around the head points and volume rotate them by
% the initial motive list
volSize = [64 64 64];
ptsHead = getPoints(imodHead, 1, 1);
nPts = size(ptsHead, 2);
fnBase = 'testVol_';
for iHead = 1:nPts
  subvol = extractSubVolume(volume, ptsHead(:, iHead), volSize);
  eulerRot = [...
    initMotiveList(17, iHead) ...
    initMotiveList(19, iHead) ...
    initMotiveList(18, iHead)] ;
  subvol = volumeRotate(subvol, eulerRot * pi / 180);
  strPart = sprintf('%03d', iHead);
  mrcVol = MRCImage(subvol);
  save(mrcVol, [fnBase strPart '.mrc']);
end
