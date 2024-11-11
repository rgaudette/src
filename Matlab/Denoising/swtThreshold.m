%dwtThreshold   Threshold a DWT using the specified models
%
%  tDecomp = dwtThreshold(decomp, decompStruct, ...
%                         threshType, noiseModel, threshCalc, threshWeight)
%
%   tDecomp     The thresholded decomposition
%
%
%
%   dwtThreshold 
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/03/22 07:06:36 $
%
%  $Revision: 1.2 $
%
%  $Log: swtThreshold.m,v $
%  Revision 1.2  2004/03/22 07:06:36  rickg
%  Added additional scaling of threshold to make the different methods behave
%  similarly.
%
%  Revision 1.1  2004/03/11 01:54:42  rickg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function tSWC = swtThreshold(SWC, sorh, noiseStructure, threshFunction, tWeight)

%  Rescale threshold
switch threshFunction
 case {'sqtwolog', 'minimaxi'}
  tWeight = 1.0 * tWeight;
 otherwise
  tWeight = 5.0 * tWeight;
end

switch noiseStructure
 case 'white'
  hvDetailWeight = [1.0 1.0 1.0 1.0 1.0];
  dDetailWeight = [1.0 1.0 1.0 1.0 1.0];
 
 case 'F30'
  hvDetailWeight = [1.0 3.0 5.45 7.74 9.2];
  dDetailWeight = [0.35 1.9 4.2 6.22 6.9];
end

nPlanes = size(SWC, 3);
nScales = (nPlanes - 1) / 3;
hD1 = SWC(:, :, 1);
hD1std = std(hD1(:));
vD1 = SWC(:, :, nScales + 1);
vD1std = std(vD1(:));
dD1 = SWC(:, :, 2 * nScales + 1);
dD1std = std(dD1(:));
baseThresh = min(hD1std, vD1std);

fprintf('Horizontal detail 1 std: %f\n', hD1std);
fprintf('Vertical detail 1 std: %f\n', vD1std);
fprintf('Diagonal detail 1 std: %f\n', dD1std);
fprintf('Base threshold: %f\n', baseThresh);

tSWC(:, :, nPlanes) = SWC(:, :, nPlanes);

for iScale = 1:nScales
  switch lower(threshFunction)
   case 'std'
    hThresh = baseThresh * tWeight * hvDetailWeight(iScale);
    vThresh = hThresh;
    dThresh = baseThresh * tWeight * dDetailWeight(iScale);
   
   case {'sqtwolog', 'minimaxi'}
    hThresh = baseThresh * tWeight * hvDetailWeight(iScale) * ...
              thselect(SWC, threshFunction);
    vThresh = hThresh;
    dThresh =  baseThresh * tWeight * dDetailWeight(iScale) * ...
        thselect(SWC, threshFunction);

   case {'scale-std'}
    hVec = SWC(:, :, iScale);
    hThresh = tWeight * std(hVec(:));
    vVec = SWC(:, :, nScales + iScale);
    vThresh = tWeight * std(vVec(:));
    dVec = SWC(:, :, 2*nScales + iScale);
    dThresh = tWeight * std(dVec(:));
    
   otherwise
    hvStdEst = baseThresh * hvDetailWeight(iScale);
    hThresh = tWeight * hvStdEst * ...
              thselect(SWC(:, :, iScale) ./ hvStdEst, threshFunction);
    vThresh = tWeight * hvStdEst * ...
              thselect(SWC(:, :, nScales + iScale) ...
                       ./ hvStdEst, threshFunction);
    dStdEst = baseThresh * dDetailWeight(iScale);
    dThresh = tWeight * dStdEst * ...
              thselect(SWC(:, :, 2 * nScales + iScale) ...
                       ./ dStdEst, threshFunction);
  end
  fprintf('Scale: %d ', iScale);
  fprintf('hThresh: %f  vThresh:  %f  dThresh: %f\n', ...
          hThresh, vThresh, dThresh);
  tSWC(:, :, iScale) = wthresh(SWC(:,:, iScale), sorh, hThresh);
  tSWC(:, :, nScales + iScale) = ...
      wthresh(SWC(:,:, nScales + iScale), sorh, vThresh);
  tSWC(:, :, 2 * nScales + iScale) = ...
      wthresh(SWC(:,:, 2 * nScales + iScale), sorh, dThresh);
end
