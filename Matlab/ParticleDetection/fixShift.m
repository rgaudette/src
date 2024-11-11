function [dyneinLocFixed, dyneinTubeFixed] = ...
    fixShift(tube, dyneinTube, contourModel)

% Load in  dynein contour
modDynCont = ImodModel(contourModel);
dynContour = getPoints(modDynCont, 1, 1)';

tubeSearchDim = size(tube);
tubeOffset = ceil(tubeSearchDim / 2);

% Subtract the tube offset from the dynein2tube and remap to cartesian
% coordinates
dyneinTube(:, 2) = dyneinTube(:, 2) - tubeOffset(2);
dyneinTube(:, 3) = dyneinTube(:, 3) - tubeOffset(3);
dyneinTubeFixed = dyneinTube;
dyneinLocFixed = mapTube2Cart(dynContour, dyneinTubeFixed);
