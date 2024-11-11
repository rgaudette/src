%motlAverage5   Average the particles specified in a motive list accounting
%               for the missing tomographic wedge particle rotation 
%
%   [avgVol nAvg threshold idxSelected volSum maskSum] = motlAverage5( ...
%       volume, modParticle, szVol, motiveList,  threshold, ...
%       tiltRange, edgeShift, includeList, excludeList, selectClassID,...
%       meanFill, alignedBaseName, volSum, nAvg, maskSum, ...
%       flgDebugText, flgDebugGraphics)
%
%   avgVol      The average volume.
%
%   nAvg        The number of particles used in the average.
%
%   idxSelected The index of the selected particles.
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
%   meanFill    OPTIONAL: If any particles are partially out of the volume
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
%   flgDebugGraphics OPTIONAL: [0 1] Graphical debugging level
%
%
%   motlAverage5 computes the averaged volume using the set of rotations
%   and shifts specified in the motive list.
%
%   This version extracts a large enough volume so that rotations will not
%   cause extrapolation to the volume mean value.
%
%   Calls: imodPoints2Index, extractSubVolume, ImodContour.getPoints,
%          volRotateInvShift, MRCImage, getRotateSize, showMRCImage,
%          showMRCContour
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/19 22:11:31 $
%
%  $Revision: 1.12 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [avgVol nAvg threshold idxSelected volSum maskSum] = motlAverage5(...
  volume, modParticle, szVol, motiveList, threshold, ...
  tiltRange, edgeShift, includeList, excludeList, selectClassID, ...
  meanFill, alignedBaseName, volSum, nAvg, maskSum, ...
  debugLevel, flgDebugGraphics)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: motlAverage5.m,v 1.12 2005/08/19 22:11:31 rickg Exp $\n');
end

% Select an index at center of the volume or near it (even case) to
% represent the origin for rotation
idxOrigin = floor(szVol / 2) + 1;

% Calculate the necessary extracted volume size to allow for rotation
[szExtract idxExtractOrigin subX subY subZ] = getRotateSize(szVol, idxOrigin);
if nargin < 5
  threshold = 0;
end

if nargin < 7
  edgeShift = 0;
end

if nargin > 5
  wMask = wedgeMask(tiltRange, szExtract, 'Y', edgeShift);
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
  meanFill = 0;
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
  maskSum = zeros(szVol);
end

if nargin < 16
  debugLevel = 0;
end

if nargin < 17
  flgDebugGraphics = 0;
end

% Get the particle centers from the model
ptsParticles = imodPoints2Index(getPoints(modParticle, 1, 1));

if debugLevel > 0
  fprintf('Extracting a particle size of %d %d %d\n', szExtract);
end

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
        motiveList(4, idxParticle), motiveList(1, idxParticle));
      fprintf('phi %6.4f  theta %6.4f  psi %6.4f  ', ...
        motiveList([17 19 18], idxParticle)');
      fprintf('dx %6.4f  dy %6.4f dz %6.4f\n', ...
        motiveList(11:13, idxParticle)');
    end

    center = ptsParticles(:, idParticle);
    
    % Shift then rotate the particle.  The inverse transform used to create the
    % motive list is applied because the motive list was generated by
    % transforming the reference to the particle
    bigParticle = single(extractSubVolume(volume, center, szExtract, 0, meanFill));
    bigParticle = ...
      volumeShiftRotateInv(bigParticle, -motiveList([11 12 13], idxParticle)', ...
      motiveList([17 19 18], idxParticle)' * -pi / 180, idxExtractOrigin);

    particle = bigParticle(subX, subY, subZ);
    PARTICLE = fftshift(fftn(particle));
    if nargin > 5
      % TODO: Should the extrapolation value be 0 instead of the mean of
      % the volume ???!
      bigMask = volumeRotateInv(wMask, ...
        motiveList([17 19 18], idxParticle)' * -pi / 180, idxExtractOrigin, ...
        'linear', 0);
      rotMask = bigMask(subX, subY, subZ);
      maskSum = maskSum + rotMask;

      % Mask out the particle with the rotated wedge mask
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

    if flgDebugGraphics
      figure(1)
      clf
      colormap(gray(256))
      subplot(1,2,1)
      showMRCImage((abs(squeeze(PARTICLE(:, end/4, :)))));
      hold on
      showMRCContour(squeeze(rotMask(:, end/4, :)), [0.9], 'g')
      subplot(1,2,2)
      showMRCImage(log(abs(squeeze(PART_MASK(:, end/4, :)))));
      figure(2)
      clf
      colormap(gray(256))
      subplot(1,2,1)
      showMRCImage((abs(squeeze(PARTICLE(:, floor(end*2/3), :)))));
      hold on
      showMRCContour(squeeze(rotMask(:, floor(end*2/3), :)), [0.9], 'g')
      subplot(1,2,2)
      showMRCImage(log(abs(squeeze(PART_MASK(:, floor(end*2/3), :)))));
      figure(3)
      clf
      subplot(1,2,1)
      colormap(gray(256))
      partMask = real(ifftn(ifftshift(PART_MASK)));
      showMRCImage(partMask(:,:,end/2));
      subplot(1,2,2)
      colormap(gray(256))
      showMRCImage(squeeze(partMask(:,end/2,:)));
      drawnow
    end

end

nAvg = nSelected;
if nAvg > 0
  idxNonZero = maskSum > 0;
  avgVol = zeros(size(volSum));
  avgVol(idxNonZero)  = volSum(idxNonZero) ./ maskSum(idxNonZero);
  avgVol = real(ifftn(ifftshift(avgVol)));
  fprintf('Averaged %d particles\n\n', nAvg);
else
  warning('No particles exceeded the threshold of %f\n\n', ...
    threshold);
  avgVol = [];
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: motlAverage5.m,v $
%  Revision 1.12  2005/08/19 22:11:31  rickg
%  Comment fix
%
%  Revision 1.11  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.10  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.9  2005/07/12 20:10:04  rickg
%  ClassID, include and exclude lists implemented
%
%  Revision 1.8  2005/07/07 17:27:58  rickg
%  Comment fix
%
%  Revision 1.7  2005/05/12 23:05:35  rickg
%  Warning if threshold is greater than number of points
%
%  Revision 1.6  2005/03/29 04:26:20  rickg
%  Added incremental averaging
%
%  Revision 1.5  2005/03/24 05:07:21  rickg
%  help comment update
%
%  Revision 1.4  2005/03/04 22:54:59  rickg
%  Added debug text for extracted particle size
%
%  Revision 1.3  2005/03/03 18:45:20  rickg
%  Added optional meanFill capability
%  Added optional aligned file output capability
%
%  Revision 1.2  2005/02/18 23:50:04  rickg
%  Use getRotateSize
%
%  Revision 1.1  2005/02/11 00:15:46  rickg
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
%  Use volSum to prevent divide by zero errors
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
