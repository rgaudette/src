%eulerRotateSumInv2  Two sequential euler rotations with the second
%                    inverted in order.
%
%   eulerTotal = eulerRotateSum(euler1, euler2)
%
%   eulerTotal  The Euler rotation angles equivalent to the sequential Euler
%               rotations euler1 and euler2.
%
%   euler1,2    The euler angles (radians) to rotate the vectors as
%               [phi theta psi]
%
%
%   eulerRotateSumInv2 computes the single Euler rotation equivalent to the
%   Euler rotation euler1 followed by euler2 with euler2 being performed in
%   inverse order
%
%   Calls: eulerRotate, eulerRotateInv
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/12/15 00:53:06 $
%
%  $Revision: 1.1 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function eulerTotal = eulerRotateSum(euler1, euler2)
unitVecs = [1 0 0
            0 1 0
            0 0 1 ];

rotVecs = eulerRotate(unitVecs, euler1);
rotVecs = eulerRotateInv(rotVecs, euler2);

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
eulerTotal = [phi theta psi];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: eulerRotateSumInv2.m,v $
%  Revision 1.1  2004/12/15 00:53:06  rickg
%  Initial revision
%
%  Revision 1.1  2004/07/30 19:16:46  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
