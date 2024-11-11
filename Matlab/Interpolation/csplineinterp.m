%csplineinterp  Compute the cubic B-spline interpolation for the given values.
%
%   yi = csplineinterp(c, xi)
%
%   yi          The interpolated values
%
%   c           The cubic B-spline coefficients
%
%   xi          The interpolation positions.
%
%
%   Given a cubic B-spline model (set of coefficients) and a set of
%   interpolation positions csplineinterp computes the cubic B-spline
%   interpolant values.  The model is assumed to be based on integer samples
%   thus the interpolation positions must be in the range [0, length(c)-1].
%
%   Calls: none
%
%   See also: csplinecoeff
%
%   Bugs: not sure if the interpolations for the first and last segment are
%         being calculated correctly since we don't exactly what to with the
%         boundary conditions


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/09/05 20:07:28 $
%
%  $Revision: 1.3 $
%
%  $Log: csplineinterp.m,v $
%  Revision 1.3  2004/09/05 20:07:28  rickg
%  Shift sample location by, correct?
%
%  Revision 1.2  2004/01/06 00:53:40  rickg
%  Comment updates
%
%  Revision 1.1  2004/01/03 18:14:54  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function yi = csplineinterp(c, xi)
c = [c(1); c; c(end)];
xi = xi + 1;
nSa = length(xi);
yi = zeros(size(xi));
for i = 1:nSa
  kmin = floor(xi(i)) - 1;

  a1arg = xi(i) - kmin;
  a1 = c(kmin+1) * (2 - abs(a1arg))^3 / 6;

  a2arg = a1arg - 1;
  a2 = c(kmin+2) * (abs(a2arg)^3 / 2 - a2arg^2 + 2/3);

  a3arg = a2arg - 1;
  a3 = c(kmin+3) * (abs(a3arg)^3 / 2 - a3arg^2 + 2/3);

  a4arg = a3arg - 1;
  a4 = c(kmin+4) * (2 - abs(a4arg))^3 / 6;

  yi(i) = a1 + a2 + a3 + a4;
end
