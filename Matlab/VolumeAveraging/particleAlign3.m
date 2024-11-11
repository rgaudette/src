%particleAlign3  Align a series of particles with a reference
%
%   [motiveList, peakParams] = particleAlign3(...
%              volume, reference, refOrient, modParticle, szVol, motiveList, ...
%              vDeltaPhi, vDeltaTheta, vDeltaPsi, searchRadius,  ...
%              lowCutoff, hiCutoff, flgMeanFill, ...
%              debugTextLevel, flgDebugGraphics)
%
%   motiveList  The input and output motive lists.
%
%   peakParams  The full CCC results from the search (for debugging).
%
%   volume      The MRCImage object containing the full volume.
%
%   reference   Reference identifier.
%                 * If it is a single value it should be the index into particle
%                   model of the particle to use as an initial reference.
%
%                 * If it is an ImodModel object then the first point of the
%                   first contour of the first object is used as the center
%                   of the reference location.
%
%                 * If it is a double or single array it is assumed to contain
%                   the reference volume.
%
%   refOrient   The orientation of the reference or [] to use its
%               specfied orientation in the initial motive list.  The
%               reference is inverse order Euler rotated by this amount
%               before being used (radians).
%
%
%   modParticle The ImodObject contain the particle points.
%
%   szVol       The size of the average volume to generate.
%
%   vDeltaPhi   The offsets (degrees) to rotate the particle to search for the
%   vDeltaTheta peak cross correlation coefficient.
%   vDeltaPsi
%
%   srchRadius  Specify the search radius (pixels in each dimension) to limit
%               the cross-correlation function search.  This specifies spatial
%               masks on the data and the cross-correlation coefficient
%               function.
%
%   lowCutoff   The low frequency cutoff for frequency domain filtering, set to
%               zero or less to not use any high pass filtering.  Supply a two
%               element vector to also specify the transition width.  For
%               example, [0.1 0.03] would specify a cutoff of 0.1 and
%               transition width of 0.03.  All units are in cycles per sample.
%               The default transition width is 0.1.
%
%   hiCuttoff   The high frequency cutoff for the frequency domain filtering,
%               set to 0.866 or greater to not use any low pass filtering. This
%               has the same argument structure and defaults as lowCutoff.
%
%   flgLargeRef OPTIONAL: Use or extract a reference large enough so that
%               volume rotations will not result in extraploation (default: 0).
%
%   flgMeanFill OPTIONAL: If any particles are partially out of the volume
%               fill with the mean of the existant data (default: 0).
%
%   debugTextLevel  OPTIONAL: default: 0
%                    0 - no debug text, 
%                    1 - general function level messages
%                    2 - particle level messages
%                    3 - rotation angle level messages%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 2.5 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [motiveList, peakParams] = particleAlign3(...
  volume, reference, refOrient, modParticle, szVol, ...
  motiveList, vDeltaPhi, vDeltaTheta, vDeltaPsi, searchRadius, ...
  lowCutoff, hiCutoff, flgLargeRef, flgMeanFill, debugTextLevel)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: particleAlign3.m,v 2.5 2005/08/15 23:17:36 rickg Exp $\n');
end

stAlign = clock;

% Hard coded parameters
interpMethod = 'linear';

if nargin < 13
  flgLargeRef = 0;
end

if nargin < 14
  flgMeanFill = 0;
end

if nargin < 15
  debugTextLevel = 0;
end

peakParams = [];

% Get the particle centers from the point model and convert to a MATLAB
% array indices.  
ptsParticles = imodPoints2Index(getPoints(modParticle, 1, 1));
nParticles = size(motiveList, 2);
if debugTextLevel > 0
  fprintf('Examining %d particles\n', nParticles);
end

% Test the particle model to see if all of the to be examine particles are
% in the volume
if ~ flgMeanFill
  flgOutOfVolume = 0;
  for iParticle=1:nParticles
    idParticle = motiveList(4, iParticle);
    center = ptsParticles(:, idParticle);
    if ~ extractSubVolume(volume, center, szVol, 1)
      flgOutOfVolume = 1;
      fprintf('Particle %d at (%f,%f,%f) is out of the volume\n\n', ...
        idParticle, center(1), center(2), center(3));
    end
  end

  if flgOutOfVolume
    error('There are particles out of the volume');
  end
end

% Select an index at center of the volume or near it (even case) to
% represent the origin for rotation
idxOrigin = floor(szVol / 2) + 1;

% Calculate the necessary reference size to allow for rotation
if flgLargeRef
  [szRef refOrigin idxSelX idxSelY idxSelZ] = getRotateSize(szVol, idxOrigin);
else
  szRef = szVol;
  refOrigin = idxOrigin;
end
if debugTextLevel > 0
  fprintf('Using a reference size of %d %d %d\n', szRef);
end

% Extract the reference particle if necessary
idxReference = [];
if isa(reference, 'ImodModel')
  ptsReference = imodPoints2Index(getPoints(reference, 1, 1));
  cntReference = ptsReference(:, 1);
  reference = ...
    single(extractSubVolume(volume, cntReference, szRef, 0, flgMeanFill));

elseif isa(reference, 'double')
  if length(reference) > 1
    checkReferenceSize(szRef, size(reference));
    reference = single(reference);
  else
    % The reference parameter is an index into the point model (indirectly 
    % through the motiveList) of the particle to use as an initial reference
    idxReference = reference;
    cntReference = ptsParticles(:, motiveList(4, idxReference));
    reference = ...
      single(extractSubVolume(volume, cntReference, szRef, 0, flgMeanFill));
    if debugTextLevel
      fprintf('Initial reference particle %d (motiveList column %d)\n', ...
        motiveList(4, idxReference), idxReference);
    end
  end

% Leave reference data as is, warn if it is not the right size
elseif isa(reference, 'single')
  checkReferenceSize(szRef, size(reference));
else
  error('Unknown reference type %s\n', class(reference))
end

% Orient the reference volume as specified
if isempty(refOrient)
  if ~ isempty(idxReference)
    refOrient = motiveList([17 19 18], idxReference)' * pi / 180;
  else
    refOrient = [0 0 0];
  end
end
if debugTextLevel
  fprintf('Orienting for an initial reference rotation of ');
  fprintf('phi: %3.3f theta: %3.3f psi: %3.3f degrees\n', refOrient * 180 / pi);
end

% Remove the global mean of the reference and for the particle (below) to
% keep inner product at a reasonable value.  The local mean handling is later.
reference = reference - mean(double(reference(:)));

% Construct the correlation search radius mask
% ASSUME reference and test volumes are the same size as is the resulting
% cross correlation coefficient function
if length(searchRadius) == 1
  searchRadius = [1 1 1] * searchRadius;
end
imageMask = genMasks(szVol, searchRadius, idxOrigin, 'single');

% Compute the support after masking the reference
p_l = 1 + searchRadius;
p_h = szVol - searchRadius;

% Create the frequency domain filter if requested and shift it to match fftn
if lowCutoff > 0 | hiCutoff < 0.866
  flgFreqFilt = 1;
  fltBandpass = ifftshift(genBandpass(szVol, lowCutoff, hiCutoff));
else
  flgFreqFilt = 0;
end

% Loop over the particles to be analyzed
for iParticle = 1:nParticles
  stParticle = clock;
  idParticle = motiveList(4, iParticle);

  % Load in the particle of interest
  if debugTextLevel > 1
    fprintf('\nLoading particle %d (motiveList column %d)\n', ...
      idParticle, iParticle);
  end
  center = ptsParticles(:, idParticle);
  particle = single(extractSubVolume(volume, center, szVol, 0, flgMeanFill));
  particle = particle - mean(double(particle(:)));
  
  % Frequency domain filter it if required
  PARTICLE = fftn(particle);
  if flgFreqFilt
    PARTICLE = PARTICLE .* fltBandpass;
    particle = ifftn(PARTICLE);
  end
  cPARTICLE = conj(PARTICLE);
  cSSQ = conj(fftn(particle .^ 2));
  
  % Scan over the Euler angles
  %  Approximate rotation from refOrient and motiveList entry
  particleRotation = motiveList([17 19 18], iParticle) * pi / 180;
  centerRotation = eulerRotateSumInv1(-1 * refOrient, particleRotation);
  peakLENCCS = -1;
  iRotation = 0;

  %    phi_old = 5;
  %    angiter = ceil(length(vDeltaPhi) / 2);
  %    angincr = vDeltaPhi(2) - vDeltaPhi(1);
  %    for delPhi = [phi_old-angiter*angincr:angincr:phi_old+angiter*angincr]
  %      for delTheta = [0:ceil(angiter/2)]*angincr
  %        if delTheta == 0
  %          npsi=1;
  %          dpsi=0;
  %        else
  %          %sampling for psi and the on unit sphere in rings
  %          dpsi= angincr / sin(delTheta / 180 * pi);
  %          npsi = ceil(360/dpsi);
  %        end
  %        for delPsi = [0:(npsi-1)]*dpsi
  if debugTextLevel > 2
     fprintf('delPhi delTheta delPsi     Phi   Theta     Psi  ');
     fprintf('MaxCCC   ix   iy   iz\n');
  end

  for delPhi = vDeltaPhi
    for delTheta = vDeltaTheta
      for delPsi = vDeltaPsi
        iRotation = iRotation + 1;

        % Find the total rotation required converting the offset into radians
        delRotate = [delPhi delTheta delPsi] * pi / 180;
        totalRotation = eulerRotateSum(centerRotation, delRotate);

        if flgLargeRef
          % Rotate the reference particle, extracting the unextrapolated
          % region
          bigRotRef = volumeRotate(reference, totalRotation, refOrigin, ...
            interpMethod, 0);
          rotRef = bigRotRef(idxSelX, idxSelY, idxSelZ);
        else
          rotRef = volumeRotate(reference, totalRotation, refOrigin, ...
            interpMethod, 0);
        end
        
        % Region correlation masking
        rotRef = rotRef .* imageMask;

        % Bandpass filter the reference particle
        REFERENCE = fftn(rotRef);
        if flgFreqFilt
          REFERENCE = REFERENCE .* fltBandpass;
        end
          
        [lENCCS lr lc lp] = lenccs(REFERENCE, cPARTICLE, p_l, p_h, cSSQ);
        [maxLENCCS idxMaxLENCCS] = arraymax(lENCCS);
        maxLoc = [lr(idxMaxLENCCS(1)) lc(idxMaxLENCCS(2)) lp(idxMaxLENCCS(3))];
        
        if nargout > 1
          peakParams(iRotation, 1, iParticle) = maxLENCCS;
          peakParams(iRotation, 2:4, iParticle) = [delPhi delTheta delPsi];
          peakParams(iRotation, 5:7, iParticle) = totalRotation * 180 / pi;
          peakParams(iRotation, 8:10, iParticle) = -1 * maxLoc;
        end

        if debugTextLevel > 2
          fprintf('%6.1f  %6.1f  %6.1f  %6.1f  %6.1f  %6.1f  ', ...
            delPhi, delTheta, delPsi, totalRotation * 180 / pi);
          fprintf('%6.4f  %3d  %3d  %3d\n', maxLENCCS, -1 * maxLoc)
        end
        
        if maxLENCCS > peakLENCCS
          peakLENCCS = maxLENCCS;
          peakLoc = maxLoc;
          peakDelRotate = delRotate;
          [lPeakValue intPeakLoc] = peakInterp3(lr, lc, lp, lENCCS, ...
            peakLoc, 1, 0.02);
        end

      end % psi loop
    end % theta loop
  end % phi loop
  
  % Update the motive list: only include the particle rotation and the 
  motiveList(1, iParticle) = peakLENCCS;
  motiveList([11:13], iParticle) = -1 * intPeakLoc;
  motiveList([17 19 18], iParticle) = ...
    eulerRotateSum(particleRotation, peakDelRotate) * 180 / pi;
  
  if debugTextLevel > 1
    fprintf('Peak del  phi: %6.2f  theta: %6.2f  psi: %6.2f\n', ...
            peakDelRotate * 180 / pi)
    fprintf('Max CCC @ phi: %6.2f  theta: %6.2f  psi: %6.2f', ...
            motiveList([17 19 18], iParticle))
    fprintf('  CCC %f @ indices %6.2f %6.2f %6.2f\n', peakLENCCS, -1 * peakLoc)
    fprintf(' Interpolated shift %6.2f %6.2f %6.2f\n', -1 * intPeakLoc);
    fprintf('Particle alignment time: %f seconds\n', etime(clock, stParticle));
  end

end
  
if debugTextLevel
  fprintf('Alignment time: %f seconds\n', etime(clock, stAlign));
end

function checkReferenceSize(szRef, szData)
if ~ all(szRef == szData)
  fprintf('Supplied reference size %d %d %d\n', szData);
  fprintf('Required reference size %d %d %d\n', szRef);
  warning('The reference is not large enough to prevent extrapolation');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: particleAlign3.m,v $
%  Revision 2.5  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 2.4  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 2.3  2005/07/28 23:28:00  rickg
%  cSSQ needs to be supplied as the conj
%
%  Revision 2.2  2005/06/17 22:46:08  rickg
%  Missing semi and variable name bug
%
%  Revision 2.1  2005/05/19 20:40:30  rickg
%  Added large reference capability
%  Switched to lenccs implementation
%
%  Revision 2.0  2005/05/19 16:31:45  rickg
%  Help update
%  Added reference orientation
%  Added large reference functionality
%  Indirect indexing of reference through alignment structure
%  Removed central cube functionality
%  Added mean fill functionality
%  Index range calculations moved out of loop
%  Combine ref orient and particle rotation into a single rotation
%
%  Revision 1.10  2005/03/04 00:32:36  rickg
%  Updated debugging text
%
%  Revision 1.9  2005/03/03 19:52:22  rickg
%  Added optional meanFill capability
%
%  Revision 1.8  2004/12/15 00:56:36  rickg
%  No visible differences
%
%  Revision 1.7  2004/12/01 20:57:45  rickg
%  Updated comments
%
%  Revision 1.6  2004/11/08 23:51:55  rickg
%  Moved log to end of file
%  Simpler centerRotation assignment
%
%  Revision 1.5  2004/11/08 05:30:40  rickg
%  Fixed 1/2 sample error in model to index mapping
%
%  Revision 1.4  2004/11/07 19:55:47  rickg
%  Corrected for IMOD voxel indexing, added debug text
%
%  Revision 1.3  2004/11/02 00:37:19  rickg
%  Rotate reference if specified in the initial motive list
%
%  Revision 1.2  2004/10/05 20:37:03  rickg
%  Enhanced particle model scanning
%
%  Revision 1.1  2004/09/27 23:51:12  rickg
%  Initial revision
%
%  Revision 1.15  2004/09/22 03:55:30  rickg
%  Now only handles a single alignment iteration and does not compute
%  or save a next reference
%
%  Revision 1.14  2004/09/18 00:05:08  rickg
%  Comment clean up
%
%  Revision 1.13  2004/09/10 23:08:14  rickg
%  Switched to using single precision volumes
%
%  Revision 1.12  2004/09/10 04:34:55  rickg
%  Use peakInterp3
%  Print out shift indices for peak CCC
%
%  Revision 1.11  2004/09/07 23:29:38  rickg
%  Interpolated shift development
%
%  Revision 1.10  2004/09/04 05:22:03  rickg
%  rotate around specified orgin
%
%  Revision 1.9  2004/08/20 16:36:44  rickg
%  Added flag to control wedge masking
%
%  Revision 1.8  2004/08/20 03:55:27  rickg
%  Moved functions out, added indirect ref to particles
%
%  Revision 1.7  2004/08/18 23:38:15  rickg
%  Converted code sections to functions
%  Freq domain data now capitalized
%
%  Revision 1.6  2004/08/17 23:39:41  rickg
%  Switched to direct specification of the Euler angles
%
%  Revision 1.5  2004/08/17 22:59:16  rickg
%  Added flag to write out aligned particles
%  Fixed debugTextLevel check
%  Handle non cubic volumes by selecting the center cube
%  Remove mean from reference before rotating!
%  Switched to using volumeRotate
%
%  Revision 1.4  2004/08/06 22:17:15  rickg
%  Comments continued...
%  added text and graphics debug reporting
%  Fixed all normalizations including actually calculating the local
%  cross correlation coefficient
%  Fixed major bugs with respect to av3_scan_angles_exact
%  * mask reference AFTER removing the mean
%  * correct calculationg for euler sum
%  * don't mask the particle
%  * don't use the interpolated CCC to select best angles
%
%  Revision 1.3  2004/08/06 22:07:46  rickg
%  Changed from a spatial mask to a correlation search radius
%  Finished reference updating
%
%  Revision 1.2  2004/08/04 02:23:43  rickg
%  Initial revision
%
%  Revision 1.1  2004/07/30 03:53:52  rickg
%  In development
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
