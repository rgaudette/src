%lineSamp       Calculate the uniformly sampled points on a 3D line
%
%   [points remainder] = lineSamp(p1, p2, delta, offset)
%
%   points      The Nx3 array of three space sample locations
%
%   remainder   The distance from the last sample location to p2
%
%   p1, p2      The starting and ending points of the 3D line
%
%   delta       The sample spacing
%
%   offset      OPTIONAL: The offset distance for the first point
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
%  $Date: 2004/07/14 23:20:43 $
%
%  $Revision: 1.1 $
%
%  $Log: lineSamp.m,v $
%  Revision 1.1  2004/07/14 23:20:43  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [points, remainder] = lineSamp(p1, p2, delta, offset)

if nargin < 4
  offset = 0;
end

% Calcuate azimuth and elevation angles from line end points
%   theta - azimuthal angle (in the X-Y plane from the X axis)
%   phi - polar angle from the Z axis
dist = p2 - p1;
r = norm(dist);

warning off MATLAB:divideByZero
theta = atan2(dist(2), dist(1));
warning on MATLAB:divideByZero

phi = acos(dist(3) / r);

% Calculate the distances along the line of the sample points
rSamp = [offset:delta:r]';
remainder = r - rSamp(end);

% Find the cartesian coordinates of each sample
points = [rSamp*sin(phi)*cos(theta)+p1(1) ...
          rSamp*sin(phi)*sin(theta)+p1(2) ...
          rSamp*cos(phi)+p1(3) ];
