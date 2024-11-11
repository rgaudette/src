function [idxLocalMin, tube] = ...
    findDyneinSearchPos(ax6, contourModel, referenceParticles, showPlot)

% Tunable parameters
tubeSearchDim = [40 40];  % Cross sectional area of the tube (pixels)
interpMethod = 'linear';
nAvgY = 13;
nAvgZ = 17;

scale = 14;
threshold = +4;

period = 23;
pixelShiftThresh = 7;

if nargin < 4
  showPlot = 0;
end

% Load in the dynein contour
modDynCont = ImodModel(contourModel);
dynContour = getPoints(modDynCont, 1, 1)';

% Load in the reference points
dynRefModel = ImodModel(referenceParticles);
dynRefPoints = getPoints(dynRefModel, 1, 1)';


% TEST only evaluate specified segments
%idxPoints = [4:7];
%if ~ isempty(idxPoints)
%  dynContour = dynContour(idxPoints, :);
%end

% Interpolate the data along the contour model
delta = [1 1 1];

[tube R yLoc zLoc] = ...
    interpTube(ax6, dynContour, delta, tubeSearchDim, interpMethod);
tube = tube - mean(tube(:));
idxTubeDynein = mapCart2Tube(dynContour, dynRefPoints) + 0.5;

% Compute the mean over Y and Z for each X to use a detection profile
idxYAvg = [-floor(nAvgY/2):floor(nAvgY/2)] + ceil(tubeSearchDim(1)/2);
idxZAvg = [-floor(nAvgZ/2):floor(nAvgZ/2)] + ceil(tubeSearchDim(2)/2);
meanTube = mean(mean(tube(:, idxYAvg, idxZAvg), 3), 2);
meanTube = meanTube - mean(meanTube);

figure(1)
clf
subplot(3,1,1)
colormap(gray(256))
xDim = size(tube, 1);
imagesc([1:xDim-1], yLoc, rot90(tube(:,:, ceil(tubeSearchDim(2)/2))));
axis('image');
hold on
plot(idxTubeDynein(:,1), idxTubeDynein(:,2), 'g+');
%title('X-Y slice')

subplot(3,1,2)
colormap(gray(256))
xDim = size(tube, 1);
imagesc([1:xDim-1], zLoc, rot90(squeeze(tube(:,ceil(tubeSearchDim(1)/2),:))));
axis('image');
hold on
plot(idxTubeDynein(:,1), idxTubeDynein(:,3), 'g+');
%title('X-Z slice')

subplot(3,1,3)
plot(meanTube)
set(gca, 'xlim', [1 length(meanTube)])
hold on
grid on
for i=1:size(idxTubeDynein,1)
  plot(idxTubeDynein(i,1)*[1 1] + 0.5, get(gca, 'ylim'), 'g');
end

%  Filter the profile to remove variance using a quadratic spline
%  wavelet
h = [0.1250 0.3750 0.3750 0.1250];
hFilt = 1;
for i = 1:scale
  hFilt = conv(hFilt, h);
end

% Known constraint filtering
% - use the fact that we know of an approximate spacing to enhance the signal
%constraint = [-1 zeros(1,8) ones(1,5) zeros(1,8) -1];
%hFilt = conv(constraint, hFilt)
%length(hFilt)



% Create a matched filter from the known Dynein
%mf = mean(mean(d1vol + d2vol + d3vol + d4vol + d5vol, 2), 3);
%mf = mf - mean(mf);
%mf = -mf ./ norm(mf);
%hFilt = conv(mf, hFilt);

meanFiltered = filter(hFilt, 1, meanTube);
filterShift = floor(length(hFilt)/2);
plot([1:length(meanFiltered)] - filterShift, meanFiltered, 'r')


% Find all of the local minima less than the threshold
clipped = meanFiltered;
clipped(meanFiltered > threshold) = threshold;
[values idxLocalMin] = dipsrch(clipped, 0);
idxLocalMin = idxLocalMin - filterShift;
idxLocalMinDiff = diff(idxLocalMin);
fprintf('Total mean: %f\n', mean(idxLocalMinDiff))
fprintf('Total std: %f\n', std(idxLocalMinDiff))
fprintf('Single period mean: %f\n', ...
        mean(idxLocalMinDiff(idxLocalMinDiff < period + pixelShiftThresh)));
fprintf('Single period std: %f\n', ...
        std(idxLocalMinDiff(idxLocalMinDiff < period + pixelShiftThresh)));

nLocalMin = length(idxLocalMin);
for i = 1:nLocalMin
%  plot(idxLocalMin(i)*[1 1], get(gca, 'ylim'), 'm')
end


% Constrained search
[pixDiff idxClosest] = min(abs(idxLocalMin -  idxTubeDynein(3,1)));

% Walk down to the bottom culling any to far out the range
lowerLocalMin = [];
lastGood = idxLocalMin(idxClosest);
inDomain = 1;
nCycles = 1;
while inDomain
  searchCtr = lastGood - (period * nCycles);
  % Find the peak that is closest to the next cycle center
  [shift idxMinShift] = min(abs(idxLocalMin - searchCtr));
  if shift < pixelShiftThresh
    nCycles = 1;
    lastGood = idxLocalMin(idxMinShift);
    lowerLocalMin = [lowerLocalMin lastGood];
  else 
    nCycles = nCycles + 1;
  end
  if searchCtr - (period * nCycles) + pixelShiftThresh < 1
    inDomain = 0;
  end
end

% Walk up to the top culling any to far out the range
upperLocalMin = [];
lastGood = idxLocalMin(idxClosest);
inDomain = 1;
nCycles = 1;
while inDomain
  searchCtr = lastGood + (period * nCycles);
  % Find the peak that is closest to the next 
  [shift idxMinShift] = min(abs(idxLocalMin - searchCtr));
  if shift < pixelShiftThresh
    nCycles = 1;
    lastGood = idxLocalMin(idxMinShift);
    upperLocalMin = [upperLocalMin lastGood];
  else
     nCycles = nCycles + 1;
  end
  if searchCtr + (period * nCycles) - pixelShiftThresh > max(idxLocalMin)
    inDomain = 0;
  end
end

idxLocalMin = [fliplr(lowerLocalMin) idxLocalMin(idxClosest) upperLocalMin];
idxLocalMinDiff = diff(idxLocalMin);
fprintf('Constrained\n');
fprintf('Total mean: %f\n', mean(idxLocalMinDiff))
fprintf('Total std: %f\n', std(idxLocalMinDiff))
fprintf('Single period mean: %f\n', ...
        mean(idxLocalMinDiff(idxLocalMinDiff < period + pixelShiftThresh)));
fprintf('Single period std: %f\n', ...
        std(idxLocalMinDiff(idxLocalMinDiff < period + pixelShiftThresh)));

nLocalMin = length(idxLocalMin);
for i = 1:nLocalMin
  plot(idxLocalMin(i)*[1 1], get(gca, 'ylim'), 'm')
end

