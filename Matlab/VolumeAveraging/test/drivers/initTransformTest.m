%initTransformTest
szVol = [256 256 100];
% Set the length to be odd so that particle is initially exactly aligned
% with the sampling grid
length = 19;
width = 1;
shiftLimit = 6
points = [...
  33 33 33
  100 100 38
  50 50 70
  szVol(1)-33 szVol(1)-33 33
  ];

nPoints = size(points, 1);
euler = [ 0 0 0
  45 45 45
  -30 60 -89
  -23 42 -5
  ] * pi / 180;

[volume reference] = testVolume(szVol, length, width, points, euler);

%  Add some noise to the volume to prevent divide by zero errors when
%  calculating the masked particle energy in particleAlign3
stdSignal = std(volume(:));
volume = volume + randn(size(volume)) * stdSignal * 1E-2;

% Map the limited reference volume to the full size typically used
szRef = size(reference);
szFullRef = [32 32 32];
fullRef = zeros(szFullRef);
refShift = floor((szFullRef - szRef) / 2) + 1;
fullRef(refShift(1)+[1:szRef(1)], ...
  refShift(2)+[1:szRef(2)], refShift(3)+[1:szRef(3)]) = reference;


mrcVolume = MRCImage(volume);
save(mrcVolume, 'transformTest.mrc');
save(MRCImage(fullRef), 'transformTest_InitRef.mrc');
% Offset the X & Y points to match IMOD
iPoints = points - repmat([0.5 0.5 1], size(points, 1), 1);
write(ImodModel(iPoints'), 'transformTrue.mod');