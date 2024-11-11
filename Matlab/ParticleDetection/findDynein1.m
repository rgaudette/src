% Test script for dynein detection

% Tunable parameters
idxPoints = [3:6]
tubeSearchDim = [25 25];
interpMethod = 'nearest';
nAvgY = 13;
nAvgZ = 11;

scale = 8
threshold = -0.25;

dyneinDim = 10   
xSearchDist = [-15:15];

%ax6Model = ImodModel('ax6.mod');
%ax6points = getPoints(ax6Model, 1, 1)';
%ax6DyneinPos = getPoints(ax6Model, 1, 2)';

ax6points = dyneinContour1
ax6DyneinPos = ax6D1pts

% Load in the data if is is not already loaded

if exist('ax6', 'var') ~= 1
  ax6 = MRCImage('ax6flipped.byte')
end


% TEST only evaluate 2 segments
if ~ isempty(idxPoints)
  ax6points = ax6points(idxPoints, :);
end

% Interpolate the data along the contour model
delta = [1 1 1];

[tube R yLoc zLoc] = ...
    interpTube(ax6, ax6points, delta, tubeSearchDim, interpMethod);
tube = tube - mean(tube(:));
idxTubeDynein = mapCart2Tube(ax6points, ax6DyneinPos) + 0.5;

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

subplot(3,1,2)
colormap(gray(256))
xDim = size(tube, 1);
imagesc([1:xDim-1], zLoc, rot90(squeeze(tube(:,ceil(tubeSearchDim(1)/2),:))));
axis('image');
hold on
plot(idxTubeDynein(:,1), idxTubeDynein(:,3), 'g+');


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


%  Extract the templates

dynLength = [-dyneinDim:dyneinDim];
dynWidth =  [-dyneinDim:dyneinDim];
dynDepth =  [-dyneinDim:dyneinDim];

tubeOffset = (tubeSearchDim/2);
tubeOffset = floor(tubeOffset);

% d1vol = tube(floor(idxTubeDynein(1,1) + dynLength), ... 
%              floor(idxTubeDynein(1,2) + tubeOffset(1) + dynWidth), ...
%              floor(idxTubeDynein(1,3) + tubeOffset(2) + dynDepth));

% d2vol = tube(floor(idxTubeDynein(2,1) + dynLength), ...
%              floor(idxTubeDynein(2,2) + tubeOffset(1) + dynWidth), ...
%              floor(idxTubeDynein(2,3) + tubeOffset(2) + dynDepth));

d3vol = tube(floor(idxTubeDynein(3,1) + dynLength), ...
             floor(idxTubeDynein(3,2) + tubeOffset(1) + dynWidth), ...
             floor(idxTubeDynein(3,3) + tubeOffset(2) + dynDepth));

% d4vol = tube(floor(idxTubeDynein(4,1) + dynLength), ...
%              floor(idxTubeDynein(4,2) + tubeOffset(1) + dynWidth), ...
%              floor(idxTubeDynein(4,3) + tubeOffset(2) + dynDepth));

% d5vol = tube(floor(idxTubeDynein(5,1) + dynLength), ...
%              floor(idxTubeDynein(5,2) + tubeOffset(1) + dynWidth), ...
%              floor(idxTubeDynein(5,3) + tubeOffset(2) + dynDepth));

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

nLocalMin = length(idxLocalMin)
for i = 1:nLocalMin
  plot(idxLocalMin(i)*[1 1], get(gca, 'ylim'), 'm')
end

% Compte a cross covariance function in the region around each local min



%  Compute the number of samples to shift from the center of the tube and the
%  min Index
%
%  WARNING This has been verified only for odd numbers of samples in both
%  in both the both the tube and the template volume.
%
%  idxCC? maps a shift index in the cross correlation output to a index in
%  the tube
nDomainCCX = floor(length(xSearchDist)/2) - dynLength(end);
nDomainCCY = floor(tubeSearchDim(1)/2) - dynWidth(end);
idxCCY = [-nDomainCCY:nDomainCCY] + ceil(tubeSearchDim(1)/2);
nDomainCCZ = floor(tubeSearchDim(2)/2) - dynDepth(end);
idxCCZ = [-nDomainCCZ:nDomainCCZ] + ceil(tubeSearchDim(2)/2);

idxDynein = [];
avgLength = [-19:19];
avgWidth = dynWidth;
avgDepth = 1:tubeSearchDim(2);
avgDynein = zeros(length(avgLength), length(avgWidth), length(avgDepth));
drawnow

j = 0;
for i = 1:nLocalMin
  fprintf('%d: ', i);
  xSearchRegion = round(idxLocalMin(i) + xSearchDist);

  %  Be sure that we have enough data around the min point to cross correlate
  %  the region
  if (xSearchRegion(1) > 0) & (xSearchRegion(end) <= size(tube,1))
    j = j + 1;
    idxCCX = [-nDomainCCX:nDomainCCX] + idxLocalMin(i);
    searchVol = tube(xSearchRegion, :, :);
    ccVol = corrcoef3d(searchVol, d3vol, 'valid');
    [valMax(j) idxMax] = max(ccVol(:));
    [xShift(j) yShift(j) zShift(j)] = ind2sub(size(ccVol), idxMax);
    idxDynein(j, :) = [idxCCX(xShift(j)) ...
                       idxCCY(yShift(j)) ...
                       idxCCZ(zShift(j)) ];
    fprintf('%f  ', valMax(j));
    figure(2)
    subplot(2,1,1)
    imagesc(idxCCX, idxCCY, rot90(ccVol(:,:, zShift(j))))
    xlabel('x index');
    ylabel('y index');
   
    axis('image')
    colorbar('vert')

    subplot(2,1,2)
    imagesc(idxCCX, idxCCZ, rot90(squeeze(ccVol(:,yShift(j),:))))
    xlabel('x index');
    ylabel('z index');
    axis('image')
    colorbar('vert')

    
    figure(1)
    subplot(3,1,1)
    plot(idxDynein(j, 1), yLoc(idxDynein(j, 2)), 'r+');

    subplot(3,1,2)
    plot(idxDynein(j, 1), zLoc(idxDynein(j, 3)), 'r+');
    drawnow
    
    avgDynein = avgDynein + tube(idxDynein(j, 1) + avgLength, ...
                                 idxDynein(j, 2) + avgWidth, ...
                                 avgDepth);
  end
end
avgDynein = avgDynein ./ j;

fprintf('\n');


%  Save the parameters and results
save findDynein1 ...
  idxPoints tubeSearchDim interpMethod scale threshold dyneinDim xSearchDist ...
  tube R yLoc zLoc idxTubeDynein ...
  hFilt meanFiltered idxLocalMin ...
  valMax idxDynein avgDynein




% TODO does this work for even # of samples
% Extract out the template

%  Compute the cross correlation coefficient for each of the 5 templates
% d1ccclm = corrcoef3d(tube, d1vol, 'valid');
% d2ccclm = corrcoef3d(tube, d2vol, 'valid');
% d3ccclm = corrcoef3d(tube, d3vol, 'valid');
% d4ccclm = corrcoef3d(tube, d4vol, 'valid');
% d5ccclm = corrcoef3d(tube, d5vol, 'valid');
