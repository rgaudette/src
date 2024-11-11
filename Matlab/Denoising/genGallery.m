%genGallery   Generate a gallery of denoised images in a single MRC stack

function genGallery(mrcFile, idxSlice, galleryName)

% Open the log file
[logFID message] = fopen([galleryName '.log'], 'w+');
if logFID == -1
  error('Cant open log file');
end
% load in the idxSlice and neighboring idxSlices
mrcImage = MRCImage(mrcFile, 0);
testImage = double(getImage(mrcImage, idxSlice));
tP1 = double(getImage(mrcImage, idxSlice + 1));
tP2 = double(getImage(mrcImage, idxSlice + 2));
tP3 = double(getImage(mrcImage, idxSlice + 3));
tP4 = double(getImage(mrcImage, idxSlice + 4));
tM1 = double(getImage(mrcImage, idxSlice - 1));
tM2 = double(getImage(mrcImage, idxSlice - 2));
tM3 = double(getImage(mrcImage, idxSlice - 3));
tM4 = double(getImage(mrcImage, idxSlice - 4));

% Create the output MRCImage and 
gallery = MRCImage(mrcImage, galleryName);

% Put the test image into the first image in the gallery.
gallery = putImage(gallery, testImage, 1);

cumImage = testImage + tP1 + tM1;
gallery = putImage(gallery, cumImage / 3, 2);

cumImage = cumImage + tP2 + tM2;
gallery = putImage(gallery, cumImage / 5, 3);

cumImage = cumImage + tP3 + tM3;
gallery = putImage(gallery, cumImage / 7, 4);

cumImage = cumImage + tP4 + tM4;
gallery = putImage(gallery, cumImage / 9, 5);

gallery = putImage(gallery, medfilt2(testImage, [3 3]), 6);
gallery = putImage(gallery, medfilt2(testImage, [4 4]), 7);
gallery = putImage(gallery, medfilt2(testImage, [5 5]), 8);

nImages = 8;

transformType = {'discrete', 'stationary'};
transformType = {'stationary'};
transformFamily = {'db', 'sym'};
transformFamily = {'sym'};
transformOrder = {'7', '8'};
%transformOrder = {'7'};
vecNDecomp = [2 3 4];
%vecNDecomp = 3;
thresholdType = {'h', 's'};
%thresholdType = {'s'};
noiseModels = {'white', 'F30'};
noiseModels = {'white'};
threshCalc = {'std', 'sqtwolog', 'minimaxi', 'rigrsure', 'heursure'};
threshCalc = {'scale-std'};
threshWeight = [0.2 0.5 0.7 1.0 1.25 1.5 2];
%threshWeight = [1.0];

for iType = 1:length(transformType)
  type = transformType{iType};
  
  for iFamily = 1:length(transformFamily)
    family = transformFamily{iFamily};
    
    for iOrder = 1:length(transformOrder)
      order = transformOrder{iOrder};
      wavelet = [family order];
      
      for iDecomp = 1:length(vecNDecomp)
        nDecomp = vecNDecomp(iDecomp);
        
        if strcmp(type, 'stationary')
          % Compute the selected transform
          im = double(testImage);
          [nX nY] = size(im);
          nX = floor(nX / 2 ^ nDecomp) * 2 ^ nDecomp;
          nY = floor(nY / 2 ^ nDecomp) * 2 ^ nDecomp;
          im = im(1:nX, 1:nY);
          SWC = swt2(im, nDecomp, wavelet);
            
        else
          % Compute the selected transform
          [decomp decompStruct] = wavedec2(double(testImage), nDecomp, wavelet);
        end

        
        for iWeight = 1:length(threshWeight)
          weight = threshWeight(iWeight);
          
          for iThreshType = 1:length(thresholdType)
            threshType = thresholdType{iThreshType};
            
            for iNoiseModel = 1:length(noiseModels)
              noiseModel =  noiseModels{iNoiseModel};

            for iCalc = 1:length(threshCalc)
              thCalc = threshCalc{iCalc};

                % Threshold the decomposition    
                if strcmp(type, 'stationary')
                      
                  tSWC = swtThreshold(SWC, threshType, noiseModel, ...
                                      thCalc, weight);

                  % Reconstruct the the decomposition
                  newNX = floor(getNX(gallery) / 2^nDecomp) * 2^nDecomp;
                  newNY = floor(getNY(gallery) / 2^nDecomp) * 2^nDecomp;
                  recon = testImage;
                  recon(1:newNX, 1:newNY) = iswt2(tSWC, wavelet);
                else
                  % Threshold the decomposition
                  tDecomp = dwtThreshold(decomp, decompStruct, threshType, ...
                                         noiseModel, thCalc, weight);

                  % Reconstruct the the decomposition
                  recon = waverec2(tDecomp, decompStruct, wavelet);
                end
                nImages = nImages + 1;
                fprintf('%d\t%s\t%s\t%d\t%s\t%s\t%s\t%f\n', ...
                        nImages, type, wavelet, nDecomp, threshType, ...
                        noiseModel, thCalc, weight);

                gallery = putImage(gallery, recon, nImages);
                fprintf(logFID, '%d\t%s\t%s\t%d\t%s\t%s\t%s\t%f\n', ...
                        nImages, type, wavelet, nDecomp, threshType, ...
                        noiseModel, thCalc, weight);
              end
            end
          end
        end
      end
    end
  end
end
fclose(logFID);

gallery = setNZ(gallery, nImages);
