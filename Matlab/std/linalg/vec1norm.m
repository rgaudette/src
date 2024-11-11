%vec1norm       Compute the 1-norm of the column vectors in a md-array.
%
%   arr1norm = vec1norm(array)
%
%   arr1norm    The 1-norm of each column vector in array. 
%
%   array       The multi-dimensional array to be measured.
%
%
%   vec1norm computes the 1-norm of each column vector in a multi-dimensional
%   array.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:09 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: vec1norm.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:09  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x1norm = vec1norm(array)

nDims = ndims(array);
vecSize = size(array);
nCols = prod(vecSize(2:end));
array = reshape(array, vecSize(1), nCols);
x1norm = zeros(vecSize(2:end));
for iEst = 1:nCols
    x1norm(iEst) = sum(abs(array(:,iEst)));
end
