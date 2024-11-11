%arraymax       Find the maximum value and indices of a multidimensional array
%
%  [val, indices] = arraymax(array)
function [val, indices] = arraymax(array)

% Find the size and number of dimensions of the array
dims = size(array);
nDims = length(dims);

[val idx] = max(array(:));

% calculate the index value in each dimension peeling of the largest dimension
% first
dimProd = cumprod(dims);
idxRemainder = idx;
for iDim = nDims:-1:2

  if rem(idxRemainder, dimProd(iDim-1)) == 0
    indices(iDim) = floor(idxRemainder / dimProd(iDim-1));
    idxRemainder =  dimProd(iDim-1);
  else
    indices(iDim) = floor(idxRemainder / dimProd(iDim-1)) + 1;
    idxRemainder = rem(idxRemainder, dimProd(iDim-1));
  end
  
end

indices(1) = idxRemainder;
    
  
