%simMinNormDiff Simulate the Chip minimum normalized difference calculation
%
%  [minNormDiff heightToWidthRatio derivExtrema width sepStat] = ...
%    simMinNormDiff(profile, FOV, nSmooth, diffStep, cThresh, badList)
%
% Status: functional

function [minNormDiff, heightToWidthRatio, derivExtrema, width, sepStat] = ...
    simMinNormDiff(profile, FOV,  nSmooth, diffStep, cThresh, badList)

%%
%%  Trim the raw profiles to remove leading and trailing zeros
%%
trimProf = trimProfile(profile);

%%
%%  Approximate the derivatives
%%
diffProf = diffApprox(trimProf, nSmooth, diffStep);

%%
%%  Compute the pulse height-to-width ratios
%%
milsPerPixel = FOV / 1024;

[heightToWidthRatio derivExtrema width] = ...
    pulseHeightToWidthRatio(diffProf, cThresh, milsPerPixel);

%%
%%  Reshape the height-to-width ratio to match the 5DX output
%%
nProfs = size(heightToWidthRatio, 1);
if rem(nProfs, 4) ~= 0
  error('Expecting 4 profiles per pin');
end
hwrPerDevice = reshape(heightToWidthRatio', 8, nProfs / 4)';
%%
%%  Compute the minimum normalized difference from the mean HW
%%
minNormDiff = calcMinNormDiff(hwrPerDevice);

%%
%%  Reshape the min norm difference to index pins by row, this makes it a
%%  column vector
%%
minNormDiff = minNormDiff';
minNormDiff = minNormDiff(:);

%%
%%  If the good and bad are known return the separation statistics
%%
if nargin > 5
  sepStat.nPins = length(minNormDiff);
  idxGood = [];
  for iPin = 1:sepStat.nPins
    if ~any(iPin == badList)
      idxGood = [idxGood iPin];
    end
  end

  sepStat.meanGood = mean(minNormDiff(idxGood));
  sepStat.stdGood = std(minNormDiff(idxGood));
  sepStat.minGood = min(minNormDiff(idxGood));
  sepStat.maxBad = max(minNormDiff(badList));

  sepStat.margin = sepStat.minGood - sepStat.maxBad;
  sepStat.normMargin = sepStat.margin / sepStat.stdGood;
  sepStat.minNormDist = (sepStat.meanGood - sepStat.maxBad) / sepStat.stdGood;
end