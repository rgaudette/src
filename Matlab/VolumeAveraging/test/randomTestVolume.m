%randomTestVolume  Create a random test volume particles
%
%   [vol reference modParticle motiveList] = ...
%     randomTestVolume(szVol, nParticles, length, width, bufferDist, orient)
%
%   vol         The three dimensional volume containing the randomly placed
%               particles.
%
%   reference   The reference volume.
%
%   modParticle An IMOD model containing the location of the particle
%               centers.
%
%   motiveList  The correct motive list to orient the particles.
%
%   szVol       The size of the volume to create
%
%   nParticles  The number of particles to place in the volume.
%
%   length      The length of each particle (see volStep...)
%
%   width       The support width of each particle (see volStep...)
%
%   bufferDist  The minimum amount of space between the particles, length +
%               bufferDist is passed to randLoc
%
%   orient      OPTIONAL: Orientation of the first N particles as
%               [Phi; Theta; Psi] x N in radians (default: []).
%
%   randomTestVolume creates 
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/02/16 03:50:58 $
%
%  $Revision: 1.5 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [vol, reference, modParticle, motiveList] = ...
  randomTestVolume(szVol, nParticles, length, width, bufferDist, orient)

if nargin < 6
  orient = [];
end

% Create the empty volume
vol = zeros(szVol);

% Create the empty particle locations
posParticle = [];
rotParticle = [];

% Loop over the number of particles
for iParticle = 1:nParticles
  fprintf('Creating particle %d\n', iParticle);
  pos = randLoc(szVol, length + bufferDist, posParticle);
  
  posParticle = [posParticle pos];

  % calculate the indices within the volume the particle might occupy and
  % the shifted coordinate system for origin based particle
  idxStart = floor(pos-length/2);
  idxX = idxStart(1):idxStart(1)+length+1;
  shiftX = idxX - pos(1);
  idxY = idxStart(2):idxStart(2)+length+1;
  shiftY = idxY - pos(2);
  idxZ = idxStart(3):idxStart(3)+length+1;
  shiftZ = idxZ - pos(3);
  [volX volY volZ] = ndgrid(shiftX', shiftY, shiftZ);
  szSubVol = size(volX);
  
  % Generate a random or specified rotation for instertion into the motiveList

  if iParticle <= size(orient, 2)
    rot = orient(:, iParticle);
  else
    rot = rand(3, 1) * pi * 2;
  end

  % Put the angle into cannonical form
  rot = eulerRotateSum(rot, [0 0 0]')';
  rotParticle = [rotParticle rot];
  
  % Since the motiveList specifies the rotation of reference necessary to align
  % particle we need to inverse rotate the current particle
  arg = eulerRotateInv([volX(:)'; volY(:)'; volZ(:)'], -1 * rot);
    
  % Create the particle sub volume
  subVol = srsxyz(arg(1,:), arg(2,:), arg(3,:), length, width, [], [], []);
  subVol = reshape(subVol, szSubVol);
  
  vol(idxX, idxY, idxZ) = vol(idxX, idxY, idxZ) + subVol;

end


% Create the reference particle
idxStart = floor(-length/2);
idx = idxStart:idxStart+length+1;
[volX volY volZ] = ndgrid(idx', idx, idx);
reference = srsxyz(volX, volY, volZ, length, width, [], [], []);

% Create the particle location model
modParticle = ImodModel(index2ImodPoints(posParticle));

% Create the motive list
motiveList = zeros(20, nParticles);
motiveList(1,:) = 1;
motiveList(4,:) = 1:nParticles;
motiveList(5,:) = 1;
motiveList([17 19 18], :) = rotParticle * 180 / pi;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: randomTestVolume.m,v $
%  Revision 1.5  2005/02/16 03:50:58  rickg
%  Help typo fix
%
%  Revision 1.4  2004/12/31 18:20:41  rickg
%  *** empty log message ***
%
%  Revision 1.3  2004/12/21 00:46:50  rickg
%  Added option orientation
%
%  Revision 1.2  2004/12/16 00:58:34  rickg
%  Comment updates
%
%  Revision 1.1  2004/11/30 01:54:23  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
