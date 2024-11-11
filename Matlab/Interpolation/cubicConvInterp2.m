%cubicConvInterp2   Cubic 2D interpolation
%
%   zi = cubicConvInterp2(x, y, z, xi, yi)
%
%   result      Output description
%
%   parm        Input description [units: MKS]
%
%   Optional    OPTIONAL: This parameter is optional (default: value)
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/21 00:49:12 $
%
%  $Revision: 1.1 $
%
%  $Log: cubicConvInterp2.m,v $
%  Revision 1.1  2004/01/21 00:49:12  rickg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function zi = cubicConvInterp2(x, y, z, xi, yi);

% Argument checking
if prod(size(xi)) ~= prod(size(yi))
  error('xi and yi must have the same number of elements');
end
zi = zeros(size(xi));

% Sampling grid must be uniform
x = x(1,:);
y = y(:, 1);
% Loop over each point to be interpolated
nPoints = prod(size(xi));

for i = 1:nPoints
  % Find the region of interest
  tmp = find(yi(i) <= y);
  iRow = tmp(1);
  tmp = find(xi(i) <= x);
  iCol = tmp(1);
  
  % Calculate the interpolant points alongs rows  
  idxX = [iCol-2:iCol+1];
  y1 = cubicConvInterp(x(idxX), z(iRow-2, idxX), xi(i));
  y2 = cubicConvInterp(x(idxX), z(iRow-1, idxX), xi(i));
  y3 = cubicConvInterp(x(idxX), z(iRow, idxX), xi(i));
  y4 = cubicConvInterp(x(idxX), z(iRow+1, idxX), xi(i));
  
  % Interpolate along the column of the row interpolations
  zi(i) = cubicConvInterp([-1:2], [y1 y2 y3 y4], yi(i) - y(iRow-1));
end

