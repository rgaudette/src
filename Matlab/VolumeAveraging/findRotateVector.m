%findRotateVector Find the euler rotation angles to rotate v2 to v1
%   [phi, theta, psi] = findRotateVector(v1, v2)
%
%   Phi         The euler angles (degrees) to rotate v2 to v1
%   Theta
%   Psi
%
%   v1          The stationary vector
%
%   v2          The vector to be rotated

function [phi, theta, psi] = findRotateVector(v1, v2)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: findRotateVector.m,v 1.4 2005/08/15 23:17:36 rickg Exp $\n');
end

% Rotate both vectors into the YZ plane and find their difference in theta
phi1 = pi/2 - atan2(v1(2), v1(1));
rot1 = eulerRotate(v1, phi1, 0, 0);
theta1 = atan2(rot1(3), rot1(2));

phi2 = pi/2  - atan2(v2(2), v2(1));
rot2 = eulerRotate(v2, phi2, 0, 0);
theta2 = atan2(rot2(3), rot2(2));
diffTheta = theta1 - theta2;

% Compute the total rotation required to rotate v2 into v1, returning the
% result in degrees
totalRotation = eulerRotateSum([phi2 diffTheta 0], [-phi1 0 0]) * 180 / pi;
phi = totalRotation(1);
theta = totalRotation(2);
psi = totalRotation(3);
