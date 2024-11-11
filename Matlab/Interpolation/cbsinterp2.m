%csbinterp2     2D cubic B-spline interpolation
%
%   zi = cbsinterp2(z, c, xi, yi)
%
%   zi          The interpolated values
%
%   z           The original 2D sequence
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
%   Calls: bilinearInterp2.
%
%   See also: cbsinterp2.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/21 00:42:59 $
%
%  $Revision: 1.2 $
%
%  $Log: cbsinterp2.m,v $
%  Revision 1.2  2004/01/21 00:42:59  rickg
%  Bilinear interpolation is performed at the boudary where cubic B-spline
%  interpolation lacks data.
%  Checks for out of range interpolation points
%  Need to supply original 2D samples
%  Faster inperpolation implementation
%  Removed interpPoint private function
%
%  Revision 1.1  2004/01/06 00:54:50  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function zi = cbsinterp2(z, c, xi, yi)

% Argument checking
if prod(size(xi)) ~= prod(size(yi))
  error('xi and yi must have the same number of elements');
end

% Check to see if any of the interpolation points are out of range
[nY nX] = size(c);
if any(xi < 0) | any(xi > (nX - 1))
  error('X sample points out of range')
end
if any(yi < 0) | any(yi > (nY - 1))
  error('Y sample points out of range')
end
zi = zeros(size(xi));


% Split the interpolation point into two group, cubic B-spline interpolation
% and bilinear for the boundaries
inCBS = xi < (nX-2) & xi > 2 & yi < (nY-2) & yi > 2;
idxCBS = find(inCBS);
xBSVal = zeros(1,4);
yBSVal = zeros(4,1);
for i = idxCBS
  k1 = floor(xi(i)) - 1;
  kVec = k1:k1+3;
  l1 = floor(yi(i)) - 1;
  lVec =  l1:l1+3;
  for j = 1:4
    xBSVal(j) = cbspline(xi(i) - kVec(j));
    yBSVal(j) = cbspline(yi(i) - lVec(j));
  end
  zi(i) = sum(sum(yBSVal * xBSVal .* c(lVec+1, kVec+1)));
end

idxBilinear = find(~ inCBS);
zi(idxBilinear) = bilinearInterp2(z, xi(idxBilinear), yi(idxBilinear));

function val = cbspline(x)
absX = abs(x);
if absX < 1
  xsq = x * x;
  val = xsq * absX * 0.5  - xsq + 0.66666666666667;
else
  tmp = 2 - absX;
  val = tmp * tmp * tmp * 0.16666666666667;
end
