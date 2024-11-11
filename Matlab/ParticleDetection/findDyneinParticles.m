function [dyneinPos, dyneinTube, maxCCC, avgDynein] = ...
    findDyneinParticles(tube, idxLocalMin, contourModel, dyneinModel)
% Test script for dynein detection: find the particles view cross-correlation
% coefficient given the inital search positions in X.

% Tunable parameters
dyneinDim = [8 8 8];
xSearchDist = [-17:17];
avgLength = [-40:35];


% Load in the dynein contour
modDynCont = ImodModel(contourModel);
dynContour = getPoints(modDynCont, 1, 1)';

% Load in the reference points
dynRefModel = ImodModel(dyneinModel);
dynRefPoints = getPoints(dynRefModel, 1, 1)';

%  Extract the templates
dynWidth =  [-dyneinDim(2):dyneinDim(2)];
dynDepth =  [-dyneinDim(3):dyneinDim(3)];

% Calculate the cross-correlation kernel
xcorrKernel = calcKernel(tube, ...
                         mapCart2Tube(dynContour, dynRefPoints) + 0.5, ...
                         dyneinDim);

%  Compute the number of samples to shift from the center of the tube and the
%  min Index
%
%  WARNING This has been verified only for odd numbers of samples in both
%  in both the both the tube and the template volume.
%
%  idxCC? maps a shift index in the cross correlation output to a index in
%  the tube
tubeSearchDim = size(tube);
tubeOffset = ceil(tubeSearchDim / 2);
nDomainCCX = floor(length(xSearchDist)/2) - dyneinDim(1);
nDomainCCY = floor(tubeSearchDim(2)/2) - dyneinDim(2);
idxCCY = [-nDomainCCY:nDomainCCY] + ceil(tubeSearchDim(2)/2);
nDomainCCZ = floor(tubeSearchDim(3)/2) - dyneinDim(3);
idxCCZ = [-nDomainCCZ:nDomainCCZ] + ceil(tubeSearchDim(3)/2);

idxDynein = [];

avgWidth = dynWidth;
avgDepth = 1:tubeSearchDim(3);
avgDynein = zeros(length(avgLength), length(avgWidth), length(avgDepth));

j = 0;
nAvg = 0;
for i = 1:length(idxLocalMin)
  fprintf('%d: ', i);
  xSearchRegion = round(idxLocalMin(i) + xSearchDist);

  %  Be sure that we have enough data around the min point to cross correlate
  %  the region
  if (xSearchRegion(1) > 0) & (xSearchRegion(end) <= size(tube,1))
    j = j + 1;
    idxCCX = [-nDomainCCX:nDomainCCX] + idxLocalMin(i);
    searchVol = tube(xSearchRegion, :, :);
    ccVol = corrcoef3d(searchVol, xcorrKernel, 'valid');
    [maxCCC(j) idxMax] = max(ccVol(:));
    [xShift(j) yShift(j) zShift(j)] = ind2sub(size(ccVol), idxMax);
    idxDynein(j, :) = [idxCCX(xShift(j)) ...
                       idxCCY(yShift(j)) ...
                       idxCCZ(zShift(j)) ];
    fprintf('%f  ', maxCCC(j));
    figure(2)
    subplot(2,1,1)
    imagesc(idxCCX, idxCCY, rot90(ccVol(:,:, zShift(j))))
    xlabel('x index');
    ylabel('y index');
    title(['particle: ' int2str(j)])
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
    plot(idxDynein(j, 1), idxDynein(j, 2), 'r+');

    subplot(3,1,2)
    plot(idxDynein(j, 1), idxDynein(j, 3), 'r+');
    drawnow
    
    if all((idxDynein(j, 1) + avgLength) > 0) ...
        & all((idxDynein(j, 1) + avgLength) <= size(tube, 1))
      
      avgDynein = avgDynein + tube(idxDynein(j, 1) + avgLength, ...
                                   idxDynein(j, 2) + avgWidth, ...
                                   avgDepth);
      nAvg = nAvg + 1;
    end
  end
end
avgDynein = avgDynein ./ nAvg;
fprintf('\n');
dyneinTube = [idxDynein(:,1) ...
              idxDynein(:,2)- tubeOffset(2) ...
              idxDynein(:,3)- tubeOffset(3)];

dyneinPos = mapTube2Cart(dynContour, idxDynein - 0.5);


function kernel = calcKernel(tube, posRefCenter, volSize)
tubeOffset = ceil(size(tube) / 2);
idxLength = [-volSize(1):volSize(1)];
idxWidth = tubeOffset(2) + [-volSize(2):volSize(2)];
idxDepth = tubeOffset(3) + [-volSize(3):volSize(3)];

kernel = zeros(length(idxLength), length(idxWidth), length(idxDepth));
nSum = size(posRefCenter);
for iRef = 1:nSum
  
  kernel = kernel + tube(floor(posRefCenter(iRef, 1) + idxLength), ...
                floor(posRefCenter(iRef, 2) + idxWidth), ...
                floor(posRefCenter(iRef, 3) + idxDepth);
end
kernel = kernel / nSum;
