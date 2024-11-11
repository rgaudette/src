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
%  $Date: 2004/03/22 07:05:37 $
%
%  $Revision: 1.2 $
%
%  $Log: dwtThreshold.m,v $
%  Revision 1.2  2004/03/22 07:05:37  rickg
%  Added additional scaling of threshold to make the different methods behave
%  similarly.
%
%  Revision 1.1  2004/03/11 01:54:09  rickg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function tDecomp = dwtThreshold(decomp, decompStruct, threshType, ...
                                noiseModel, threshCalc, threshWeight)

%  Rescale threshold
switch threshFunction
 case {'sqtwolog', 'minimaxi'}
  tWeight = 1.0 * tWeight;
 otherwise
  tWeight = 5.0 * tWeight;
end

switch noiseModel
 case 'white'
  hvDetailWeight = [1.0 1.0 1.0 1.0 1.0];
  dDetailWeight = [1.0 1.0 1.0 1.0 1.0];
 
 case 'F30'
  hvDetailWeight = [1.0 3.0 5.45 7.74 9.2];
  dDetailWeight = [0.35 1.9 4.2 6.22 6.9];

end

nD1 = prod(decompStruct(end-1,:));
hD1 = decomp(end-3*nD1+1:end-2*nD1);  
hD1std = std(hD1);
vD1 = decomp(end-2*nD1+1:end-nD1);
vD1std = std(vD1);
dD1 = decomp(end-nD1+1:end);
dD1std = std(dD1);
baseThresh = min(hD1std, vD1std);

fprintf('Horizontal detail 1 std: %f\n', hD1std);
fprintf('Vertical detail 1 std: %f\n', vD1std);
fprintf('Diagonal detail 1 std: %f\n', dD1std);
fprintf('Base threshold: %f\n', baseThresh);

tDecomp = zeros(size(decomp));

% Don't threshold the approximation
nApprox = prod(decompStruct(1,:));
tDecomp(1:nApprox) = decomp(1:nApprox);

idxStart = nApprox + 1;
nDetails = size(decompStruct,1)-2;
for iScale = 1:nDetails
  nScale = prod(decompStruct(iScale+1,:));
  idxH = idxStart:idxStart+nScale-1;
  idxStart = idxStart + nScale;
  idxV = idxStart:idxStart+nScale-1;
  idxStart = idxStart + nScale;
  idxD = idxStart:idxStart+nScale-1;
  idxStart = idxStart + nScale;
  
  switch lower(threshCalc)
   case 'std'
    hThresh = baseThresh * threshWeight * hvDetailWeight(nDetails - iScale + 1);
    vThresh = hThresh;
    dThresh = baseThresh * threshWeight * dDetailWeight(nDetails - iScale + 1);
   case {'sqtwolog', 'minimaxi'}
    hThresh = baseThresh * threshWeight * ...
              hvDetailWeight(nDetails - iScale + 1) * ...
              thselect(decomp, threshCalc);
    vThresh = hThresh;
    dThresh =  baseThresh * threshWeight * ...
        dDetailWeight(nDetails - iScale + 1) * ...
        thselect(decomp, threshCalc);
   otherwise
    hvStdEst = baseThresh * hvDetailWeight(nDetails - iScale + 1);
    hThresh = threshWeight * hvStdEst * ...
              thselect(decomp(idxH) ./ hvStdEst, threshCalc);
    vThresh = threshWeight * hvStdEst * ...
              thselect(decomp(idxV) ./ hvStdEst, threshCalc);
    dStdEst = baseThresh * dDetailWeight(nDetails - iScale + 1);
    dThresh = threshWeight * dStdEst * ...
              thselect(decomp(idxD) ./ dStdEst, threshCalc);
  end
  fprintf('Scale: %d ', nDetails - iScale + 1);
  fprintf('hThresh: %f  vThresh:  %f  dThresh: %f\n', ...
          hThresh, vThresh, dThresh);

  tDecomp(idxH) = wthresh(decomp(idxH), threshType, hThresh);
  tDecomp(idxV) = wthresh(decomp(idxV), threshType, vThresh);
  tDecomp(idxD) = wthresh(decomp(idxD), threshType, dThresh);
end
