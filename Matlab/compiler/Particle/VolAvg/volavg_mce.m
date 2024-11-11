%volavg_mce        Driver for alignAndAverage
%
%   volavg_mce(fnParameters)
%
%
%   volavg_mce parses the given parameter file and runs alignAndAverage with
%   the supplied parameters
%
%   Bugs: none known       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/19 22:15:16 $
%
%  $Revision: 1.13 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function retVal = volavg_mce(varargin)

global PRINT_ID

st = clock;
% Default values
refOrient = [];
initMOTL = 0;
CCMode = 0;
tiltRange = [ ];
edgeShift = 0;
flgMeanFill = 0;
flgOutAllIter = 0;
flgLargeRef = [ ];
alignedBaseName = '';
flgWedgeWeight = 0;
ssnr = [ ];

% Parse the parameter file
filename = varargin{1};
[fid msg] = fopen(filename, 'r');
if fid == -1
  error('% : %s\n', filename, msg);
end
parseVariableFile
if PRINT_ID
    fprintf('$Id: volavg_mce.m,v 1.13 2005/08/19 22:15:16 rickg Exp $\n');
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
  reference
  refOrient
  initMOTL
  fprintf('  szVol: ')
  fprintf('%d ', szVol);
  fprintf('\n');
  fprintf('  fnOutput: %s\n', fnOutput);
  dPhi
  dTheta
  dPsi
  searchRadius
  lowCutoff
  hiCutoff
  fprintf('  CCMode: %d\n', CCMode);
  refThreshold
  fprintf('  tiltRange: ')
  fprintf('%f ', tiltRange);
  fprintf('\n');
  fprintf('  edgeShift %d\n', edgeShift);
  fprintf('  flgWedgeWeight %d\n', flgWedgeWeight);  
  fprintf('  lstThresholds: ');
  fprintf('%d ', lstThresholds);
  fprintf('\n');
  fprintf('  flgOutAllIter %d\n', flgOutAllIter);
  fprintf('  flgMeanFill %d\n', flgMeanFill);
  fprintf('  flgLargeRef %d\n', flgLargeRef);
  fprintf('  alignedBaseName %s\n', alignedBaseName);
  if ~ isempty(ssnr)
    fprintf('  ssnr.freqShells: ')
    fprintf('%f ', ssnr.freqShells);
    fprintf('\n');
    fprintf('  ssnr.windowName: %s\n', ssnr.windowName);
    fprintf('  ssnr.windowParams: ')
    fprintf('%f ', ssnr.windowParams);
    fprintf('\n');
    fprintf('  ssnr.windowCenter: ')
    fprintf('%f ', ssnr.windowCenter);
    fprintf('\n');
  end
  fprintf('  debugLevel: %d\n', debugLevel);
end

alignAndAverage(...
  fnVolume, fnModParticle, reference, refOrient, initMOTL, ...
  szVol, fnOutput, dPhi, dTheta, dPsi, ...
  searchRadius, lowCutoff, hiCutoff, CCMode, refThreshold, ...
  tiltRange, edgeShift, flgWedgeWeight, lstThresholds, flgOutAllIter, ...
  flgMeanFill, flgLargeRef, alignedBaseName, ssnr, debugLevel)

if debugLevel > 0
  fprintf('Total execution time : %f seconds\n', etime(clock, st));
end

retVal = 0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  $Log: volavg_mce.m,v $
%  Revision 1.13  2005/08/19 22:15:16  rickg
%  Implemented intermediate estimates and SSNR calculation
%
%  Revision 1.12  2005/08/15 23:20:16  rickg
%  Typo fix
%
%  Revision 1.11  2005/08/15 23:02:52  rickg
%  Added global print ID
%
%  Revision 1.10  2005/06/17 22:42:06  rickg
%  flgMeanFill backward compaitibility
%
%  Revision 1.9  2005/05/20 19:30:03  rickg
%  Fixed mean fill argument
%
%  Revision 1.8  2005/05/20 15:55:38  rickg
%  Added wedge weighting and large reference flags
%  Mean fill parameter name changed to flgMeanFill
%
%  Revision 1.7  2005/04/07 22:22:50  rickg
%  preserve on install
%  mce renaming
%
%  Revision 1.6  2005/03/09 00:31:59  rickg
%  Fixed frequency reporting when they are cells
%
%  Revision 1.5  2005/03/04 00:38:18  rickg
%  Added edgeShift, flgMeanFill and aligned file output
%
%  Revision 1.4  2005/01/21 21:42:29  rickg
%  Added separate iteration values for searchRadius and refThreshold
%
%  Revision 1.3  2005/01/14 18:24:17  rickg
%  Added reference orientation
%  Switch to parseVariableFile
%
%  Revision 1.2  2004/12/08 23:14:46  rickg
%  Cleaned up debugging output
%
%  Revision 1.1  2004/12/01 18:17:41  rickg
%  Initial revision
%
%  Revision 1.2  2004/10/01 23:39:45  rickg
%  Added motivelist initialization from model option
%  Better debug output
%
%  Revision 1.1  2004/09/27 23:51:12  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
