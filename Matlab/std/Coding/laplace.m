%LAPLACE      Generate a Laplacian random variable.
%
%    x = laplace(N, sigma)
%
function x = laplace(N, sigma)

if nargin < 2,
    sigma = 1;
end


x = rand(N) + 1e-300;

idxNeg = find(x < 0.5);
idxPos = find(x >= 0.5);

x(idxNeg) = sigma / sqrt(2) * log(2*x(idxNeg));
x(idxPos) = -1*sigma / sqrt(2) * log(2*(1 - x(idxPos)));
