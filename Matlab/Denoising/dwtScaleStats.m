%dwtScaleStat   Examine the statistics of the wavelet transform coefficients
%
%   dwtScaleStats(array, nScale, 'wavelet')
%
%   array       The data to transform.
%
%   nScale      The number of scales to examine.
%
%   'wavelet'   The wavelet transform to calculate.
%
%
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/03/04 20:45:34 $
%
%  $Revision: 1.1 $
%
%  $Log: dwtScaleStats.m,v $
%  Revision 1.1  2004/03/04 20:45:34  rickg
%  *** empty log message ***
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dwtScaleStats(array, nScale, wavelet)

% Examine the statistics of the wavelet coefficients for EM / tomogram
% noise

% Decompose the image into its wavelet coeffiecients
[wCoeff idxScale] = wavedec2(array, nScale, wavelet);

% calculate the statistics for each scale splitting it into
% horizontal, vertical and diagonal
nApprox = prod(idxScale(1,:));
approx = wCoeff(1:nApprox);
fprintf('Approximation mean: %f\n', mean(approx));
fprintf('Approximation std: %f\n', std(approx));
idxStart = nApprox+1;
for i = nScale:-1:1
  fprintf('Scale: %d\n', i);
  nCoeffs = prod(idxScale(nScale-i+2,:));

  hDetail = wCoeff(idxStart:idxStart+nCoeffs-1);
  hMean = mean(hDetail);
  hStd = std(hDetail);

  idxStart = idxStart+nCoeffs;
  vDetail = wCoeff(idxStart:idxStart+nCoeffs-1);
  vMean = mean(vDetail);
  vStd = std(vDetail);

  idxStart = idxStart+nCoeffs;
  dDetail = wCoeff(idxStart:idxStart+nCoeffs-1);
  dMean = mean(dDetail);
  dStd = std(dDetail);

  fprintf('Horizontal detail %d mean: %f\n',  i, hMean);
  fprintf('Vertical detail %d mean: %f\n', i, vMean);
  fprintf('Diagonal detail %d mean: %f\n', i, dMean);

  fprintf('Horizontal detail %d std: %f\n', i, hStd);
  fprintf('Vertical detail %d std: %f\n', i, vStd);  
  fprintf('Diagonal detail %d std: %f\n', i, dStd);
  disp(' ');
  idxStart = idxStart+nCoeffs;

end
