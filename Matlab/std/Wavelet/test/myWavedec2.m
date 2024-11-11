% compare wavedec2 with a sequential dwt approach

function [Approx, dHorizontal, dVertical, dDiagonal] = ...
    myWavedec2(array, wavelet)

[nR nC] = size(array)

% Compute the DWT along each column
for idxC = nC:-1:1
 [vA(:, idxC) vD(:, idxC)] = dwt(array(:, idxC), wavelet);
end
size(vA)
size(vD)

% Compute the DWT of the vertical approximation to generate the total
% approximation and the horizontal detail coeffs
nRA = size(vA, 1);
for idxR = nRA:-1:1
  [Approx(idxR, :) dVertical(idxR, :)] = dwt(vA(idxR, :), wavelet);
  [dHorizontal(idxR, :) dDiagonal(idxR, :)] = dwt(vD(idxR, :), wavelet);
end
