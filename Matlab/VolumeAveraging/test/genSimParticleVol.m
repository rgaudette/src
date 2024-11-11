%genSimParticleVol      Generate a simulated particle electron tomogram volume
%
%   genSimVol(paramFile)
%
%   paramFile   The name of the matlab file containing the simulation
%               parameters
%
%
%   genSimVol generates a simualted Electron Tomogram (ET) volume containing
%   the particle structures specified as well as the true alignment structure
%   and true reference volume.  See genSimParamTemplate.m for the structure of
%   the parameters.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/10/12 16:40:49 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function genSimParticleVol(paramFile)
global PRINT_ID
if PRINT_ID
  fprintf('$Id: genSimParticleVol.m,v 1.3 2005/10/12 16:40:49 rickg Exp $\n');
end

% Load in the parameter file
load(paramFile);
% Generate random positions and orientations if requested
particle.pos = ...
  parseParticlePos(particle.pos, particle.count, particle.dist, szVol);
particle.orient = parseParticleOrient(particle.orient, particle.count);

% Generate the test volume
switch particle.genFunction
  case 'srsParticleVolume'
    [vol reference modParticle motiveList] = srsParticleVolume(...
      szVol, particle.length, particle.width, particle.pos, particle.orient);
  otherwise
    error('Unknown volume generator function: %s', particle.genFunction);
end

% Add any offset to the data

% Apply the missing wedge

% Add specified noise

% Save the results
save(MRCImage(vol), [testName '.mrc']);
clear vol

save(MRCImage(reference), [testName '_InitRef.mrc']);
write(modParticle, [testName '_True.mod']);
tom_emwrite([testName '_MOTL_0.em'], tom_emheader(motiveList));


%%
%% Local functions
%%
function pos = parseParticlePos(pos, count, dist, szVol)
if ischar(pos)
  switch pos
    case 'random'
      pos = [ ];
      for iP = 1:count
        pos = [pos randLoc(szVol, dist, pos)];
      end
    otherwise
      error('Unknown pos string %s\n', pos);
  end
else
  np = size(pos, 2);
  if np < count
    for ip = (np+1):size(pos, 2)
      pos = randLoc(szVol, dist, pos);
    end
  end
end


function orient = parseParticleOrient(orient, count)
if ischar(orient)
  switch orient
    case 'random'
      orient = 2 * pi * rand(3, count);
    otherwise
      error('Unknown orient string %s\n', orient);
  end
else
  np = size(orient, 2);
  if np < count
    orient = [orient (2 * pi * rand(3, count - np))];
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: genSimParticleVol.m,v $
%  Revision 1.3  2005/10/12 16:40:49  rickg
%  Switched initial MOTL to 0
%
%  Revision 1.2  2005/08/12 03:26:11  rickg
%  Removed tabs
%  CVS ID
%
%  Revision 1.1  2005/08/11 22:32:48  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
