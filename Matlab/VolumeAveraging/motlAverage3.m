%motlAverage3   Average the particles specified in a motive list
%
%   [avgVol nAvg threshold idxSelected] = motlAverage3( ...
%     volume, modParticle, szVol, motiveList, threshold, ...
%     includeList, excludeList, selectClassID, flgMeanFill, alignedBaseName, ...
%     avgVol, nAvg, debugLevel)
%
%   avgVol      The average volume.
%
%   nAvg        The number of particles used in the average.
%
%   idxSelected The index of the selected particles.
%
%   volume      The MRCImage volume containing the sub volumes.
%
%   modParticle The ImodObject contain the particle points.
%
%   motiveList  The motivelist containing the rotations, shifts and CCC
%               values.
%
%   threshold   OPTIONAL: The minimum cross-correlation coefficient or the
%               number of particles to average if greater than 1.
%               (default: 0, include all particles).
%
%   includeList OPTIONAL: Consider only these particles when searching for
%               particles to average.  The set of particles to consider can be
%               further modified by the following two parameters (default: [ ]
%               do not apply this list).
%
%   excludeList OPTIONAL: Exclude these particle from being included in the
%               average regardless of their CCC (default: [ ] do not apply this
%               list).
%
%   selectClassID OPTIONAL: Consider only particles whose class ID matches one
%               of the values in this vector (default: [ ] do not apply this
%               list).
%
%   flgMeanFill OPTIONAL: If any particles are partially out of the volume
%               fill with the mean of the existant data (default: 0).
%
%   alignedBaseName OPTIONAL: The basename for the aligned particle MRC files
%               (default: '').
%
%   avgVol, nAvg  OPTIONAL The current average and number of particles for an
%               incremental average computation.  They both must be specfied if
%               avgVol is specified.
%
%   debugLevel  OPTIONAL: [0 1 2] Text debugging level
%
%   motlAverage3 computes the averaged volume using the set of rotations
%   and shifts specified in the motive list.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 22:55:50 $
%
%  $Revision: 1.13 $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [avgVol, nAvg, threshold, idxSelected] = motlAverage3(...
  volume, modParticle, szVol, motiveList, threshold, ....
  includeList, excludeList, selectClassID, flgMeanFill, alignedBaseName, ...
  avgVol, nAvg, debugLevel)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: motlAverage3.m,v 1.13 2005/08/15 22:55:50 rickg Exp $\n');
end

if nargin < 5
  threshold = 0;
end

if nargin < 6
  includeList = [ ];
end

if nargin < 7
  excludeList = [ ];
end

if nargin < 8
  selectClassID = [ ];
end

if nargin < 9
  flgMeanFill = 0;
end

if nargin < 10
  alignedBaseName = '';
end

if nargin < 11 || isempty(avgVol)
  avgVol = zeros(szVol);
else
  if nargin == 11
    error('Both avgVol and nAvg must be specified');
  end
  % Scale up the average by the number elements so that it can be appended to
  avgVol = avgVol * nAvg;
end

if nargin < 12 || isempty(nAvg)
  nAvg = 0;
end

if nargin < 13
  debugLevel = 0;
end

% Get the particle centers from the model
ptsParticles = imodPoints2Index(getPoints(modParticle, 1, 1));

% Select an index at center of the volume or near it (even case) to
% represent the origin for rotation
idxOrigin = floor(size(avgVol) / 2) + 1;

% Find the motive list entries that will be included and excluded in the average
if ~ isempty(includeList)
  motiveList = selectIncluded(motiveList, includeList);
end
if ~ isempty(excludeList)
  motiveList = deleteExcluded(motiveList, excludeList);
end
if ~ isempty(selectClassID) 
  motiveList = selectParticleClass(motiveList, selectClassID);
end

nParticles = size(motiveList, 2);
if threshold > nParticles
  disp('A threshold greater than the number of particles was supplied');
  warning('Using all particles.');
  threshold = nParticles;
end
idxSelected = findSelected(motiveList, threshold, debugLevel);

nSelected = length(idxSelected);

for iSelect = nAvg+1:nSelected
  idxParticle = idxSelected(iSelect);
  idParticle = motiveList(4, idxParticle);

  if debugLevel
    fprintf('Particle %d ID %d included CCC=%6.4f  ', idxParticle, ...
      idParticle, motiveList(1, idxParticle));
    fprintf('phi %6.4f  theta %6.4f  psi %6.4f  ', ...
      motiveList([17 19 18], idxParticle)');
    fprintf('dx %6.4f  dy %6.4f  dz %6.4f\n', ...
      motiveList(11:13, idxParticle)');
  end
  
  % Load in the particle of interest
  center = ptsParticles(:, idParticle);
  particle = single(extractSubVolume(volume, center, szVol, 0, flgMeanFill));

  % Shift then rotate the particle.  The inverse transform used to create the
  % motive list is applied because the motive list was generated by
  % transforming the reference to the particle
  particle = ...
    volumeShiftRotateInv(particle, -motiveList([11 12 13], idxParticle)', ...
    motiveList([17 19 18], idxParticle)' * -pi / 180, idxOrigin);

  avgVol = avgVol + particle;

  % Write out the particle as an MRCImage 
  if ~ isempty(alignedBaseName)
    fname = sprintf('%s_%03d.mrc', alignedBaseName, idParticle);
    save(MRCImage(particle), fname);
  end
end

nAvg = nSelected;
if nAvg > 0
  avgVol = avgVol ./ nAvg;
  fprintf('Averaged %d particles\n\n', nAvg);
else
  warning('No particles exceeded the threshold of %f\n\n', ...
          threshold);
  avgVol = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: motlAverage3.m,v $
%  Revision 1.13  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.12  2005/08/15 22:21:29  rickg
%  Added global print ID
%
%  Revision 1.11  2005/08/12 03:21:06  rickg
%  Comment updates
%  Added CVS ID
%
%  Revision 1.10  2005/07/12 20:10:04  rickg
%  ClassID, include and exclude lists implemented
%
%  Revision 1.9  2005/05/12 23:05:35  rickg
%  Warning if threshold is greater than number of points
%
%  Revision 1.8  2005/03/29 04:24:31  rickg
%  Comment update
%  Error report update
%
%  Revision 1.7  2005/03/27 17:45:48  rickg
%  Added incremental averaging
%
%  Revision 1.6  2005/03/03 18:45:05  rickg
%  Added optional flgMeanFill capability
%  Added optional aligned file output capability
%
%  Revision 1.5  2004/12/08 23:34:28  rickg
%  Debug text clean up
%
%  Revision 1.4  2004/12/01 01:06:44  rickg
%  Switch to volumeShiftRotateInv
%
%  Revision 1.3  2004/11/08 05:30:40  rickg
%  Fixed 1/2 sample error in model to index mapping
%
%  Revision 1.2  2004/09/29 06:29:18  rickg
%  Fixed navg=1
%
%  Revision 1.1  2004/09/27 23:51:12  rickg
%  Initial revision
%
%  Revision 1.11  2004/09/16 17:11:36  rickg
%  Added the ability to select the number of particles to average
%
%  Revision 1.10  2004/09/10 04:33:11  rickg
%  Combine rotate and shift in a single interpolation
%
%  Revision 1.9  2004/09/04 05:32:23  rickg
%  Specify idxOrigin as rotation origin
%
%  Revision 1.8  2004/08/30 21:58:33  rickg
%  Correctly handle particle index in MOTL
%
%  Revision 1.7  2004/08/24 17:56:16  rickg
%  return the number of particles averaged
%  return a null volume if no particles are averaged
%  ignore particle indices in the exclude list when
%  getting the volume size
%
%  Revision 1.6  2004/08/22 23:46:53  rickg
%  Print out number of particles averaged
%
%  Revision 1.5  2004/08/18 05:44:03  rickg
%  Updated help
%  Check input args
%
%  Revision 1.4  2004/08/17 22:36:02  rickg
%  Added excludeList and flgWriteAligned
%  Correct volume rotation direction
%
%  Revision 1.3  2004/08/12 23:06:33  rickg
%  Handle non double particles
%
%  Revision 1.2  2004/08/10 03:03:36  rickg
%  Fixed nargin typo
%
%  Revision 1.1  2004/08/06 22:18:27  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
