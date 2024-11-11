%fairReference_mce  Compute an unbiased reference from a group of particles
%
%   fairReference_mce(fnParameters)
%
%   fnParameters The name of the parameter file.  This should be MATLAB
%               evaluatable (i.e. each line of the file will be eval'd).
%               The parameters read from file are:
%
%     fnVolume = 'filename.mrc';
%     fnModParticle = 'particle.mod';
%     select = 8;
%     fnMotiveList = 'motiveList_MOTL_1.em';
%     szVol = [64 64 64];
%     fnOutput = 'output';
%     vPhi = [-180:15:179];
%     vTheta = [0:15:45];
%     vPsi = [-170:15:179];
%     searchRadius = 10;
%     lowCutoff = 0;
%     hiCutoff = 0.867;
%     debugLevel = 2;
%
%   fairReference_mce computes a reference volume from the specified
%   particles or a randomly selected set, either of which must be a power
%   of 2.
%
%   See also: fairReference
%
%   Bugs: none known       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:20:16 $
%
%  $Revision: 1.6 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function retval = fairReference_mce(varargin)

global PRINT_ID

st = clock;
% Default values
fnMotiveList = [];

% Parse the parameter file
filename = varargin{1};
[fid msg] = fopen(filename, 'r');
if fid == -1
  error('% : %s\n', filename, msg);
end
parseVariableFile
if PRINT_ID
    fprintf('$Id: fairReference_mce.m,v 1.6 2005/08/15 23:20:16 rickg Exp $\n');
end

% Print out the values of the parameter file
if debugLevel > 0
  fprintf('Parameter file: %s\n', filename);
end

if debugLevel > 1
  fprintf('  fnVolume: %s\n', fnVolume);
  fprintf('  fnModParticle: %s\n', fnModParticle);
  fprintf('  select: ')
  fprintf('%d ', select);
  fprintf('\n');
  fprintf('  fnMotiveList: %s\n', fnMotiveList);
  fprintf('  szVol: ')
  fprintf('%d ', szVol);
  fprintf('\n');
  fprintf('  fnOutput: %s\n', fnOutput);
  vPhi
  vTheta
  vPsi
  fprintf('  searchRadius: %d\n', searchRadius);
  fprintf('  lowCutoff: %f\n', lowCutoff);
  fprintf('  hiCutoff: ')
  fprintf('%f ', hiCutoff);
  fprintf('\n');
  fprintf('  debugLevel: %d\n', debugLevel);
end

st = clock
% Load the input data
volume = MRCImage(fnVolume, 0);
imodParticle = ImodModel(fnModParticle);
motiveList = [];
if ~ isempty(fnMotiveList)
  motiveList = loadMOTL(fnMotiveList);
end

% Run the fairReference algorithm
[reference select eulerOffset strcTransform] = ...
  fairReference(volume, imodParticle, select, motiveList, szVol, ...
  vPhi, vTheta, vPsi, searchRadius, lowCutoff, hiCutoff, debugLevel);

% save the reference to an MRC file and everything to a .mat file
save(MRCImage(reference), [fnOutput '.mrc']);
save(fnOutput);

etime(clock, st)

if debugLevel > 0
  fprintf('Total execution time : %f seconds\n', etime(clock, st));
end

retval = 0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  $Log: fairReference_mce.m,v $
%  Revision 1.6  2005/08/15 23:20:16  rickg
%  Typo fix
%
%  Revision 1.5  2005/08/15 23:02:52  rickg
%  Added global print ID
%
%  Revision 1.4  2005/04/07 22:22:50  rickg
%  preserve on install
%  mce renaming
%
%  Revision 1.3  2005/01/29 00:32:42  rickg
%  Update parameter display
%
%  Revision 1.2  2005/01/14 18:29:53  rickg
%  Switch to parseVariableFile
%
%  Revision 1.1  2005/01/07 22:08:16  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
