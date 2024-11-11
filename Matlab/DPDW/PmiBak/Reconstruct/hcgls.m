function x = hcgls(A,b,k)
%HCGLS Conjugate gradient algorithm applied implicitly to the normal equations.
%
% x = cgls(A,b,k)
%
% Performs k steps of the conjugate gradient algorithm applied
% implicitly to the normal equations A'*A*x = A'*b.
%
%
% References: A. Bjorck, "Numerical Methods for Least Squares Problems",
% SIAM, Philadelphia, 1996.
% C. R. Vogel, "Solving ill-conditioned linear systems using the
% conjugate gradient method", Report, Dept. of Mathematical
% Sciences, Montana State University, 1987.
 
% Per Christian Hansen, IMM, 07/02/97.

 
% Initialization.
[m,n] = size(A);

% Prepare for CG iteration.
x = zeros(n,1);
d = A'*b;
r = b;
normr2 = d'*d;

% Iterate.
for j=1:k
  % Update x and r vectors.
  Ad = A * d;
  alpha = normr2 / (Ad'*Ad);
  x  = x + alpha * d;
  r  = r - alpha * Ad;
  s  = A' * r;

  % Update d vector.
  normr2_new = s' * s;
  beta = normr2_new/normr2;
  normr2 = normr2_new;
  d = s + beta*d;
end
