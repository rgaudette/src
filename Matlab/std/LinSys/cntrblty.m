%CNTRBLTY       Compute the controlability matrix of the pair {A,B}.
%
%   [rRc, Rc] = cntrblty(a,b)

function [rRc, Rc] = cntrblty(a,b)

[n m] = size(a);

Rc = b;
aprod = a;
for i = 1:n-1,
    Rc = [Rc aprod*b];
    aprod = aprod * a;
end

rRc = rank(Rc);
