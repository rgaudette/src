%procHWRatio    Process height-to-width ratio
%
%  procHWRatio(hwratio, badIndexList)
%
%  Status: under development, indexing needs to be fixed

function procHWRatio(hwratio, badIndexList)

if nargin < 2
  badIndexList = -1;
end

[nJoints nMeas] = size(hwratio); 
goodIndexList = [];

for i = 1:nJoints
  if ~any(i == badIndexList)
    goodIndexList = [goodIndexList i];
  end
end

%%
%%  Compute the average height-to-width ratio for each joint
%%  for the body spine, the pin spine and both together
%%
avgBodySpine1 = mean(hwratio(:, [1 2])');
avgBodySpine2 = mean(hwratio(:, [5 6])');

avgPinSpine1 = mean(hwratio(:, [3 4])');
avgPinSpine2 = mean(hwratio(:, [7 8])');

avgPinHW = [avgPinSpine1; avgPinSpine2];
avgPinHW = avgPinHW(:)

avgBodyHW = [avgBodySpine1; avgBodySpine2];
avgBodyHW = avgBodyHW(:)

avgBothHW = (avgPinHW + avgBodyHW) ./ 2

%%
%% Compute the mean over all joints to normalize
%%
meanAllPinHW = mean(avgPinHW(goodIndexList));
stdAllPinHW = std(avgPinHW(goodIndexList));

meanAllBodyHW = mean(avgBodyHW(goodIndexList));
stdAllBodyHW = std(avgBodyHW(goodIndexList));

meanAllBothHW = mean(avgBothHW(goodIndexList));
stdAllBothHW = std(avgBothHW(goodIndexList));

normPinHW = (avgPinHW - meanAllPinHW) ./ stdAllPinHW

normBodyHW = (avgBodyHW - meanAllBodyHW) ./ stdAllBodyHW

normBothHW = (avgBothHW - meanAllBothHW) ./ stdAllBothHW

