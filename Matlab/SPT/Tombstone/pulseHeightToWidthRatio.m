%pulseHeightToWidthRatio  Calculate the pulse height-to-width ratio
%
%  heightToWidthRatio = pulseHeightToWidthRatio(diffProf)
%
%  heightToWidthRatio   
%
%  Status: functional

function [heightToWidthRatio, derivExtrema, width] = ...
    pulseHeightToWidthRatio(diffProf, cThresh, milsPerPixel)
if nargin < 2
  cThresh = 0.5;
end
if nargin < 3
  milsPerPixel = 1;
end
[nProf nElem] = size(diffProf);
heightToWidthRatio = zeros(nProf, 2);
derivExtrema = zeros(nProf, 2);
width = zeros(nProf, 2);

for iProf = 1:nProf
  
  %%
  %%  Positive pulse height-to-width ratio
  %%
  [valMax idxMax] = max(diffProf(iProf,:));
  thresh = cThresh * valMax;
  iLeft = idxMax - 1;
  while diffProf(iProf, iLeft) >= thresh
    iLeft = iLeft - 1;
    if iLeft == 1
      break
    end
  end

  iRight = idxMax + 1;
  while diffProf(iProf, iRight) >= thresh & iRight <= nElem
    iRight = iRight + 1;
    if iRight == nElem
      break
    end
  end
  posWidth = (iRight - iLeft) * milsPerPixel;
  heightToWidthRatio(iProf, 1) = valMax / posWidth;
  derivExtrema(iProf, 1) = valMax;
  width(iProf, 1) = iRight - iLeft;

  %%
  %%  Negative pulse height-to-width ratio
  %%
  [valMin idxMin] = min(diffProf(iProf,:));
  thresh = cThresh * valMin;
  iLeft = idxMin - 1;
  while diffProf(iProf, iLeft) <= thresh
    iLeft = iLeft - 1;
    if iLeft == 1
      break
    end
  end

  iRight = idxMin + 1;
  while diffProf(iProf, iRight) <= thresh & iRight <= nElem
    iRight = iRight + 1;
    if iRight == nElem
      break
    end
  end
  posWidth = (iRight - iLeft) * milsPerPixel;
  heightToWidthRatio(iProf, 2) = -valMin / posWidth;
  derivExtrema(iProf, 2) = valMin;
  width(iProf, 2) = iRight - iLeft;
end
