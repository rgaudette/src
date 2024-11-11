%DCT2M          Generate a DCT-II transformation matrix.
%
%   Phi = dct2m(n)

function Phi = dct2m(n)

l = [0:n-1]+.5;
k = [0:n-1]';
ck_mat = [1/sqrt(2) ; ones(n-1,1)] * ones(1,n);

Phi = sqrt(2/n) * ck_mat .* cos(k*l*(pi/n));

