%alignAndAverage   Align and average particle/regions in a MRCImage
%
%   alignAndAverage(...
%       fnVolume, fnModParticle, reference, refOrient, initMOTL, ...
%       szVol, fnOutput, listPhi, listTheta, listPsi, ...
%       searchRadius, lowCutoff, hiCutoff, CCMode, refThreshold, ...
%       tiltRange, edgeShift, flgWedgeWeight, lstThresholds, flgOutAllIter, ...
%       flgMeanFill, flgLargeRef, alignedBaseName, ssnr, debugLevel)
%
%   fnVolume    The filename of the MRC stack containing the full volume.
%
%   fnModParticle The filename of the Imod model containing the particle
%               points assumed to be in the first object and first contour.
%
%   reference   Reference identifier.
%                 * If it is a single value it should be the index the initial
%                   alignment transform structure, which indirectly indexes into
%                   the particle model.
%
%                 * If it is a string it should specify the name of an
%                   MRC Image stack that contains the reference volume.
%
%                  * If it is a double or single array it is assumed to contain
%                   the reference volume.
%
%   refOrient   The orientation of the reference or [] to use its
%               specfied orientation in the initial motive list.  The
%               reference is inverse order Euler rotated by this amount
%               before being used (radians).
%
%   initMOTL    A code specifying out to contstruct the initial motive
%               list:
%                 0: Set all rotational values to zero
%
%                 1: Use the particle model and reference index to
%                    intialize phi (rotation around the z axis), be sure
%                    the points are sorted along a direction of interest
%
%                 2: Use the particle model and reference index to intialize
%                    phi and theta (rotation around the z axis and x axis)
%
%                 3: Use the particle model and reference index to
%                    intialize a full set of Euler angles
%
%               or a string to specify the filename to load, must end in
%               1.em
%
%   szVol       The size of the average volume to generate.
%
%   fnOutput    The base filename to write the averages and motive lists.
%
%   listPhi     The offsets (degrees) to rotate the particle to search for the
%   listTheta   peak cross correlation coefficient.  Each list should be a
%   listPsi     cell array with the number of cells specfying the number of
%               iterations.
%
%   searchRadius  Specify the search radius (pixels in each dimension)
%               to limit the cross-correlation function search.  This
%               specifies spatial masks on the data and the cross-correlation
%               coefficient function.
%
%   lowCutoff   The low frequency cutoff for frequency domain filtering, set to
%               zero or less to not use any high pass filtering.  Supply a two
%               element vector to also specify the transition width.  For
%               example, [0.1 0.03] would specify a cutoff of 0.1 and
%               transition width of 0.03.  All units are in cycles per sample.
%               The default transition width is 0.1.
%
%   hiCutoff    The high frequency cutoff for the frequency domain filtering,
%               set to 0.866 or greater to not use any low pass filtering. This
%               has the same argument structure and defaults as lowCutoff.
%
%   CCMode      The cross correlation measure to use.
%                 0: Local energy normalized cross correlation
%
%                 1: True local cross-correlation coefficient
%
%   refThreshold  The threshold to used for computing the average reference
%               volume at each iteration.
%
%   tiltRange   The tilt range used to acquire the tilt series [min max].
%               This will account for the missing wedge in generating
%               averages.  A empty array, [], specifies not to account for the
%               missing wedge (and use more efficient space domain
%               averaging).
%
%   edgeShift   The number of pixels shift the edge of the wedge mask to ensure
%               that all of the frequency info is included.
%
%   flgWedgeWeight Apply the missing wedge weighting to the alignment step.
%
%   lstThresholds  The CCC thresholds (or number of particles) for
%               calculating the final set of averages.
%
%   flgOutAllIter  OPTIONAL: Compute the requested set of estimates at the end of
%               each iteration (default: 0).
%
%   flgMeanFill OPTIONAL: If any particles are partially out of the volume
%               fill with the mean of the existant data (default: 0).
%
%   flgLargeRef OPTIONAL: Force the reference to be large enough so that any
%               rotation does not result in extrapolation of the data.  If not
%               specfied (or null) then a large reference is generated when the
%               masked region is > 0.866 of the szVol size. 1 - force a large
%               reference, 0 - force the reference to be szVol
%
%   alignedBaseName OPTIONAL: The basename for the aligned particle MRC files
%               (default: '').
%
%   ssnr        OPTIONAL: If non-null compute the SSNR for each volume estimate
%               calculated.  This should be a structure with the following
%               fields
%                 freqShells: the upper limit of each frequency shell
%                 windowName: the type of the mask window to apply to the data
%                 windowParams: see ssnr3
%                 windowCenter: see ssnr3
%                 (default: [ ])
%
%
%   debugLevel  OPTIONAL: default: 0
%                    0 - no debug text, 
%                    1 - general function level messages
%                    2 - particle level messages
%                    3 - rotation angle level messages%
%
%   The parameters listPhi, listTheta, listPsi, searchRadius, and
%   refThreshold can be specified either as single objects, in which case
%   each iteration will use that value, or as a cell array where each
%   successive cell item will be used in successive iterations.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/19 22:14:12 $
%
%  $Revision: 1.33 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function alignAndAverage(...
  fnVolume, fnModParticle, reference, refOrient, initMOTL, ...
  szVol, fnOutput, listPhi, listTheta, listPsi, ...
  searchRadius, lowCutoff, hiCutoff, CCMode, refThreshold, ...
  tiltRange, edgeShift, flgWedgeWeight, lstThresholds, flgOutAllIter, ...
  flgMeanFill, flgLargeRef, alignedBaseName, ssnr, debugLevel)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: alignAndAverage.m,v 1.33 2005/08/19 22:14:12 rickg Exp $\n');
end

if nargin < 20
  flgOutAllIter = 0;
end

if nargin < 21
  flgMeanFill = 0;
end

if nargin < 23
  ssnr = [ ];
end

if nargin < 24
  alignedBaseName = '';
end

if nargin < 25
  debugLevel = 0;
end

debugLevel
% Default values
flgLoadVolume = 0;
includeList = [ ];
excludeList = [ ];
selectClassID = [ ];

% Figure out the number of iterations from the number of cell items 
nIterations = getNIterations(listPhi, listTheta, listPsi, searchRadius, ...
  refThreshold, lowCutoff, hiCutoff);
listPhi = fixListArg(listPhi, nIterations, 'listPhi');
listTheta = fixListArg(listTheta, nIterations, 'listTheta');
listPsi = fixListArg(listPsi, nIterations, 'listPsi');
searchRadius = fixListArg(searchRadius, nIterations, 'searchRadius');
refThreshold = fixListArg(refThreshold, nIterations, 'refThreshold');
lowCutoff = fixListArg(lowCutoff, nIterations, 'lowCutoff');
hiCutoff = fixListArg(hiCutoff, nIterations, 'hiCutoff');

% Open the MRCImage object and particle model
volume = MRCImage(fnVolume, flgLoadVolume);
modParticle = ImodModel(fnModParticle);
points = getPoints(modParticle, 1, 1);
nPoints = size(points, 2);

% Load in the reference if it is a string
if ischar(reference)
  mrcRef = MRCImage(reference);
  reference = getVolume(mrcRef);
end

%TODO: can this be more intelligent?
%FIXME: does not take into account non-centered maks
if nargin < 21 || isempty(flgLargeRef)
  flgLargeRef = 0;
  for i = 1:length(searchRadius)
    if any((2 * searchRadius{i}) ./ szVol  < 0.1340)
      flgLargeRef = 1;
    end
  end
end

% Calculate the necessary reference size
if flgLargeRef
  idxOrigin = floor(szVol / 2) + 1;
  szRef = getRotateSize(szVol, idxOrigin);
  if ndims(reference) == 3
    if ~ all(szRef == size(reference))
      fprintf('Expected reference size %d x %d x %d\n', szRef);
      fprintf('Supplied reference size %d x %d x %d\n', size(reference));
      error('Reference size is incorrect');
    end
  end
  refWedgeWeight = [ ];
else
  szRef = szVol;
  flgWedgeWeight = 0;
end
fnReference = [fnOutput '_Ref_'];


% Create or load the initial motive list
fnAlignBase = [fnOutput '_MOTL_'];
idxMLOffset = 0;
if ischar(initMOTL)
  idxExt = strfind(initMOTL, '.em');
  if isempty(idxExt) || idxExt < 2
    error('Can not parse initMOTL string: %', initMOTL);
  end
  idxUnder = strfind(initMOTL, '_');
  if ~ isempty(idxUnder) 
    strIndex = initMOTL(idxUnder(end)+1:idxExt-1);
    idxMLOffset = eval(strIndex);
  end
  motiveList = loadMOTL(initMOTL);
else
  fnAlign = [fnAlignBase '0.em'];
  switch initMOTL
    case 0
      motiveList = writeInitMOTL(1:nPoints, fnAlign);
    case 1
      if length(reference) > 1
        error('Reference must be an index into the initial alignment transform')
      end
      motiveList = imod2motl(modParticle, 1, 1, reference, 0);
      saveMOTL(motiveList, fnAlign);
    case 2
      if length(reference) > 1
        error('Reference must be an index into the initial alignment transform')
      end
      motiveList = imod2motl(modParticle, 1, 1, reference, 1);
      saveMOTL(motiveList, fnAlign);
    otherwise
      error('Unknown initial motive list (initMOTL) code');
  end
end    

% Loop over the angle increments zeroing in on the particle orientation and
% shift
for iteration = 1:nIterations
  % Get the iteration specific parameters from the input lists
  vDeltaPhi = listPhi{iteration};
  vDeltaTheta = listTheta{iteration};
  vDeltaPsi = listPsi{iteration};
  cSearchRadius = searchRadius{iteration};
  cRefThreshold = refThreshold{iteration};
  cLowCutoff = lowCutoff{iteration};
  cHiCutoff = hiCutoff{iteration};
  
  if debugLevel
    fprintf('\nIteration: %d\n', iteration);
    fprintf('Phi: ');
    fprintf('%6.2f ', vDeltaPhi);
    fprintf('\n');
    
    fprintf('Theta: ');
    fprintf('%6.2f ', vDeltaTheta);
    fprintf('\n');

    fprintf('Psi: ');
    fprintf('%6.2f ', vDeltaPsi);
    fprintf('\n');

    fprintf('Search radius: ');
    fprintf('%d ', cSearchRadius);
    fprintf('\n');

    fprintf('Reference threshold: ');
    fprintf('%6.2f ', cRefThreshold);
    fprintf('\n');

    fprintf('Low Cutoff: ');
    fprintf('%6.4f ', cLowCutoff);
    fprintf('\n');

    fprintf('HiCutoff: ');
    fprintf('%6.4f ', cHiCutoff);
    fprintf('\n');
  end

  % Search the rotation and translation space for the best correlation
  % coefficient
  switch CCMode
    case 0
      if debugLevel
        disp('Using local energy normalized cross correlation (LENCCS)')
      end
      [motiveList peakParams] = particleAlign3( ...
        volume, reference, refOrient, modParticle, szVol, ....
        motiveList, vDeltaPhi, vDeltaTheta, vDeltaPsi, cSearchRadius, ...
        cLowCutoff, cHiCutoff, flgLargeRef, flgMeanFill, debugLevel);
    case 1
      if flgWedgeWeight
        if debugLevel
          fprintf('Using missing wedge compensated local correlation');
          fprintf('coefficient (MWC-ENCCS)\n')
        end
        [motiveList peakParams] = particleAlign5( ...
          volume, tiltRange, edgeShift, reference, refOrient, ...
          refWedgeWeight, modParticle, szVol, motiveList, vDeltaPhi, ...
          vDeltaTheta, vDeltaPsi, cSearchRadius, cLowCutoff, cHiCutoff, ...
          flgLargeRef, flgMeanFill, debugLevel);
      else
        if debugLevel
          disp('Using local correlation coefficient sequence (LCCS)')
        end
        [motiveList peakParams] = particleAlign5( ...
          volume, [ ], edgeShift, reference, refOrient, ...
          [ ], modParticle, szVol, motiveList, vDeltaPhi, ...
          vDeltaTheta, vDeltaPsi, cSearchRadius, cLowCutoff, cHiCutoff, ...
          flgLargeRef, flgMeanFill, debugLevel);
      end
    otherwise
      error('Unknown CCMode code');
  end
  
  % Force refOrient to be null, we don't want to keep applying the
  % rotation
  refOrient = [ ];

  % Write out the peakParams if rotation level debugging is selected
  if debugLevel > 2
    save([fnOutput '_peakParams_' int2str(iteration) '.mat'], 'peakParams');
  end
  
  % Write out the updated motive list
  fnAlign = [fnAlignBase int2str(iteration + idxMLOffset) '.em'];
  tom_emwrite(fnAlign, tom_emheader(motiveList));
    
  % Generate the new average volume and use it for the reference for the next
  % iteration
  if debugLevel
    fprintf('\nGenerating new reference volume\n');
  end
  if isempty(tiltRange)
    [reference] = motlAverage3( ...
      volume, modParticle, szVol, motiveList, cRefThreshold, ...
      includeList, excludeList, selectClassID, flgMeanFill, '', ...
      [ ], 0, debugLevel);
  else
    [reference nAvgRef threshRef idxSelRef volSum maskSum] = motlAverage5( ...
      volume, modParticle, szRef, motiveList, cRefThreshold, ...
      tiltRange, edgeShift, includeList, excludeList, selectClassID, ...
      flgMeanFill, '', [ ], 0, [ ], ...
      debugLevel);
    
    if flgWedgeWeight
      refWedgeWeight = maskSum ./ nAvgRef;
      save(MRCImage(refWedgeWeight), ...
        [fnReference 'Weight_' int2str(iteration+1) '.mrc']);
    end
  end
  % Write out the reference volume
  save(MRCImage(reference), [fnReference int2str(iteration+1) '.mrc']);
  if debugLevel
    fprintf('\n');
  end

  if flgOutAllIter || iteration == nIterations
    % Compute the requested averages
    if length(lstThresholds) > 0
      if debugLevel
        fprintf('Computing requested average volumes\n');
      end

      nAverages = length(lstThresholds);
      fnAvgVol = [fnOutput '_AvgVol_'];
      avgVol = [];
      volSum = [];
      maskSum = [];
      nAvg = 0;
      fnEstimate = { };
      for iEst = 1:nAverages

        % Compute the selected output estimates
        if isempty(tiltRange)
          [avgVol nAvg threshold idxSelected] = motlAverage3( ...
            volume, modParticle, szVol, motiveList, lstThresholds(iEst), ...
            includeList, excludeList, selectClassID, flgMeanFill, alignedBaseName, ...
            avgVol, nAvg, debugLevel);
        else
          [avgVol nAvg threshold idxSelected volSum maskSum] = motlAverage5( ...
            volume, modParticle, szVol, motiveList, lstThresholds(iEst), ...
            tiltRange, edgeShift, includeList, excludeList, selectClassID, ...
            flgMeanFill, alignedBaseName, volSum, nAvg, maskSum, ...
            debugLevel);
          strNAvg = sprintf('%03d', nAvg);

          save(MRCImage(maskSum), ...
            [fnAvgVol 'maskSum' strNAvg '_' int2str(iteration) '.mrc']);
        end

        % Save the estimate to an MRC file
        strNAvg = sprintf('%03d', nAvg);
        fnEstimate{iEst} = [fnAvgVol strNAvg '_' int2str(iteration) '.mrc'];
        save(MRCImage(avgVol), fnEstimate{iEst});
      end
    end

    % If the ssnr structure is not empty compute the ssnr
    if ~ isempty(ssnr)
      % Copy the struct values to mathc calcSSNR output
      freqShells = ssnr.freqShells;
      windowName = ssnr.windowName;
      windowParams = ssnr.windowParams;
      windowCenter = ssnr.windowCenter;
      
      [arrSSNR arrNSSNR] = groupSSNR(volume, modParticle, motiveList, ...
        lstThresholds, fnEstimate, freqShells, windowName, windowParams, ...
        windowCenter, debugLevel);
      fnSSNR = [fnOutput '_SSNR_' int2str(iteration) '.mat'];
      save(fnSSNR, 'fnVolume', 'fnModParticle', 'fnAlign', 'motiveList', ...
        'lstThresholds', 'fnEstimate', 'freqShells', 'windowName', ...
        'windowParams', 'windowCenter', 'arrSSNR', 'arrNSSNR');
    end
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Local functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Search through the argument to figure out the number of iterations
function nIterations = getNIterations(varargin)
nArgs = length(varargin);
cntCellElements = zeros(nArgs, 1);
for iArg = 1:length(varargin)
  if iscell(varargin{iArg})
    cntCellElements(iArg) = length(varargin{iArg});
  else
    cntCellElements(iArg) = 1;
  end
end
nIterations = max(cntCellElements);
return



function argument = fixListArg(argument, nIterations, name)
% Make sure the argument is a cell array
if ~ iscell(argument)
  argument = {argument};
end
nArg = length(argument);
if nArg > 1
  if nArg ~= nIterations
    error('%s has %d items but the number of iterations is %d', ...
      name, nArg, nIterations);
  end
else
  argument = repmat(argument, nIterations, 1);
end
return  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: alignAndAverage.m,v $
%  Revision 1.33  2005/08/19 22:14:12  rickg
%  Implemented intermediate estimates and SSNR calculation
%
%  Revision 1.32  2005/08/18 21:51:07  rickg
%  Use align struct save abstraction
%
%  Revision 1.31  2005/08/17 15:13:34  rickg
%  Ensure that the peakParams file has .mat extension, really
%
%  Revision 1.30  2005/08/16 16:58:52  rickg
%  Ensure that the peakParams file has .mat extension
%
%  Revision 1.29  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.28  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.27  2005/07/12 20:10:04  rickg
%  ClassID, include and exclude lists implemented
%
%  Revision 1.26  2005/06/01 23:19:36  rickg
%  Comment fixes
%
%  Revision 1.25  2005/05/20 15:52:04  rickg
%  Added wedge weighting and large reference flags
%  Move argument processing up to make searchRadius available
%
%  Revision 1.24  2005/05/16 22:59:50  rickg
%  Uses particleAlign5 for both nonMWC and MWC LCCS calculations
%  Comment updates
%
%  Revision 1.23  2005/04/08 20:21:27  rickg
%  Fixed wedge weighting typo
%
%  Revision 1.22  2005/04/08 19:58:01  rickg
%  Added motive list name flexibility and peak parameter output
%
%  Revision 1.21  2005/04/04 22:25:52  rickg
%  Added refOrient to particleAlign3 call
%  Added incremental averaging to reference gen
%  and volume average generation.
%
%  Revision 1.20  2005/03/09 00:33:52  rickg
%  Wedge weight output name
%  Average volume var name fix
%
%  Revision 1.19  2005/03/04 00:31:11  rickg
%  Added missing wedge compensated alignment
%  Allow for individual filters for each iteration
%
%  Revision 1.18  2005/03/03 21:08:01  rickg
%  Fixed call to particleAlign?
%
%  Revision 1.17  2005/03/03 19:53:07  rickg
%  Added edgeShift, flgMeanFill and aligned file output
%
%  Revision 1.16  2005/02/18 23:48:44  rickg
%  Error checking fix for refThreshold
%
%  Revision 1.15  2005/02/11 00:20:20  rickg
%  Added edgeShift functionality
%
%  Revision 1.14  2005/02/10 19:34:54  rickg
%  Function name update
%
%  Revision 1.13  2005/01/21 21:42:29  rickg
%  Added separate iteration values for searchRadius and refThreshold
%
%  Revision 1.12  2005/01/14 18:31:29  rickg
%  Need to null refOrient after the first time through!
%
%  Revision 1.11  2005/01/14 00:29:34  rickg
%  Added reference orientation parameter
%
%  Revision 1.10  2004/12/15 00:55:20  rickg
%  Error checking
%
%  Revision 1.9  2004/12/08 23:33:10  rickg
%  Pass debug level to functions
%  Default parameters
%
%  Revision 1.8  2004/12/08 18:23:21  rickg
%  Actually compute missing wedge average when selected (instead of just
%  the reference)
%
%  Revision 1.7  2004/12/01 20:56:16  rickg
%  Added cross correlation mode and missing wedge compensation
%  Updated comments
%
%  Revision 1.6  2004/11/20 17:43:07  rickg
%  Initial revisionparticleAlign4.m
%
%  Revision 1.5  2004/11/08 05:30:40  rickg
%  Fixed 1/2 sample error in model to index mapping
%
%  Revision 1.4  2004/11/02 00:39:42  rickg
%  If the reference is a string load it as an MRC Image filename
%
%  Revision 1.3  2004/10/20 22:53:23  rickg
%  Added loading initMOTL from a file
%
%  Revision 1.2  2004/10/01 23:38:32  rickg
%  Added motivelist initialization from model option
%
%  Revision 1.1  2004/09/27 23:51:11  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
