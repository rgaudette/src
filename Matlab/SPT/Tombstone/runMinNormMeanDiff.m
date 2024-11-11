%runMinNormMeanDiff
%  [margin, normMargin, minNormDist] = ...
%    runMinNormMeanDiff(profile, FOV, badList)
%
%  Status: functional

function [margin, normMargin, minNormDist] = ...
    runMinNormMeanDiff(profile, FOV, badList)

vSmooth = [1:16];
nSmooth = length(vSmooth);
vDiffStep = [1:20];
nDiffStep = length(vDiffStep);
vThresh = [0.1:0.1:0.9];
nThresh = length(vThresh);
margin = zeros(nSmooth, nDiffStep, nThresh);
normMargin = zeros(nSmooth, nDiffStep, nThresh);
minNormDist = zeros(nSmooth, nDiffStep, nThresh);
for iThresh = 1:nThresh
  for iDiffStep = 1:nDiffStep
    for iSmooth = 1:nSmooth
      [minNormDiff, heightToWidthRatio, derivExtrema, width, sepStat] = ...
          simMinNormMeanDiff(profile, FOV, vSmooth(iSmooth), ...
                             vDiffStep(iDiffStep), vThresh(iThresh), badList);
      margin(iSmooth, iDiffStep, iThresh) = sepStat.margin;
      normMargin(iSmooth, iDiffStep, iThresh) = sepStat.normMargin;
      minNormDist(iSmooth, iDiffStep, iThresh) = sepStat.minNormDist;
    end
  end
end
