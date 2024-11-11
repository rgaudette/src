%srsParticleVolume  Create a simulated step-ramp-sine particle volume 
%
%   [vol reference modParticle motiveList] = srsParticleVolume(...
%     szVol, length, width, pos, euler)
%
%   vol         The volume containing the test particles.
%
%   reference   A subvolume containing a single test particle centered in the
%               volume and in the same orientation as particle #1.
%
%   modParticle An IMOD model containing the location of the particle
%               centers.
%
%   motiveList  The correct motive list to orient the particles.
%
%
%   szVol    The size of the volume to generate.
%
%   length      The length of the step-ramp-sine functions
%
%   width       The widgth of the step-ramp-sine functions
%
%   pos         The position of each particle as a 3 x N array, where
%               N specifies the number of particles
%
%   orient      The orientation to go into the alignment structure, this
%               gets applied to the particles by eulerRotateInv( , -1 * orient).
%               This should also be 3 x N
%
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/18 23:20:41 $
%
%  $Revision: 1.8 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [vol reference modParticle motiveList] = srsParticleVolume( ...
  szVol, length, width, pos, orient)

global PRINT_ID
if PRINT_ID
  fprintf('$Id: srsParticleVolume.m,v 1.8 2005/08/18 23:20:41 rickg Exp $\n');
end
% Argument error checking
if size(pos, 1) ~= 3
  error('pos must be an 3 x N array');
end

if size(orient, 1) ~= 3
  error('orient must be an 3 x N array');
end

if size(orient, 2) ~= size(pos, 2)
  error('pos and orient must have the same number of columns');
end

% Create the empty volume
vol = zeros(szVol);

%  Loop over each position and rotation inserting the rotated particle into
%  the correct location
nParticles = size(pos, 2);

for iP = 1:nParticles
  fprintf('Creating particle %d\n', iP);
  % Make sure that sampling sub region totally captures the particle
  idxStart = floor(pos-length/2);
  
  % compute the indices in the volume the particle will occupy
  idxX = idxStart(1, iP):idxStart(1, iP)+length+1;
  idxY = idxStart(2, iP):idxStart(2, iP)+length+1;
  idxZ = idxStart(3, iP):idxStart(3, iP)+length+1;

  % compute the index values relative to the center
  subX = idxX - pos(1, iP);
  subY = idxY - pos(2, iP);
  subZ = idxZ - pos(3, iP);
  [volX volY volZ] = ndgrid(subX', subY, subZ);
  szSubVol = size(volX);
  arg = eulerRotateInv([volX(:)'; volY(:)'; volZ(:)'], -1 * orient(:, iP));

  % Generate the particle
  subVol = srsxyz(arg(1,:), arg(2,:), arg(3,:), length, width, [], [], []);
  subVol = reshape(subVol, szSubVol);
  
  % Add the particle into the volume
  vol(idxX, idxY, idxZ) = vol(idxX, idxY, idxZ) + subVol;

  if iP == 1
    reference = subVol;
  end
end

% Create the particle location model
modParticle = ImodModel(index2ImodPoints(pos));

% Create the motive list
motiveList = zeros(20, nParticles);
motiveList(1,:) = 1;
motiveList(4,:) = 1:nParticles;
motiveList(5,:) = 1;
motiveList([17 19 18], :) = orient * 180 / pi;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: srsParticleVolume.m,v $
%  Revision 1.8  2005/08/18 23:20:41  rickg
%  Added global print ID
%
%  Revision 1.7  2005/08/12 03:23:19  rickg
%  Removed tabs
%
%  Revision 1.6  2005/08/12 01:44:53  rickg
%  Added cvs id to output
%
%  Revision 1.5  2005/08/11 22:33:24  rickg
%  Restructure for simulation/test environment
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
