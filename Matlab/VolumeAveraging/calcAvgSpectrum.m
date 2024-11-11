function fSqMag = calcAvgSpectrum(volume, imodModel, szVol)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: calcAvgSpectrum.m,v 1.1 2005/10/25 17:22:33 rickg Exp $\n');
end

flgMeanFill = 1;
fSqMag = meanSquaredSpectrum(volume, imodModel, szVol, flgMeanFill);

function fSqMag = meanSquaredSpectrum(volume, imodModel, szVol, flgMeanFill)
% Get the region centers from the model
ptsCenter = imodPoints2Index(getPoints(imodModel, 1, 1));
nRegions = size(ptsCenter, 2);
fSqMag = zeros(szVol);
scale = 1/prod(szVol);
for iRegion = 1:nRegions
  fprintf('%d, ', iRegion);
  % Load in the region
  region = single(...
    extractSubVolume(volume, ptsCenter(:, iRegion), szVol, 0, flgMeanFill));
  regMean(iRegion) = mean(region(:));
  region = region - mean(region(:));

  % Compute the fourier transform
  REG = scale * fftn(region);
  REGSQ = REG .* conj(REG);
  % Average both the amplitude and the complex 
  fSqMag = fSqMag + fftshift(REGSQ);
end
fprintf('\n');
fSqMag = fSqMag ./ nRegions;
