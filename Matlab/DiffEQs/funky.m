%FUNKY          Funky matrix from Comp EMag class
%
%   [A b] = funky(n)

function [A, b] = funky(n)
iv = [1:n]';
[i j] = meshgrid(iv);
A = (j - i) ./ (i .* j) + eye(n);

b = n ./ (2 * iv) + iv .* (-1) .^ iv;
