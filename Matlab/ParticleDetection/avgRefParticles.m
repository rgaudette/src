function [avgParticle, idxDynein] = ...
    avgRefParticles(tube, contourModel, dyneinModel)

% Tunable parameters
dyneinDim = 6;
xSearchDist = [-10:10];

% Load in the dynein contour
modDynCont = ImodModel(contourModel);
dynContour = getPoints(modDynCont, 1, 1)';

% Load in the reference points
dynRefModel = ImodModel(dyneinModel);
dynRefPoints = getPoints(dynRefModel, 1, 1)';
idxTubeDynein = mapCart2Tube(dynContour, dynRefPoints) + 0.5;
diff(idxTubeDynein(:,1))
% Using the first particle as a reference loop over the particles computing
% cross-correltion coefficient
%  Extract the templates
dynLength = [-dyneinDim:dyneinDim];
dynWidth =  [-dyneinDim:dyneinDim];
dynDepth =  [-dyneinDim:dyneinDim];
tubeSearchDim = size(tube);
tubeOffset = ceil(tubeSearchDim / 2);
idxRefParticle = 3;
refVol = tube(floor(idxTubeDynein(idxRefParticle,1) + dynLength), ... 
          floor(idxTubeDynein(idxRefParticle,2) + tubeOffset(2) + dynWidth), ...
          floor(idxTubeDynein(idxRefParticle,3) + tubeOffset(3) + dynDepth));

avgParticle = refVol;
nAvg = 1;

%  Compute the number of samples to shift from the center of the tube and the
%  min Index
%
%  WARNING This has been verified only for odd numbers of samples in both
%  in both the both the tube and the template volume.
%
%  idxCC? maps a shift index in the cross correlation output to a index in
%  the tube
nDomainCCX = floor(length(xSearchDist)/2) - dynLength(end);
nDomainCCY = floor(tubeSearchDim(2)/2) - dynWidth(end);
idxCCY = [-nDomainCCY:nDomainCCY] + tubeOffset(2);;
nDomainCCZ = floor(tubeSearchDim(3)/2) - dynDepth(end);
idxCCZ = [-nDomainCCZ:nDomainCCZ] + tubeOffset(3);

nPoints = size(dynRefPoints, 1);
idxDynein = zeros(nPoints, 3);

for i = 1:nPoints
  fprintf('%d: ', i);
  xSearchRegion = round(dynRefPoints(i, 1) + xSearchDist);

  %  Be sure that we have enough data around the min point to cross correlate
  %  the region
  if (xSearchRegion(1) > 0) & (xSearchRegion(end) <= size(tube,1))

    idxCCX = [-nDomainCCX:nDomainCCX] + idxTubeDynein(i, 1);
    searchVol = tube(xSearchRegion, :, :);

    ccVol = corrcoef3d(searchVol, refVol, 'valid');
    [maxCCC(i) idxMax] = max(ccVol(:));

    xcVol = xcorr3d(searchVol, refVol, 'valid');
    [maxXC(i) idxMaxXC] = max(xcVol(:));

    [xShift yShift zShift] = ind2sub(size(ccVol), idxMax)
    [xShift yShift zShift] = ind2sub(size(xcVol), idxMaxXC)

    [xShift(i) yShift(i) zShift(i)] = ind2sub(size(ccVol), idxMax);
    idxDynein(i, :) = [idxCCX(xShift(i)) ...
                       idxCCY(yShift(i)) ...
                       idxCCZ(zShift(i)) ];
    avgParticle = avgParticle + ...
        tube(floor(idxDynein(i,1) + dynLength), ... 
             floor(idxDynein(i,2) + dynWidth), ...
             floor(idxDynein(i,3) + dynDepth));
    
    nAvg = nAvg + 1;
    
    fprintf('%f  ', maxCCC(i));

    figure(1)
    subplot(2,1,1)
    imagesc(idxCCX, idxCCY, rot90(ccVol(:,:, zShift(i))))
    xlabel('x index');
    ylabel('y index');
    title(['Cross correlation coeffiecient particle: ' int2str(i)])
    axis('image')
    colorbar('vert')

    subplot(2,1,2)
    imagesc(idxCCX, idxCCZ, rot90(squeeze(ccVol(:,yShift(i),:))))
    xlabel('x index');
    ylabel('z index');
    axis('image')
    colorbar('vert')

    figure(2)
    subplot(2,1,1)
    imagesc(idxCCX, idxCCY, rot90(xcVol(:,:, zShift(i))))
    xlabel('x index');
    ylabel('y index');
    title(['Cross correlation particle: ' int2str(i)])
    axis('image')
    colorbar('vert')

    subplot(2,1,2)
    imagesc(idxCCX, idxCCZ, rot90(squeeze(xcVol(:,yShift(i),:))))
    xlabel('x index');
    ylabel('z index');
    axis('image')
    colorbar('vert')
    drawnow
    
  end
end

avgParticle = avgParticle ./ nAvg;
