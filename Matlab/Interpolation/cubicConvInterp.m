%cubicConvInterp    Cubic convolution 1D interpolation
%
%   yi = cubicConvInterp(x, y, xi)
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
%  $Date: 2004/01/21 00:49:03 $
%
%  $Revision: 1.1 $
%
%  $Log: cubicConvInterp.m,v $
%  Revision 1.1  2004/01/21 00:49:03  rickg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function yi = cubicConvInterp(x, y, xi)

% Loop over each requested interpolation point
% TODO this should be vectorized
nPoints = length(xi);
for i = 1:nPoints
  % find the sample just less the interpolation point
  tmp = find(xi(i) <= x);
  if length(tmp) < 2
    error(['Not enough real points to inpterpolate: ' num2str(xi(i))]);
  end
  iHigh = tmp(1);
  delX = xi(i) - x(iHigh-1);
  
  yi(i) = delX * ...
          (delX * ...
           (delX * ...
            (y(iHigh+1) - y(iHigh) + y(iHigh-1) - y(iHigh-2)) ...
            + (y(iHigh) - y(iHigh+1) - 2 * y(iHigh-1) + 2 * y(iHigh-2))) ...
           + (y(iHigh) - y(iHigh-2))) ...
          + y(iHigh-1);
end
