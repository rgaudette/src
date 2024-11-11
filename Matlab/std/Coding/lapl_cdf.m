%LAPL_CDF       Laplacian CDF.
%
function F = laplace(X, sigma)

if nargin < 2,
    sigma = 1;
end


idxNeg = find(X < 0);
idxPos = find(X >= 0);

F = zeros(size(X));
F(idxNeg) = 0.5 * exp(sqrt(2) / sigma * X(idxNeg));
F(idxPos) = 1 - 0.5 * exp(-1 * sqrt(2) / sigma * X(idxPos));

