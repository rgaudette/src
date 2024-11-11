%calcNoiseStats Calculate the average radial spectrum of the specifed regions
%
%   [snr cumSNR nSamples shellSignal shellNoise] = ...
%  calcNoiseStats(volume, modNoiseRegions, modSignalRegions, szVol, fShells, ...
%  tiltRange)
%
%   snr         The SNR ratio as a function of the specfied shells
%
%   cumSNR      The cumulative SNR starting from the lowest freqeuncy to the
%               highest.  The sum is done over the squared signal magnitude in
%               each shell (signal energy).  The sqrt of the ratio is taken so
%               the ratio is in standard deviation terms.
%
%  
function [snr cumSNR nSamples shellSignal shellNoise] = ...
  calcNoiseStats(volume, modNoiseRegions, modSignalRegions, szVol, fShells, ...
  tiltRange)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: calcNoiseStats.m,v 1.5 2005/08/15 23:17:36 rickg Exp $\n');
end

if ischar(volume)
  volume = MRCImage(volume, 0);
end

% Loop over each noise region computing the average spectrum
fprintf('Averaging noise regions...');
fSqMagNoise = meanSquaredSpectrum(volume, modNoiseRegions, szVol);
fprintf('done\n');

% Loop over each signal region computing the average spectrum
fprintf('Averaging signal regions...');
fSqMagSignal = meanSquaredSpectrum(volume, modSignalRegions, szVol);
fprintf('done\n');

nX = szVol(1);
nY = szVol(2);
nZ = szVol(3);
fX = ([0:nX-1] - floor(nX / 2)) / nX;
fY = ([0:nY-1] - floor(nY / 2)) / nY;
fZ = ([0:nZ-1] - floor(nZ / 2)) / nZ;

[arrFX arrFY arrFZ] = ndgrid(fX', fY, fZ);

fMag = sqrt(arrFX.^2 + arrFY.^2 + arrFZ.^2);
wMask = wedgeMask(tiltRange, szVol, 'Y');
nShells = length(fShells);
fscc = zeros(nShells, 1);
nSamples = zeros(nShells, 1);
fLow = [0 fShells(1:end-1)];
for iShell = 1:nShells
  % Find the samples in the current shell
  idxShell = (fMag >= fLow(iShell)) & (fMag < fShells(iShell)) ...
    & wMask ;
  idxShell = idxShell(:);
  nSamples(iShell) = sum(idxShell);  
  shellNoise(iShell) = sum(fSqMagNoise(idxShell));
  shellSignal(iShell) = sum(fSqMagSignal(idxShell));
  
  % Compute the ratio of the 
  snr(iShell) = sqrt(shellSignal(iShell) / shellNoise(iShell));
  if snr(iShell) > 1
    snr(iShell) = snr(iShell) - 1;
  else
    snr(iShell) = eps;
  end
end

cumSNR = cumsum(shellSignal) ./ cumsum(shellNoise) - 1;
cumSNR(cumSNR < 0) = eps;

function fSqMag = meanSquaredSpectrum(volume, imodModel, szVol)
% Get the region centers from the model
ptsCenter = imodPoints2Index(getPoints(imodModel, 1, 1));
nRegions = size(ptsCenter, 2);
fSqMag = zeros(szVol);
scale = 1/prod(szVol);
for iRegion = 1:nRegions
  % Load in the region
  region = single(extractSubVolume(volume, ptsCenter(:, iRegion), szVol));
  regMean(iRegion) = mean(region(:));
  region = region - mean(region(:));
  
  % Compute the fourier transform
  REG = scale * fftn(region);
  REGSQ = REG .* conj(REG);
  % Average both the amplitude and the complex 
  fSqMag = fSqMag + fftshift(REGSQ);
end
fSqMag = fSqMag ./ nRegions;

