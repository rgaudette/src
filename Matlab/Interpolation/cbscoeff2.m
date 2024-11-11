%cbscoeff2      2D cubic B-spline coefficient calculation
%
%   c = cbscoeff2(x, epsilon)
%
%   c           The cubic B-spline coefficients
%
%   x           The 2D sequence to be modeled
%
%   epsilon     OPTIONAL: The required precision (default: eps)
%
%
%   cbscoeff2 computes the 2D cubic B-spline coefficients for the 2D supplied
%   sequence.  The cubic B-spline coefficients are computed via a seperable
%   decompostion along the columns and rows of the sequence
%
%   Calls: csplinecoeff
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/06 00:54:20 $
%
%  $Revision: 1.1 $
%
%  $Log: cbscoeff2.m,v $
%  Revision 1.1  2004/01/06 00:54:20  rickg
%  Intitial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [c, c2] = cbscoeff2(x, epsilon)
if nargin < 2
  epsilon = eps;
end

[nRows nCols] = size(x);

% Compute the cubic B-spline coefficients along the columns of the sequence
colCoeff = zeros(nRows, nCols);
for iCol = 1:nCols
  colCoeff(:, iCol) = csplinecoeff(x(:, iCol), epsilon);
end

% Compute the cubic B-spline coefficients along the rows of the column
% coefficient matrix
c = zeros(nRows, nCols);
for iRow = 1:nRows
  c(iRow, :) = csplinecoeff(colCoeff(iRow, :), epsilon);
end
