%calcSSNR_mce  Compute the spectral-signal-to-noise ratio for a set of averaged
%              particles
%
%   calcSSNR_mce(fnParameters)
%
%   fnParameters The name of the parameter file.  This should be MATLAB
%               evaluatable (i.e. each line of the file will be eval'd).
%               The parameters read from file are:
%
%     fnVolume = 'filename.mrc';
%     fnModParticle = 'particle.mod';
%     fnMotiveList = 'motiveList_MOTL_1.em';
%     fnParticles = 'particle_AvgVol_*mrc'
%     thresholds = [60]
%     freqShells = [0.025:0.025:0.5];
%     windowName = 'gaussian'
%     windowParams = [0.35 0.05]
%     windowCenter = [ ];
%     fnOutput = 'output_ssnr';
%     debugLevel = 2;
%
%   calcSSNR_mce calculate the SSNR
%
%   See also: 
%
%   Bugs: none known       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/28 17:20:07 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function retval = calcSSNR_mce(varargin)

global PRINT_ID

st = clock;
% Default values
freqShells = [0.025:0.025:0.5];
windowName = 'gaussian'
windowParams = [0.35 0.05];
windowCenter = [];
fnOutput = 'output_ssnr';

% Parse the parameter file
filename = varargin{1};
[fid msg] = fopen(filename, 'r');
if fid == -1
  error('% : %s\n', filename, msg);
end
parseVariableFile
if PRINT_ID
    fprintf('$Id: calcSSNR_mce.m,v 1.4 2005/08/28 17:20:07 rickg Exp $\n');
end

% Print out the values of the parameter file
if debugLevel > 0
  fprintf('Parameter file: %s\n', filename);
end

if debugLevel > 1
  fprintf('  fnVolume: %s\n', fnVolume);
  fprintf('  fnModParticle: %s\n', fnModParticle);
  fprintf('  fnMotiveList: %s\n', fnMotiveList);
  fprintf('  fnParticles: ');
  if ischar(fnParticles)
    fprintf('%s\n', fnParticles);
  else
    for iFile = 1:length(fnParticles)
      fprintf('%s ', fnParticles{iFile});
    end
  end
  fprintf('  thresholds: ');
  fprintf('%f ', thresholds);
  fprintf('\n');
  fprintf('  freqShells: ');
  fprintf('%f ', freqShells);
  fprintf('\n');
  fprintf('  windowName: %s\n', windowName);
  fprintf('  windowParams: ');
  fprintf('%f ', windowParams);
  fprintf('\n');
  fprintf('  windowCenter: %s\n');
  fprintf('%f ', windowCenter);
  fprintf('\n');
  fprintf('  fnOutput: %s\n', fnOutput);
  fprintf('  debugLevel: %d\n', debugLevel);
end

st = clock
% Load the input data
volume = MRCImage(fnVolume, 0);
imodParticle = ImodModel(fnModParticle);
motiveList = loadMOTL(fnMotiveList);

% Get the average volume filenames
if ischar(fnParticles)
  files = dir(fnParticles);
  for iFile = 1:length(thresholds)
    lstAvgVol{iFile} = files(iFile).name;
  end
else
  lstAvgVol = fnParticles;
end

% Execute the SSNR calculation
[arrSSNR arrNSSNR] = groupSSNR(volume, imodParticle, motiveList, ...
  thresholds, lstAvgVol, freqShells, windowName, windowParams, windowCenter, ...
  debugLevel);

save(fnOutput, 'fnVolume', 'fnModParticle', 'fnMotiveList', 'motiveList', ...
  'fnParticles', 'thresholds', 'lstAvgVol', 'freqShells', 'windowName', ...
  'windowParams', 'windowCenter', 'arrSSNR', 'arrNSSNR');

etime(clock, st)

if debugLevel > 0
  fprintf('Total execution time : %f seconds\n', etime(clock, st));
end

retval = 0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: calcSSNR_mce.m,v $
%  Revision 1.4  2005/08/28 17:20:07  rickg
%  changed default window and output filename
%
%  Revision 1.3  2005/08/15 23:20:16  rickg
%  Typo fix
%
%  Revision 1.2  2005/08/15 23:02:52  rickg
%  Added global print ID
%
%  Revision 1.1  2005/03/29 23:44:54  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
