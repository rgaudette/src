%rot3D          Compute a 3D rotation matrix
%
%   R = rot3D(theta, phi)
%   R = rot3D(v)
%
%   R           The rotation matrix
%
%   theta       The angle to rotate within the XY plane [radians]
%
%   phi         The angle to rotate out of the XY plane towards the Z axis
%               [radians] 
%
%   v           The angles (theta, phi) are calculate from the vector v
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
%  $Date: 2004/01/03 08:25:09 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rot3D.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:09  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r = rot3D(arg1, phi)
if nargin < 2
  vec = arg1;
  r = sqrt(sum(vec.^2));
  theta = atan2(vec(2), vec(1));
  phi = asin(vec(3) / r);
else
  theta = arg1;
end

rTheta = [cos(theta) -sin(theta) 0
          sin(theta) cos(theta) 0
          0 0 1];

rPhiY = [cos(phi) 0 -sin(phi)
         0 1 0
         sin(phi) 0 cos(phi) ];

% Warning: this still does not seem correct, I would have expected the order
% of operations to be the opposite
r =  rTheta * rPhiY;
