%MATMIN         Find the minimum element of a matrix, along with it's indicies.
%
%   [val, row, col] = matmin(X)
%
%   val     The value of the minimum element.
%
%   row     The row index of the minimum element.
%
%   col     The column index of the minimum element.
%
%   For complex values the absolute value is automatically computed (see MIN,
%   MAX).
%
%   See also: MATMAX, MIN, MAX

function [val, row, col] = matmin(X);

[val col] = min(min(X));
[val row] = min(min(X.'));
 
