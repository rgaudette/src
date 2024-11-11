%zyx2Euler      Convert a Z-Y-X rotate to an Euler rotation
%
%   euler = zyx2Euler(zyxRotation)
%
%   euler       The euler angles in the format [phi theta psi](radians) 
%
%   zyxRotation The rotation angle in the format [X Y Z] (radians)
%
%
%   zyx2Euler converts a Z-Y-X rotation sequence to a Euler angle rotation.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/01/11 23:57:51 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function euler = zyx2Euler(zyxRotation)

% Rotate the unit vectors by the Z Y X rotation sequence
unitVecs = [1 0 0
            0 1 0
            0 0 1 ];
rotVecs = [ ...
  cos(zyxRotation(3)) -sin(zyxRotation(3)) 0
  sin(zyxRotation(3))  cos(zyxRotation(3)) 0
  0                    0                   1 ] * unitVecs;

% Rotation around the Y axis: using the right hand rule with the positive y
% axis pointing towards the observer the negative X direction is towards
% the right and the positive z direction is upwards.  This results in a
% sign change on the sin terms.
rotVecs = [ ...
  cos(zyxRotation(2))  0  sin(zyxRotation(2))
  0                    1  0
  -sin(zyxRotation(2))  0  cos(zyxRotation(2))] * rotVecs;

rotVecs = [ ...
  1                   0                    0
  0 cos(zyxRotation(1)) -sin(zyxRotation(1))
  0 sin(zyxRotation(1))  cos(zyxRotation(1)) ] * rotVecs;


% Calculate the combined rotation angles
theta = acos(rotVecs(3, 3));
tol = 2 * sqrt(eps);
if abs(theta) < tol
  theta = 0;
  psi = 0;
  phi = atan2(rotVecs(2,1), rotVecs(1,1));
elseif abs(theta - pi) < tol
  theta = pi;
  psi = 0;
  phi = atan2(-rotVecs(2,1), rotVecs(1,1));
else
  psi = atan2(rotVecs(1,3), -rotVecs(2,3));
  phi = atan2(rotVecs(3,1), rotVecs(3,2));
end
euler = [phi theta psi];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: zyx2Euler.m,v $
%  Revision 1.2  2005/01/11 23:57:51  rickg
%  Fixed Y rotation, it is inverted compared to X and Z
%
%  Revision 1.1  2004/11/01 15:29:11  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
