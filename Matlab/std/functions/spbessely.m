%SPBESSELY      Spherical bessel function of the second kind.
%
%   [y iErr] = spbessely(l, z)
%
%   y           The value of the selected spherical Bessel function
%               evaluated at z.
%
%   iErr        Error code, see bessely.
%
%   l           The order of the Bessel function to evaluate.
%
%   z           The argument of the Bessel function.
%
%   SPBESSELY computes the lth order spherical Bessel function (y_l) for all
%   of the elements in z.  This is related to the standard (cylidrical)
%   Bessel function (Y_l) by the relation
%
%      y_l(z) = sqrt(pi / (2 * z)) * Y_l+0.5(z).
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
%  $Log: spbessely.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:04  rickg
%  Matlab Source
%
%  Revision 1.0  1999/02/04 21:22:45  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y, iErr] = spbessely(l, z)

[Y iErr] = bessely(l+0.5, z);

y = sqrt(pi ./ (2 * z)) .* Y;
