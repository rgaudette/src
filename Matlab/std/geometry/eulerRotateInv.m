%eulerRotateInv Inverse rotate vectors by the specified Euler angles
%
%   r = eulerRotateInv(v, euler)
%   r = eulerRotateInv(v, phi, theta, psi)
%
%   r           The rotated vectors
%
%   v           The vectors to be rotated.
%
%   euler       The euler angles (radians) to rotate the vectors as
%               [phi theta psi]
%
%   phi theta psi  The euler angles (radians) as separate arguments.
%
%
%   eulerRotate rotates the vectors v by the Euler angles specified inverting
%   the standard order of rotation steps.  This algorithm rotates by psi first,
%   theta second, and phi third.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/10/29 18:31:59 $
%
%  $Revision: 
%
%  $Log: eulerRotateInv.m,v $
%  Revision 1.4  2004/10/29 18:31:59  rickg
%  Surpress intermediate output
%
%  Revision 1.3  2004/10/28 06:49:44  rickg
%  Change computation structue
%
%  Revision 1.2  2004/08/17 17:13:31  rickg
%  Fixed bug in output of rotation vectors.
%
%  Revision 1.1  2004/08/16 23:30:52  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function r = eulerRotateInv(v, phi, theta, psi)

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

rotMatrix = rotPhi * rotTheta * rotPsi;

% Apply the rotation matrix
r = rotMatrix * v;
