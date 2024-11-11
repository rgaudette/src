%CENTROID       Compute the centroid a given vector set.
%
%   v = centroid(Set)
%
%   v           The centroid of the data.
%
%   Set         The data vectors in matrix form, each column is a data vector.


function v = centroid(Set)
[szVec nVec] = size(Set);

if nVec > 1,
    v = mean(Set')';
else
    v = Set;
end


