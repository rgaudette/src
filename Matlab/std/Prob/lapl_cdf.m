%LAPL_CDF   Laplacian CDF
%
%   F = lapl_cdf(X, Sigma)
%
%   F       The value of F(X) for a Laplacian RV for each value of X.
%
%   X       The ordinate values to generate for.
%
%   Sigma   [OPTIONAL] The varaince for the CDF.
%
%   LAPL_CDF generates the Laplacian CDF for values of X.

function F = lapl_cdf(X, Sigma)

if nargin < 2,
    Sigma = 1.0;
end

idxNeg = find(X < 0.0);
idxPos = find(X >= 0.0);

F = zeros(size(X));
F(idxNeg) = 0.5 * exp(sqrt(2) / Sigma * X(idxNeg));
F(idxPos) = 1 - 0.5 * exp(-1 * sqrt(2) / Sigma * X(idxPos));



