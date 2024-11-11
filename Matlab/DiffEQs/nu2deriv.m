%NU2DERIV       2nd derivative estimate of a non-uniformly sampled function
%
%   [d2f_dx2, dx2] = nu2deriv(x, f)
%
%   d2f_dx2     The second derivative estimate of the function f.
%
%   dx2         The points at which the second derivative is estimated.
%
%   x           The points at which the function f is evaluated.
%
%   f           The function to be evaluated
%
%   NU2DERIV estimates the second derivative of a non-uniformly sampled
%   function and returns both the estimates of second derivative and the
%   position at which the estimate was calculated.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:23:59 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: nu2deriv.m,v $
%  Revision 1.1.1.1  2004/01/03 08:23:59  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d2f_dx2, dx2] = nu2deriv(x, f)

d2f_dx2 = diff(diff(f) ./ diff(x)) ./ (0.5 * (x(3:end) - x(1:end-2)));

dx2 = 0.25 * (x(3:end) + 2 * x(2:end-1) + x(1:end-2));
