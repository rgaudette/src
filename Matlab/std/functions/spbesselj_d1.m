%SPBESSELJ_D1   1st derivative of the spherical Bessel function, first kind.
%
%   [j_p iErr] = spbesselj_d1(l, z)
%
%   j_p         The value of the derivative of the selected spherical Bessel
%               function evaluated at z.
%
%   iErr        Error code, see besselj.
%
%   l           The order of the Bessel function to evaluate.
%
%   z           The argument of the Bessel function.
%
%   SPBESSELJ computes the first derivative of the lth order spherical
%   Bessel function (j_l) for all of the elements in z.  This is related to
%   the standard (cylidrical) Bessel function (J_l) by the relation
%
%     d/dz[j_l(z)] = ...
%         sqrt(pi / (2 * z)) * (J_l-1/2(z) - (l+1) / z  * J_l+1/2(z)).
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
%  $Log: spbesselj_d1.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:04  rickg
%  Matlab Source
%
%  Revision 1.0  1999/02/04 21:22:52  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [j_p, iErr] = spbesselj_d1(l, z)

[Jph iErr1] = besselj(l+0.5, z);
[Jmh iErr2] = besselj(l-0.5, z);

j_p = sqrt(pi ./ (2 * z)) .* (Jmh - (l+1) ./ z .* Jph);
iErr = [iErr1 iErr2];
