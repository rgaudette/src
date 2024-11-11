%SPBESSELY_D1   1st derivative of the spherical Bessel function, second kind.
%
%   [y_p iErr] = spbessely_d1(l, z)
%
%   y_p         The value of the derivative of the selected spherical Bessel
%               function evaluated at z.
%
%   iErr        Error code, see bessely.
%
%   l           The order of the Bessel function to evaluate.
%
%   z           The argument of the Bessel function.
%
%   SPBESSELY computes the first derivative of the lth order spherical
%   Bessel function (y_l) for all of the elements in z.  This is related to
%   the standard (cylidrical) Bessel function (Y_l) by the relation
%
%     d/dz[y_l(z)] = ...
%         sqrt(pi / (2 * z)) * (Y_l-1/2(z) - (l+1) / z  * Y_l+1/2(z)).
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:04 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: spbessely_d1.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:04  rickg
%  Matlab Source
%
%  Revision 1.0  1999/02/04 21:22:58  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y_p, iErr] = spbessely_d1(l, z)

[Yph iErr1] = bessely(l+0.5, z);
[Ymh iErr2] = bessely(l-0.5, z);

y_p = sqrt(pi ./ (2 * z)) .* (Ymh - (l+1) ./ z .* Yph);
iErr = [iErr1 iErr2];
