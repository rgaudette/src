%vec2norm       Compute the 2-norm of the column vectors in a md-array.
%
%   arr2norm = vec2norm(array)
%
%   arr2norm    The 2-norm of each column vector in array. 
%
%   array       The multi-dimensional array to be measured.
%
%
%   vec2norm computes the 2-norm of each column vector in a multi-dimensional
%   array.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/07/30 16:39:15 $
%
%  $Revision: 1.2 $
%
%  $Log: vec2norm.m,v $
%  Revision 1.2  2004/07/30 16:39:15  rickg
%  Added missing semi, fixed comments
%
%  Revision 1.1.1.1  2004/01/03 08:25:09  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x2norm = vec2norm(array)

nDims = ndims(array);
vecSize = size(array);
nCols = prod(vecSize(2:end));
array = reshape(array, vecSize(1), nCols);
if nDims > 2
    x2norm = zeros(vecSize(2:end));
else
    x2norm = zeros(1,vecSize(2:end));
end

for iEst = 1:nCols
    x2norm(iEst) = norm(array(:,iEst));
end
