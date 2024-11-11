%capturePoints   Find points within a threshold of second order Y model
%
%
function [validTop validBottom] = ...
  capturePoints(predicted, zHeight, thickness, threshold)

reshapeSize = [size(zHeight,2) size(zHeight,1)];
predictedTop = reshape(predicted + thickness / 2, reshapeSize)';
predictedBottom = reshape(predicted - thickness / 2, reshapeSize)';
validTop = abs((predictedTop - zHeight)) < threshold;
validBottom = abs((predictedBottom  - zHeight)) < threshold;