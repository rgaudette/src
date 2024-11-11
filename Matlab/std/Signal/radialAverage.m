function [radialAvg nElements] = radialAverage(array, upperRadii)

szArray = size(array);
idxCenter = floor(szArray / 2 + 1);
fR = ([1:szArray(1)] - idxCenter(1)) ./ szArray(1);
fC = ([1:szArray(2)] - idxCenter(2)) ./ szArray(2);

switch ndims(array)
  case 2
    [distR distC] = ndgrid(fR, fC);
    dist = sqrt(distR.^2 + distC.^ 2);
  case 3
    fP = ([1:szArray(3)] - idxCenter(3)) ./ szArray(3);
    [distR distC distP] = ndgrid(fR, fC, fP);
    dist = sqrt(distR.^2 + distC.^ 2 + distP.^ 2);
  otherwise
    error('%d dimensional arrays not yet implemented', ndims(array));
end

nShells = length(upperRadii);
lowerRadii = [0 upperRadii(1:end-1)];
radialAvg = zeros(nShells, 1);
nSamples = zeros(nShells, 1);

for iShell = 1:nShells
  % Find the samples in the current shell
  idxShell = (dist >= lowerRadii(iShell)) & (dist < upperRadii(iShell));
  idxShell = idxShell(:);
  shell = array(idxShell);
  radialAvg(iShell) = mean(shell);
  % Compute the ratio of the 
  nElements(iShell) = sum(idxShell);
end
