%randLoc        Compute a random non-overlapping location for a particle.
%
%   pos = randLoc(szVol, dist, posParticles, nTrials, flgInteger)
%
%   pos         A random location not currently occupied by a particle.
%
%   szVol       The size of the volume.
%
%   dist        The minimum distance between particle centers, dist/2 is
%               also the minimum to the volume boundary
%
%   posParticles  The position of the current particles (3xN).
%
%   nTrials     The maximum number of trials before deciding a free
%               location can't be found and throwing an error
%               (default: 1000)
%
%   flgInteger  OPTIONAL: Restrict the particle locations to integer values
%               (default: 0)
%
%
%   randLoc returns a uniformly distributed random location within the
%   range (dist/2+1 szVol-dist/2) for each dimension.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/03/02 22:42:29 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pos = randLoc(szVol, dist, posParticles, nTrials, flgInteger)

if nargin < 4
  nTrials = 1000;
end
if nargin < 5
  flgInteger = 0;
end
if flgInteger
  error('Integer positions not yet implemented');
end

szVol = szVol(:);

% First time through, just pick a point making sure it is not too close to
% the boundary
nParticles = size(posParticles, 2);
if nParticles == 0
  range = szVol - dist - 1;
  pos = rand(3,1) .* range + dist/2 + 1;
  return
end

pos = [];
iTrial = 0;
while iTrial < nTrials
  range = szVol - dist - 1;
  testPos = rand(3,1) .* range + dist/2 + 1;
  distArray = posParticles - repmat(testPos, 1, nParticles);
  distTest = sqrt(sum(distArray .^ 2));
  
  if all(distTest > dist)
    pos = testPos;
    break
  end
end

if isempty(pos)
  error('Unable to find a free location in %d trials', nTrials);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: randLoc.m,v $
%  Revision 1.2  2005/03/02 22:42:29  rickg
%  Calculation simplification
%
%  Revision 1.1  2004/11/30 01:54:23  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
