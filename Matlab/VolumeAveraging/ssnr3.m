%ssnr3          3D Spectral signal-to-noise ratio
%
%   [ssnr nSamples] = ...
%      ssnr3(vol, modParticle, motiveList, threshold, avgVol, fShells)
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
%   threshold   The minimum cross-correlation coefficient or the
%               number of particles to average if greater than 1.
%
%   avgVol      The average to compare to the individual volumes.
%
%   fShells     The upper frequency limit of each shell, in discrete
%               frequency units.
%
%   windowName  OPTIONAL: A string with name of the window to apply to the 
%               volume data.  It can either be the name to be used with window
%               (see help window in MATLAB) or 'gaussian' to specify using
%               gaussianMask (default:'gaussian').
%
%   winParams   OPTIONAL: The parameters to pass to the window function.
%               For a gaussian window the parameters are [radius sigma] see
%               gaussianMask.  
%
%   winCenter   OPTIONAL: The center of the mask window (default: [ ], the
%               volume center)
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/10/12 16:36:15 $
%
%  $Revision: 1.14 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ssnr nSamples] = ssnr3(vol, modParticle, motiveList, threshold, ...
  avgVol, fShells, windowName, winParams, winCenter, flgDebugText)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: ssnr3.m,v 1.14 2005/10/12 16:36:15 rickg Exp $\n');
end

% Default values
meanFill = 1;

if nargin < 7
  flgWindow = 0;
else
  flgWindow = 1;
end

szVol = size(avgVol);
if nargin < 9 || isempty(winCenter)
  winCenter = floor(szVol / 2) + 1;
end

if nargin < 10
  flgDebugText = 0;
end

% Remove the mean
avgVol = avgVol - mean(double(avgVol(:)));

% Create the selected data window
if flgWindow == 1
  switch windowName
    case 'gaussian'
      win = gaussianMask(szVol, winParams(1), winParams(2), winCenter);

    otherwise
      if isempty(winParams)
        winX = eval(['window(@' winName ', ' int2str(szVol1(1)), ')' ]);
        winY = eval(['window(@' winName ', ' int2str(szVol1(2)), ')' ]);
        winZ = eval(['window(@' winName ', ' int2str(szVol1(3)), ')' ]);
      else
        winX = eval(['window(@' winName ', ' int2str(szVol(1)), ', ' ...
          num2str(winParams) ')' ]);
        winY = eval(['window(@' winName ', ' int2str(szVol(2)), ', ' ...
          num2str(winParams) ')' ]);
        winZ = eval(['window(@' winName ', ' int2str(szVol(3)), ', ' ...
          num2str(winParams) ')' ]);
      end
      [hX hY hZ] = ndgrid(winX', winY, winZ);
      win = hX .* hY .* hZ;
  end

  % Window the average volume
  avgVol = win .* avgVol;
end

% Compute the Fourier transform of the average volume
AVGVOL = fftn(avgVol);
nrgNoise = zeros(szVol);

% Get the particle centers from the model
ptsParticles = imodPoints2Index(getPoints(modParticle, 1, 1));
nParticles = size(motiveList, 2);

% If the threshold is > 1 sort the cross correlation coefficient to find
% the appropriate threshold
if threshold >= 1
  CCCsort = sort(motiveList(1,:), 2, 'descend');
  threshold = CCCsort(threshold) - eps;
  fprintf('Using threshold: %f\n', threshold);
end

% Select an index at center of the volume or near it (even case) to
% represent the origin for rotation
idxOrigin = floor(size(avgVol) / 2) + 1;

idxSelected = [];
nAvg = 0;

for idxParticle = 1:nParticles
  idParticle = motiveList(4, idxParticle);

  idxSelected(end+1) = idxParticle;
  if motiveList(1, idxParticle) > threshold
    % Load in the particle of interest
    if flgDebugText
      fprintf('\nLoading particle %d\n', idParticle);
    end
    center = ptsParticles(:, idParticle);
    particle = single(extractSubVolume(vol, center, szVol, 0, meanFill));
    particle = particle - mean(double(particle(:)));
    
    % Recall that the MOTL has the Euler angles in a strange order
    % Shift then rotate the particle.  The inverse transform used to create the
    % motive list is applied because the motive list was generated by
    % transforming the reference to the particle
    particle = ...
      volumeShiftRotateInv(particle, -motiveList([11 12 13], idxParticle)', ...
      motiveList([17 19 18], idxParticle)' * -pi / 180, idxOrigin);

    if flgWindow == 1
      particle = particle .* win;
    end
    PARTICLE = fftn(particle);
    
    NOISE = PARTICLE - AVGVOL;
    nrgNoise = nrgNoise + NOISE .* conj(NOISE);
    nAvg = nAvg + 1;
  end

end
if nAvg > 1
  nrgNoise = nrgNoise ./ (nAvg - 1);
end

% Compute the energy in the radial regions
nrgSignal = fftshift(AVGVOL .* conj(AVGVOL));
nrgNoise = fftshift(nrgNoise);

nX = szVol(1);
nY = szVol(2);
nZ = szVol(3);
fX = ([0:nX-1] - floor(nX / 2)) / nX;
fY = ([0:nY-1] - floor(nY / 2)) / nY;
fZ = ([0:nZ-1] - floor(nZ / 2)) / nZ;

[arrFX arrFY arrFZ] = ndgrid(fX', fY, fZ);

fMag = sqrt(arrFX.^2 + arrFY.^2 + arrFZ.^2);
nShells = length(fShells);
fscc = zeros(nShells, 1);
nSamples = zeros(nShells, 1);
fLow = [0 fShells(1:end-1)];
for iShell = 1:nShells
  % Find the samples in the current shell
  idxShell = (fMag >= fLow(iShell)) & (fMag < fShells(iShell));
  idxShell = idxShell(:);
  shellSignal = nrgSignal(idxShell);
  shellNoise = nrgNoise(idxShell);
  
  % Compute the ratio of the 
  ssnr(iShell) = sum(shellSignal) / sum(shellNoise) * nAvg;
  if ssnr(iShell) > 1
    ssnr(iShell) = ssnr(iShell) - 1;
  else
    ssnr(iShell) = eps;
  end
  nSamples(iShell) = sum(idxShell);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: ssnr3.m,v $
%  Revision 1.14  2005/10/12 16:36:15  rickg
%  Comment updates
%  window handling
%
%  Revision 1.13  2005/08/23 02:51:19  rickg
%  Remove the particle means (DC bleed through)
%
%  Revision 1.12  2005/08/19 22:11:53  rickg
%  Comment fix
%
%  Revision 1.11  2005/08/15 23:17:37  rickg
%  Type fix
%
%  Revision 1.10  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.9  2005/08/12 01:59:07  rickg
%  Fixed dimension in z
%
%  Revision 1.8  2005/03/29 23:40:35  rickg
%  Added window center argument
%
%  Revision 1.7  2005/03/24 05:02:18  rickg
%  added mean file to extract
%
%  Revision 1.6  2005/01/29 00:37:40  rickg
%  Added gaussian window
%  Still need to add others
%
%  Revision 1.5  2004/12/01 01:06:45  rickg
%  Switch to volumeShiftRotateInv
%
%  Revision 1.4  2004/11/17 00:30:13  rickg
%  Added hamming window capability
%  No need for szVol
%
%  Revision 1.3  2004/11/11 01:00:35  rickg
%  Rotate/shift incoming particle
%  fftshift spectra
%
%  Revision 1.2  2004/11/08 20:46:08  rickg
%  Inital revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%