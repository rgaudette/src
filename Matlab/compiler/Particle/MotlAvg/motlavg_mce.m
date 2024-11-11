%motlavg_mce        Compute a volume average using an already calculated
%
%
%   motlavg_mce(fnParameters)
%
%   motlavg_mce computes the average volume of rotationally and translationally
%   aligned sub volumes within the MRC image stack fnvolume from the
%   transformations specified in the motiveList file
%
%   See also: motlAverage*
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:02:52 $
%
%  $Revision: 1.13 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function retval = motlavg_mce(varargin)

global PRINT_ID

st = clock;

% Default values
tiltRange = [ ];
flgLoadVolume = 0;
includeList = [ ];
excludeList = [ ];
selectClassID = [ ];
flgFullSubVolume = 0;
edgeShift = 0;
flgMeanFill = 0;
alignedBaseName = '';
fnWedgeWeight = '';

% Parse the parameter file
filename = varargin{1};
[fid msg] = fopen(filename, 'r');
if fid == -1
  error('% : %s\n', filename, msg);
end
parseVariableFile
if PRINT_ID
    fprintf('$Id: motlavg_mce.m,v 1.13 2005/08/15 23:02:52 rickg Exp $\n');
end

% Backward compatibility for parameters
if exist('meanFill') == 1
  flgMeanFill = meanFill;
end

% Print out the values of the parameter file
if debugLevel > 0
  fprintf('Parameter file: %s\n', filename);
end

if debugLevel > 1
  fprintf('  fnVolume: %s\n', fnVolume);
  fprintf('  fnModParticle: %s\n', fnModParticle);
  fprintf('  fnMotiveList: %s\n', fnMotiveList);
  fprintf('  szVol: ')
  fprintf('%d ', szVol);
  fprintf('\n');
  fprintf('  fnOutput: %s\n', fnOutput);
  fprintf('  lstThresholds: ');
  fprintf('%d ', lstThresholds);
  fprintf('\n');
  fprintf('  includeList: ');
  fprintf('%d ', includeList);
  fprintf('\n');
  fprintf('  excludeList: ');
  fprintf('%d ', excludeList);
  fprintf('\n');
  fprintf('  selectClassID: ');
  fprintf('%d ', selectClassID);
  fprintf('\n');
  fprintf('  tiltRange: ')
  fprintf('%f ', tiltRange);
  fprintf('\n');
  fprintf('  edgeShift: %d\n', edgeShift)
  fprintf('  flgMeanFill: %d\n', flgMeanFill);
  fprintf('  alignedBaseName: %s\n', alignedBaseName);
  fprintf('  fnWedgeWeight: %s\n', fnWedgeWeight);
  fprintf('  flgFullSubVolume: %d\n', flgFullSubVolume)
  fprintf('  debugLevel: %d\n', debugLevel);
end

volume = MRCImage(fnVolume, flgLoadVolume);
modParticle = ImodModel(fnModParticle);
motiveList = loadMOTL(fnMotiveList);

        
% Compute the requested averages
nAverages = length(lstThresholds);
fnAvgVol = [fnOutput '_AvgVol_'];
avgVol = [];
volSum = [];
maskSum = [];
nAvg = 0;
for iAverage = 1:nAverages
  if isempty(tiltRange)
    if flgFullSubVolume
      warning('Full sub-volume not yet implemented for motlAverage3');
    end
    [avgVol nAvg threshold idxSelected] = motlAverage3( ...
      volume, modParticle, szVol, motiveList, lstThresholds(iAverage), ...
      includeList, excludeList, selectClassID, flgMeanFill, alignedBaseName, ...
      avgVol, nAvg, debugLevel);
  else
    if flgFullSubVolume
      [avgVol nAvg threshold idxSelected volSum maskSum] = motlAverage5( ...
        volume, modParticle, szVol, motiveList, lstThresholds(iAverage), ...
        tiltRange, edgeShift, includeList, excludeList, selectClassID, ...
        flgMeanFill, alignedBaseName, volSum, nAvg, maskSum, ...
        debugLevel);
    else
      [avgVol nAvg threshold idxSelected volSum maskSum] = motlAverage4( ...
        volume, modParticle, szVol, motiveList, lstThresholds(iAverage), ...
        tiltRange, edgeShift, includeList, excludeList, selectClassID, ...
        flgMeanFill, alignedBaseName, volSum, nAvg, maskSum, ...
        debugLevel);
    end
    refWedgeWeight = maskSum ./ nAvg;

    if ~ isempty(fnWedgeWeight)
      strNAvg = sprintf('%03d', nAvg);
      save(MRCImage(refWedgeWeight), ...
           [fnWedgeWeight '_' strNAvg '.mrc']);
    end
  end

  strNAvg = sprintf('%03d', nAvg);
  save(MRCImage(avgVol), [fnAvgVol strNAvg '.mrc']);
end

if debugLevel > 0
  fprintf('Total execution time : %f seconds\n', etime(clock, st));
end

retval = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: motlavg_mce.m,v $
%  Revision 1.13  2005/08/15 23:02:52  rickg
%  Added global print ID
%
%  Revision 1.12  2005/08/15 22:20:59  rickg
%  Added global print ID
%
%  Revision 1.11  2005/07/12 20:10:43  rickg
%  ClassID, include and exclude lists implemented
%
%  Revision 1.10  2005/06/17 22:42:06  rickg
%  flgMeanFill backward compaitibility
%
%  Revision 1.9  2005/04/07 22:22:50  rickg
%  preserve on install
%  mce renaming
%
%  Revision 1.8  2005/03/29 04:31:54  rickg
%  Added incremental averaging
%
%  Revision 1.7  2005/03/09 00:31:18  rickg
%  Added wedge weight output option
%
%  Revision 1.6  2005/03/04 22:53:47  rickg
%  Added optional flgMeanFill and alignedBaseName capability
%
%  Revision 1.5  2005/02/25 23:28:36  rickg
%  Verbose print out of new parameters
%
%  Revision 1.4  2005/02/11 00:33:55  rickg
%  Added edgeShift functionality
%  Added full subvolume functionality
%
%  Revision 1.3  2005/01/14 18:30:17  rickg
%  Switch to parseVariableFile
%
%  Revision 1.2  2004/12/08 23:13:51  rickg
%  Cleaned up output, added debug text flag
%
%  Revision 1.1  2004/12/08 21:59:24  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
