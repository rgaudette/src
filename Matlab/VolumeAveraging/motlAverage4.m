%motlAverage4   Average the particles specified in a motive list accounting
%               for the missing tomographic wedge
%
%   [avgVol nAvg threshold idxSelected volSum maskSum] = ...
%       motlAverage4(volume, modParticle, szVol, motiveList, threshold, ...
%       tiltRange, excludeList, volSum, nAvg, maskSum, alignedBaseName)
%
%   avgVol      The average volume.
%
%   nAvg        The number of particles used in the average.
%
%   idxSelected The index of the selected particles.
%
%   volSum      The unweighted sum of the particles in the Fourier domain
%
%   maskSum     The number of Fourier components included in the average at
%               each frequency.
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
%               (default: 0).
%
%   tiltRange   OPTIONAL: The minimum and maximum of the tilt axis.
%
%   edgeShift   OPTIONAL: The number of pixels shift the edge of the wedge
%               mask to ensure that all of the frequency info is included.
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
%
%   flgMeanFill OPTIONAL: If any particles are partially out of the volume
%               fill with the mean of the existant data (default: 0).
%
%   alignedBaseName OPTIONAL: The basename for the aligned particle MRC files
%               (default: '').
%
%   volSum      OPTIONAL The current volume sum, number of particles, and 
%   nAvg        maskSum for an incremental average computation.  They all must
%   maskSum     be specfied if volSum is specified.
%
%   debugLevel  OPTIONAL: [0 1 2] Text debugging level
%
%   motlAverage4 computes the averaged volume using the set of rotations
%   and shifts specified in the motive list.
%
%   This version adds compensation for the tomographic missing wedge, this is 
%   separate function because averaging is done in the frequency domain.
%
%   Calls: wedgeMask, imodPoints2Index, extractSubVolume, ImodContour.getPoints,
%          volRotateInvShift, volumeRotateInv, MRCImage
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.11 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [avgVol nAvg threshold idxSelected volSum maskSum] = motlAverage4(...
           volume, modParticle, szVol, motiveList, threshold, ...
           tiltRange, edgeShift, includeList, excludeList, selectClassID, ...
           flgMeanFill, alignedBaseName, volSum, nAvg, maskSum, ...
           debugLevel)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: motlAverage4.m,v 1.11 2005/08/15 23:17:36 rickg Exp $\n');
end

if nargin < 5
  threshold = 0;
end

if nargin < 7
  edgeShift = 0;
end

if nargin > 5
  wMask = wedgeMask(tiltRange, szVol, 'Y', edgeShift);
end

if nargin < 8
  includeList = [ ];
end

if nargin < 9
  excludeList = [ ];
end

if nargin < 10
  selectClassID = [ ];
end

if nargin < 11
  flgMeanFill = 0;
end

if nargin < 12
  alignedBaseName = '';
end

if nargin < 13 || isempty(volSum)
  volSum = zeros(szVol);
else
  if nargin < 15
    error('volSum, nAvg and maksSum must be specified together');
  end
end

if nargin < 14 || isempty(nAvg)
  nAvg = 0;
end

if nargin < 15 || isempty(maskSum)
  maskSum = zeros(size(wMask));
end

if nargin < 16
  debugLevel = 0;
end

% Get the particle centers from the model
ptsParticles = imodPoints2Index(getPoints(modParticle, 1, 1));

% Select an index at center of the volume or near it (even case) to
% represent the origin for rotation
idxOrigin = floor(size(volSum) / 2) + 1;

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
  
  % Load in the particle of interest
  if debugLevel
    fprintf('Particle %d ID %d included CCC=%6.4f  ', idxParticle, ...
      idParticle, motiveList(1, idxParticle));
    fprintf('phi %6.4f  theta %6.4f  psi %6.4f  ', ...
      motiveList([17 19 18], idxParticle)');
    fprintf('dx %6.4f  dy %6.4f dz %6.4f\n', ...
      motiveList(11:13, idxParticle)');
  end

  center = ptsParticles(:, idParticle);
  particle = single(extractSubVolume(volume, center, szVol, 0, flgMeanFill));

  % Shift then rotate the particle.  The inverse transform used to create the
  % motive list is applied because the motive list was generated by
  % transforming the reference to the particle
  particle = ...
    volumeShiftRotateInv(particle, -motiveList([11 12 13], idxParticle)', ...
    motiveList([17 19 18], idxParticle)' * -pi / 180, idxOrigin);
  PARTICLE = fftshift(fftn(particle));

  if nargin > 5
    rotMask = volumeRotateInv(wMask, ...
      motiveList([17 19 18], idxParticle)' * -pi / 180, idxOrigin);
    maskSum = maskSum + rotMask;
    PART_MASK = PARTICLE .* rotMask;
  else
    PART_MASK = PARTICLE;
  end

  volSum = volSum + PART_MASK;

  % Write out the particle as an MRCImage 
  if ~ isempty(alignedBaseName)
    particle = real(ifftn(ifftshift(PART_MASK)));
    fname = sprintf('%s_%03d.mrc', alignedBaseName, idParticle);
    save(MRCImage(particle), fname);
  end
end

nAvg = nSelected;
if nAvg > 0
  idxNonZero = maskSum > 0;
  avgVol = zeros(size(volSum));
  avgVol(idxNonZero) = volSum(idxNonZero) ./ maskSum(idxNonZero);
  avgVol = real(ifftn(ifftshift(avgVol)));
  fprintf('Averaged %d particles\n\n', nAvg);
else
  warning('No particles exceeded the threshold of %f\n\n', ...
    threshold);
  avgVol = [];
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: motlAverage4.m,v $
%  Revision 1.11  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.10  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.9  2005/07/12 20:10:04  rickg
%  ClassID, include and exclude lists implemented
%
%  Revision 1.8  2005/05/12 23:05:35  rickg
%  Warning if threshold is greater than number of points
%
%  Revision 1.7  2005/03/29 04:25:46  rickg
%  Comment updates
%
%  Revision 1.6  2005/03/28 23:29:06  rickg
%  Implemented incremental averaging
%
%  Revision 1.5  2005/03/09 00:34:25  rickg
%  Added mask sum output option
%
%  Revision 1.4  2005/03/04 22:54:26  rickg
%  Fixed default parameter dependency order
%
%  Revision 1.3  2005/03/03 18:45:13  rickg
%  Added optional flgMeanFill capability
%  Added optional aligned file output capability
%
%  Revision 1.2  2005/02/11 00:19:59  rickg
%  Added edgeShift functionality
%
%  Revision 1.1  2005/02/10 19:33:50  rickg
%  *** empty log message ***
%
%  Revision 1.7  2004/12/08 23:34:28  rickg
%  Debug text clean up
%
%  Revision 1.6  2004/12/01 20:57:20  rickg
%  Comment correction
%
%  Revision 1.5  2004/12/01 01:06:44  rickg
%  Switch to volumeShiftRotateInv
%
%  Revision 1.4  2004/11/09 06:11:15  rickg
%  Fixed mask that was applied to rotated particle
%
%  Revision 1.3  2004/11/09 01:10:56  rickg
%  Use accum to prevent divide by zero errors
%
%  Revision 1.2  2004/11/08 05:30:40  rickg
%  Fixed 1/2 sample error in model to index mapping
%
%  Revision 1.1  2004/11/02 00:37:29  rickg
%  Inital revision
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
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
