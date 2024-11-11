%CG             Conjugate gradient algorithm for solving Ax=b
%
%   [x, nIter, P] = cg(A, b, Po, epsilon)

function [x, nIter, P] = cg(A, b, Po, epsilon)

if nargin < 4,
  epsilon = sqrt(1E-5);
end
epsilon = epsilon ^2

P(:,1) = Po;
r = b - A * Po;
mu = r;
err = r' * r;

nIter = 2;
while err > epsilon
  gamma = mu' * A * mu;
  alpha = (mu' * r) / gamma;
  P(:,nIter) = P(:,nIter-1) + alpha * mu;
  r = b - A * P(:,nIter);
  beta = (mu' * A * r) / gamma;
  mu = r - beta * mu;
  nIter = nIter + 1;
  err = r' * r;
end
nIter = nIter - 1;
x = P(:, nIter);
