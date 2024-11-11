%RQUAD          Compute the roots of quadratic function given by
%
%           Ax^2 + Bx + C = 0
%
%   r = rquad(A, B, C)
%
%   A, B & C may be given as column vectors for a number of equations.
%   The roots are returned in increasing magnitude.
%
function r = rquad(a, b, c)

r1 = (-1*b + sqrt(b.^2 - 4 .* a .* c)) ./ (2 * a);
r2 = (-1*b - sqrt(b.^2 - 4 .* a .* c)) ./ (2 * a);

if r1 > r2,
    r = [r2 r1];
else
    r = [r1 r2];
end

      