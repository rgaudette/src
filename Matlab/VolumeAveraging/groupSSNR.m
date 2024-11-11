%groupSSNR  Compute the Spectra signal-to-noise ratio for a  group volumes
%
%   [arrSSNR, arrNSSNR] = groupSSNR(vol, modParticle, motiveList, ...
%       lstThreshold, lstAvgVol, fShells, flgDebugText)
%
%   ssnr        The spectral signal-to-noise ratio
%
%   nSamples    The number of samples used for each shell
%
%   vol         The MRCImage containing the unaveraged subvolumes
%
%   modParticle The ImodObject contain the particle points.
%
%   motiveList  The motive list containing the rotations, shifts and CCC
%               values.
%
%   lstThreshold   The list of threshold values to use for selecting raw
%               images
%
%   lstAvgVol   The list of average to compare to the individual volumes.
%               This is a cell array containing a list of filenames.
%
%   fShells     The upper frequency limit of each shell, in discrete
%               frequency units.
%
%   windowName  OPTIONAL: The name of the window to apply to the volume data.
%               'gaussian' (default)
%
%   winParams   OPTIONAL: The parameters to pass to the window generation function.
%               For a gaussian window the parameters are [radius sigma] see
%               gaussianMask.
%
%   winCenter   OPTIONAL: The center of the mask window (default: volume center)
%
%
%   Calls: ssnr3
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.8 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [arrSSNR, arrNSSNR] = groupSSNR(vol, modParticle, motiveList, ...
  lstThreshold, lstAvgVol, fShells, windowName, windowParams, winCenter, ...
  flgDebugText)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: groupSSNR.m,v 1.8 2005/08/15 23:17:36 rickg Exp $\n');
end

if nargin < 10
  flgDebugText = 0;
end

% Loop over each threshold / average volume pair
nAvgVols = length(lstThreshold);
nShells = length(fShells);
arrSSNR = zeros(nShells, nAvgVols);
arrNSSNR = zeros(nShells, nAvgVols);
for iAvgVol = 1:nAvgVols
  if flgDebugText
    fprintf('Loading %s\n', lstAvgVol{iAvgVol});
  end
  threshold = lstThreshold(iAvgVol);
  avgVol = getVolume(MRCImage(lstAvgVol{iAvgVol}));
  [arrSSNR(:, iAvgVol) arrNSSNR(:, iAvgVol)] = ssnr3(vol, modParticle, ...
    motiveList, threshold, avgVol, fShells, windowName, windowParams, ...
    winCenter, flgDebugText);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: groupSSNR.m,v $
%  Revision 1.8  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.7  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.6  2005/03/29 23:40:35  rickg
%  Added window center argument
%
%  Revision 1.5  2005/03/24 05:04:05  rickg
%  help comments
%
%  Revision 1.4  2005/01/29 00:37:56  rickg
%  Window arg passthru
%
%  Revision 1.3  2004/11/17 00:29:28  rickg
%  No need for szVol
%
%  Revision 1.2  2004/11/11 01:03:16  rickg
%  function name fix
%
%  Revision 1.1  2004/11/08 20:46:22  rickg
%  Inital revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
