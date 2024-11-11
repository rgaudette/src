function denoiseStack(outputFile, type, family, order, nDecomp, threshType, ...
                      noiseModel, threshCalc, threshWeight)

fprintf('outputFile: %s\n', outputFile);
fprintf('type: %s\n', type);
fprintf('family: %s\n', family);
fprintf('order: %s\n', order);
fprintf('nDecomp: %d\n', nDecomp);
fprintf('threshType: %s\n', threshType);
fprintf('noiseModel: %s\n', noiseModel);
fprintf('threshCalc: %s\n', threshCalc);
fprintf('threshWeight: %f\n', threshWeight);

mrcStack = MRCImage(outputFile, 0);

% Compute the stationary wavetlet transform of the
wavelet = [family order];
nSlices = getNZ(mrcStack);

for i = 1:nSlices
  fprintf('Slice %d\n', i);
  %  Get the current slice from the stack
  slice = getImage(mrcStack, i);

  wavelet = [family order];

  if strcmp(type, 'stationary')
    % Compute the selected transform
    im = double(slice);
    [nX nY] = size(im);
    nX = floor(nX / 2 ^ nDecomp) * 2 ^ nDecomp;
    nY = floor(nY / 2 ^ nDecomp) * 2 ^ nDecomp;
    im = im(1:nX, 1:nY);
    SWC = swt2(im, nDecomp, wavelet);

    % Threshold the decomposition    
    tSWC = swtThreshold(SWC, threshType, noiseModel, threshCalc, threshWeight);

    % Reconstruct the the decomposition
    newNX = floor(getNX(mrcStack) / 2^nDecomp) * 2^nDecomp;
    newNY = floor(getNY(mrcStack) / 2^nDecomp) * 2^nDecomp;
    recon = slice;
    recon(1:newNX, 1:newNY) = iswt2(tSWC, wavelet);
    
  else
    % Compute the selected transform
    [decomp decompStruct] = wavedec2(double(slice), nDecomp, wavelet);

    % Threshold the decomposition
    tDecomp = dwtThreshold(decomp, decompStruct, threshType, ...
                           noiseModel, threshCalc, threshWeight);

    % Reconstruct the the decomposition
    recon = waverec2(tDecomp, decompStruct, wavelet);
  end
  
  % Write out the denoised slice
  mrcStack = putImage(mrcStack, recon, i);
end
