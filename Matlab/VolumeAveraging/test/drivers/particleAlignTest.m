nVol = 32;
fnReference = 'ref';
fnParticle = 'test';
fnMotivelist = 'testMOTL';
partEuler = [  2 0 0
  -3 0 0
  49 0 0
  -38 0 0
  123 0 0
  -167 0 0
  0 2 0
  0 -3 0
  0 49 0
  0 -38 0
  0 123 0
  0 -167 0 ];
srchRadius = floor(nVol/4);
partShift = (2*rand(12,3)-1) * (srchRadius-3);


%  Create the reference EM object
ref = zeros(nVol, nVol, nVol);
idxOrigin = floor(size(ref) / 2 ) + 1;
lx = floor(nVol/4);
ref(idxOrigin(1):idxOrigin(1)+lx-1, idxOrigin(2)+[-1 0 1], idxOrigin(3)+[-1 0 1]) = 1;
ly = floor(nVol/3);
ref(idxOrigin(1)+[-1 0 1], idxOrigin(2):idxOrigin(2)+ly-1, idxOrigin(3)+[-1 0 1]) = 1;
lz = floor(nVol/2);
ref(idxOrigin(1)+[-1 0 1], idxOrigin(2)+[-1 0 1], idxOrigin(3):idxOrigin(3)+lz-1) = 1;

tom_emwrite([fnReference '_1.em'], tom_emheader(ref));

%  Create the rotated and shifted particles
nParticles = size(partEuler, 1);
for iParticle = 1:nParticles
  part = volumeRotateShift(ref, partEuler(iParticle, :) * pi/180, ...
    partShift(iParticle, :), ...
    [], 'linear');
  tom_emwrite([fnParticle '_' int2str(iParticle) '.em'], tom_emheader(part));
end


% Create the Motive List 
motl = zeros(20, nParticles);
motl(1,:) = 1;
motl(4,:) = 1:nParticles;
motl(5,:) = 1;
motl([17 19 18], :) = partEuler';
tom_emwrite([fnMotivelist '_1.em'], tom_emheader(motl));


% angle search space
delPhi = -1:1:1;
delTheta = -1:1:1;
delPsi = 0;

%  Low pass cutoff needs to be low enough to smooth rotation aliasing ???
lowCutoff = 0.0
hiCutoff = 0.866
rngTilt = [-60 60]

flgUpdateRef = 1
threshold = 0;
nIterations = 1
flgDebugText = 2;
flgDebugGraphics = 0;
flgWriteAlign = 1
iAngle = 1;
st=clock;
peakParams = particleAlign(fnReference, fnMotivelist, fnParticle, ...
                             iAngle, ...
                             delPhi, delTheta, delPsi, ...
                             srchRadius, lowCutoff, hiCutoff, ...
                             rngTilt, ...
                             flgUpdateRef, threshold, nIterations, ...
                             flgDebugText, flgDebugGraphics, flgWriteAlign);
et = etime(clock,st);                           
save(['peakParams_' int2str(iAngle)], 'peakParams');

fprintf('\nTrue particle parameters\n')
for iParticle = 1:nParticles
  fprintf('Particle %d   ', iParticle);
  fprintf('phi %6.4f  theta %6.4f  psi %6.4f  ', partEuler(iParticle, :));
  fprintf('dx %6.4f  dy %6.4f dz %6.4f\n', partShift(iParticle, :));
end

% load in the new motive list
motl2 = getfield(tom_emread([fnMotivelist '_2.em']), 'Value');

fprintf('\nDifferences\n')
for iParticle = 1:nParticles
  fprintf('Particle %d   ', iParticle);
  if motl(18, iParticle) ~= 0
    diffPhi = partEuler(iParticle, 1) - motl(17, iParticle) - motl(18, iParticle);
    diffTheta = partEuler(iParticle, 1) + motl(19, iParticle);
  else
	  diffPhi = partEuler(iParticle, 1) - motl(17, iParticle);
    diffTheta = partEuler(iParticle, 1) - motl(19, iParticle);
  end
  fprintf('diffPhi %6.4f  diffTheta %6.4f  ', diffPhi, diffTheta);
  fprintf('dx %6.4f  dy %6.4f dz %6.4f\n', partShift(iParticle, :) - motl2(11:13, iParticle)');
end
