function simParticleVol_Template
testName = 'unnamed';

szVol = [256 256 100];

particle.genFunction = 'srsParticleVolume';
particle.length = 19;
particle.width = 3;
particle.count = 10;

% see randLoc
particle.dist = 20;

% The position of the particle centers in the volume.  This can be either a
% 3xN array where N <= particle.count or the string 'random'.  If
% N < particle.count then the remaining positions will be filled in randomly.
particle.pos = 'random';

particle.orient = [
  0 0 0
  pi/2 0 0
  -pi/2 0 0
  0 pi/2 0
  0 0 -pi/2  ]' ;
  
	save(testName);