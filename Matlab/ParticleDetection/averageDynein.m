function [avgParticle] = ...
    averageDynein(tube, dyneinPoints, volSize, threshCCC, peakCCC, flgShiftZ)

size(tube)
tubeIndexOffset = ceil(size(tube) / 2)
% if Y or Z volume size is zero compute the largest region possible
if volSize(2) == 0
  maxShift = max(abs(dyneinPoints(:,2)))
  volSize(2) = size(tube,2) - maxShift - 4
end

if volSize(3) == 0
  maxShift = max(abs(dyneinPoints(:,3)))
  volSize(3) = size(tube,3) - maxShift - 4
end


offsetLength = [-floor(volSize(1)/2):floor(volSize(1)/2)];
offsetWidth = [-floor(volSize(2)/2):floor(volSize(2))/2] + tubeIndexOffset(2)
offsetDepth = [-floor(volSize(3)/2):floor(volSize(3))/2] + tubeIndexOffset(3)

avgParticle = ...
    zeros(length(offsetLength), length(offsetWidth), length(offsetDepth));
nAvg = 0;
for j = 1:size(dyneinPoints, 1)
  idxLength = dyneinPoints(j, 1) + offsetLength;
  idxWidth = dyneinPoints(j, 2) + offsetWidth;
  idxDepth = dyneinPoints(j, 3) + offsetDepth;
  
  if all(idxLength > 1) & all(idxLength <= size(tube, 1))
    if peakCCC(j) > threshCCC
      avgParticle = avgParticle + tube(idxLength, idxWidth, idxDepth);
      nAvg = nAvg + 1;
    end
  end
end
avgParticle = avgParticle / nAvg;
