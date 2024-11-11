%waveDenoise2   Simple 2D wavelet denoising

function Y = swtDenoise2(SWC, wavelet);
nDetails = size(SWC, 3) - 1;
newSWC(:, :, nDetails+1) = SWC(:, :, nDetails+1);
% Threshold each detail image
for iScale = 1:nDetails
  scaleImage = SWC(:,:, iScale);
  [nX nY] = size(scaleImage);
  scaleImage = scaleImage(:);
  scaleStd = std(scaleImage);
  
  threshold = scaleStd * 1.2;
  
  idxZero =[abs(scaleImage) < threshold];
  scaleImage(idxZero) = 0;
  scaleImage = reshape(scaleImage, nX, nY);
  newSWC(:, :, iScale) = scaleImage;
end

% Reconstruct the denoised image
Y = iswt2(newSWC, wavelet);
