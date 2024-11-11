szVol = [512 512 100];
length = 20;
width = 1;
shiftLimit = 6
points = [...
  33 33 33
  szVol(1)-33 szVol(1)-33 33
  ];

nPoints = size(points, 1);

euler = [ ...
  0 0 0
  0 0 0
  ];
  
 
[volume reference] = testVolume(szVol, length, width, points, euler);
szRef = size(reference);
szFullRef = [32 32 32];
fullRef = zeros(szFullRef);
refShift = floor((szFullRef - szRef) / 2);
fullRef(refShift(1)+[1:szRef(1)], ...
  refShift(2)+[1:szRef(2)], refShift(3)+[1:szRef(3)]) = reference;


mrcVolume = MRCImage(volume);
%save(mrcVolume, 'test.mrc');

% Offset the X & Y points to match IMOD
iPoints = points - repmat([0.5 0.5 1], size(points, 1), 1);
write(ImodModel(iPoints'), 'true.mod');

% Add some small errors to the model
%offset = 2 * shiftLimit * (rand(size(iPoints)) - 0.5);
offset = [0 0 0; 1 1 1];
modParticle = ImodModel((iPoints - offset)');
write(modParticle, 'test.mod');

% Create the accurate motive list
motl = zeros(20, nPoints);
motl(1,:) = 1;
motl(4,:) = 1:nPoints;
motl(5,:) = 1;
motl([17 19 18], :) = euler' * 180 / pi;
tom_emwrite('test_MOTL.em', tom_emheader(motl));

outMotl = particleAlign3(mrcVolume, fullRef, modParticle, szFullRef, motl, ...
  [0], [0], 0, shiftLimit, 0, 0.866, 2);

avgVol = motlAverage3(mrcVolume, modParticle, szFullRef, outMotl, 0);

showMRCImage(avgVol(:,:,17));