function ccf = corrcoef3dTest2(kernel, shift, volSize, stdDev, mean)
if nargin < 5
  mean = 0;
end
if nargin < 4
  stdDev = 0;
end

kernelSize = size(kernel);
testVolume = randn(volSize) * stdDev;
idxX = [1:kernelSize(1)] + shift(1);
idxY = [1:kernelSize(2)] + shift(2);
idxZ = [1:kernelSize(3)] + shift(3);
testVolume(idxX, idxY, idxZ) = kernel;

ccf = corrcoef3d(testVolume, kernel);
