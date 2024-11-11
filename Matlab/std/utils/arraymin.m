%arraymin       Find the minimum value and indices of a multidimensional array

function [val, indices] = arraymin(array)

% Find the size and number of dimensions of the array
dims = size(array);
nDims = length(dims);

[val idx] = min(array(:));

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
    
  
