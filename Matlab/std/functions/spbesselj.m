%SPBESSELJ      Spherical Bessel function of the first kind.
%
%   [j iErr] = spbesselj(l, z)
%
%   j           The value of the selected spherical Bessel function
%               evaluated at z.
%
%   iErr        Error code, see besselj.
%
%   l           The order of the Bessel function to evaluate.
%
%   z           The argument of the Bessel function.
%
%   SPBESSELJ computes the lth order spherical Bessel function (j_l) for all
%   of the elements in z.  This is related to the standard (cylidrical)
%   Bessel function (J_l) by the relation
%
%      j_l(z) = sqrt(pi / (2 * z)) * J_l+0.5(z).
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
%  $Log: spbesselj.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:04  rickg
%  Matlab Source
%
%  Revision 1.0  1999/02/04 21:22:38  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [j, iErr] = spbesselj(l, z)

[J iErr] = besselj(l+0.5, z);

j = sqrt(pi ./ (2 * z)) .* J;
