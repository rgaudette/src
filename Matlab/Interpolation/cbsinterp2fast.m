%csbinterp2     2D cubic B-spline interpolation
%
%   zi = cbsinterp2(c, xi, yi)
%
%   zi          The interpolated values
%
%   c           The cubic B-spline coefficients
%
%   xi,yi       The interpolation positions.
%
%
%   Given a cubic B-spline model and set of interpolation positions csbinterp2
%   computes the the cubic B-spline interpolant values.  The model is assumed
%   to be based on integer samples thus the interpolation positions must be in
%   the range [0, size(c, i)-1] for dimension i.
%
%   Calls: none.
%
%   See also: cbscoeff2.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/06 00:54:50 $
%
%  $Revision: 1.1 $
%
%  $Log: cbsinterp2.m,v $
%  Revision 1.1  2004/01/06 00:54:50  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function zi = cbsinterp2fast(c, xi, yi)

% Argument checking
if prod(size(xi)) ~= prod(size(yi))
  error('xi and yi must have the same number of elements');
end

zi = zeros(size(xi));

nPoints = prod(size(xi));
for i = 1:nPoints
  zi(i) = interpPoint(c, xi(i), yi(i));
end

function z = interpPoint(c, x, y);

k1 = floor(x) - 1;
l1 = floor(y) - 1;
kron = cbspline(x - [k1:k1+3])' * cbspline(y - [l1:l1+3]);
z =  sum(sum(kron .* c(l1+1:l1+4, k1+1:k1+4)')); 
return
 
% This must be called with an argument of less than 2 in magnitude
function val = cbspline(x)
absX = abs(x);
val = zeros(size(absX));
idxSmall = absX < 1;
xSmall = absX(idxSmall);
val(idxSmall) = xSmall .* xSmall .* (0.5 * xSmall - 1) + 0.66666666666667;
idxLarge = absX >= 1;
val(idxLarge) = (2 - absX(idxLarge)).^3 * 0.16666666666667;
