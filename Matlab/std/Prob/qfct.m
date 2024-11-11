%QFCT           Q function.
%
%   y = qfct(c)
%
%   q(x) = 0.5*(1 - erf(x/sqrt(2))

function y = qfct(x)

y = 0.5 - 0.5*erf(x/sqrt(2));
