%FIND_ATT       Return the difference between peak of a function and the
%		function evaluated at a specified point.
%
%    diff = find_att(X, Y, Xo);
%
%    X		sample points of the function.
%
%    Y		value of the function at the sample points.
%
%    Xo		sample point of the function to find the attenuation.
%
%    diff	diffference between peak and specfied point.
%
%    The value of the function Xo is linearly interpolated from the two nearest
%  points.

function diff = find_att(X, Y, Xo)

LowIndex = max(find (X < Xo));

coeff =  (Xo - X(LowIndex)) / (X(LowIndex + 1) - X(LowIndex));

Yo = Y(LowIndex) + coeff * (Y(LowIndex + 1) - Y(LowIndex));

Peak = max(max(Y));

diff = Peak - Yo;
