%eulerRotate    Rotate vectors by the specified Euler angles
%
%   r = eulerRotate(v, euler)
%   r = eulerRotate(v, phi, theta, psi)
%
%   r           The rotated vectors (3xN)
%
%   v           The vectors to be rotated.
%
%   euler       The euler angles (radians) to rotate the vectors as
%               [phi theta psi]
%
%   phi theta psi  The euler angles (radians) as separate arguments.
%
%
%   eulerRotate rotates the vectors v by the Euler angles specified.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/10/28 06:49:44 $
%
%  $Revision: 
%
%  $Log: eulerRotate.m,v $
%  Revision 1.3  2004/10/28 06:49:44  rickg
%  Change computation structue
%
%  Revision 1.2  2004/08/24 22:02:44  rickg
%  Help update
%
%  Revision 1.1  2004/07/30 19:08:20  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function r = eulerRotate(v, phi, theta, psi)

% Handle the different calling signatures
if nargin < 3
  psi = phi(3);
  theta = phi(2);
  phi = phi(1);
end

rotPhi = [ ...
  cos(phi) -sin(phi) 0
  sin(phi) cos(phi)  0
  0        0         1];

rotTheta = [ ...
  1  0        0
  0  cos(theta) -sin(theta)
  0  sin(theta) cos(theta) ];

rotPsi = [ ...
  cos(psi) -sin(psi) 0
  sin(psi) cos(psi)  0
  0        0         1];

rotMatrix = rotPsi * rotTheta * rotPhi;

% Apply the rotation matrix
r = rotMatrix * v;
