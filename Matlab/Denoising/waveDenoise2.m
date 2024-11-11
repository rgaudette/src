%waveDenoise2   Simple 2D wavelet denoising

function Y = waveDenoise2(X);

N = 5;
wavelet = 'haar';

[dec indexList] = wavedec2(X, N, wavelet);

% Extract each of the details and approximation vectors
nApprox = indexList(1,1) * indexList(1,2);
approx = dec(1:nApprox);
iStart = nApprox + 1;
for iScale = 1:N
  fprintf('Scale: %d   size: %d x %d\n', int2str(N - iScale + 1), ...
          indexList(iScale+1,1), indexList(iScale+1,2));
  nElem = prod(indexList(iScale+1,:));
  threshold = sqrt(2*log(indexList(iScale+1,1)))*0.3
  
  horiz = dec(iStart:iStart+nElem-1);
  horizStd = std(horiz);
  fprintf('Horizontal std: %f\n', horizStd);
  idxZero =[abs(horiz) < horizStd * threshold];
  horiz(idxZero) = 0;
  dec(iStart:iStart+nElem-1) = horiz;

  iStart = iStart + nElem;
  vert = dec(iStart:iStart+nElem-1);
  vertStd = std(vert);
  fprintf('Vertical std: %f\n', vertStd);
  idxZero = [abs(vert) < vertStd * threshold];
  vert(idxZero) = 0;
  dec(iStart:iStart+nElem-1) = vert;

  iStart = iStart + nElem;
  diagonal = dec(iStart:iStart+nElem-1);
  diagonalStd = std(diagonal);
  fprintf('Diagonal std: %f\n\n', diagonalStd);
  idxZero = [abs(diagonal) < diagonalStd * threshold];
  diagonal(idxZero) = 0;
  dec(iStart:iStart+nElem-1) = diagonal;

  iStart = iStart + nElem;
end

% Reconstruct the denoised image
Y = waverec2(dec, indexList, wavelet);
