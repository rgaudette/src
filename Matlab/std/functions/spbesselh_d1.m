%SPBESSELH_D1   1st derivative of the spherical Hankel function.
%
%   [h_p iErr] = spbesselh_d1(l, k, z)
%
%   h_p         The value of the derivative of the selected spherical Hankel
%               function evaluated at z.
%
%   iErr        Error code, see besselh.
%
%   l           The order of the Hankel function to evaluate.
%
%   k           The kind of Hankel function (1 or 2).
%
%   z           The argument of the Hankel function.
%
%   SPBESSELH computes the first derivative of the lth order spherical
%   Hankel function (h_l) for all of the elements in z.  This is related to
%   the standard (cylidrical) Hankel function (H_l) by the relation
%
%     d/dz[h_l(z)] = ...
%         sqrt(pi / (2 * z)) * (H_l-1/2(z) - (l+1) / z  * H_l+1/2(z)).
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
%  $Log: spbesselh_d1.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:04  rickg
%  Matlab Source
%
%  Revision 1.0  1999/02/04 21:23:04  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [h_p, iErr] = spbesselh_d1(l, k, z)

[Hph iErr1] = besselh(l+0.5, k, z);
[Hmh iErr2] = besselh(l-0.5, k, z);

h_p = sqrt(pi ./ (2 * z)) .* (Hmh - (l+1) ./ z .* Hph);
iErr = [iErr1 iErr2];
