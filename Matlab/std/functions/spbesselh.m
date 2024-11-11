%SPBESSELH      Spherical Hankel function .
%
%   [h iErr] = spbesselh(l, k, z)
%
%   h           The value of the selected spherical Hankel function
%               evaluated at z.
%
%   iErr        Error code, see besselh.
%
%   l           The order of the Hankel function to evaluate.
%
%   k           The kind of Hankel function (1 or 2).
%
%   z           The argument of the Bessel function.
%
%   SPBESSELH computes the lth order spherical Hankel function (h_l) for all
%   of the elements in z.  This is related to the standard (cylidrical)
%   Hankel function (H_l) by the relation
%
%      h_l(z) = sqrt(pi / (2 * z)) * H_l+0.5(z).
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
%  $Log: spbesselh.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:04  rickg
%  Matlab Source
%
%  Revision 1.0  1999/02/04 21:22:31  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [h, iErr] = spbesselh(l, k, z)

[H iErr] = besselh(l+0.5, k, z);

h = sqrt(pi ./ (2 * z)) .* H;
