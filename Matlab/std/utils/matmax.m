%MATMAX         Find the maximum element of a matrix, along with it's indicies.
%
%   [val, row, col] = matmax(X)
%
%   val     The value of the maximum element.
%
%   row     The row index of the maximum element.
%
%   col     The column index of the maximum element.
%
%   For complex values the absolute value is automatically computed (see MIN,
%   MAX).
%
%   See also: MATMIN, MIN, MAX

function [val, row, col] = matmax(X);

[val col] = max(max(X));
[val row] = max(max(X.'));
 
