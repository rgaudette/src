%cubicConvRotate2   2D cubic convolution rotation
%
%   r = cubicConvRotate2(z, angle)
%
%   r           The rotated image
%
%   z           The image to rotate
%
%   angle       The rotation angle of the 2D sequence
%
%
%   Rotates around the center of the matrix, assumed unit sampling grid
%
%   Calls: none.
%
%   See also: cbscoeff2.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/21 00:49:18 $
%
%  $Revision: 1.1 $
%
%  $Log: cubicConvRotate2.m,v $
%  Revision 1.1  2004/01/21 00:49:18  rickg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function zi = cubicConvRotate2(z, angle)

theta = angle * pi / 180;

% Compute the sample positions for z
[nY nX] = size(z);
xSaMax = (nX-1)/2;
xSa = -xSaMax:xSaMax;
ySaMax = (nY-1)/2;
ySa = [-ySaMax:ySaMax]';

% Create a sample domain for zi that complete encompasses the rotated
% domain of z
[nY nX] = size(z);
diagonal =  sqrt((nX-1)^2 + (nY-1)^2);
alpha = atan(nY/nX);
xdist = max(abs([cos(theta + alpha) cos(theta - alpha)])) * diagonal;
ydist = max(abs([sin(theta + alpha) sin(theta - alpha)])) * diagonal;

% Define the sample positions for the rotated domain
if rem(nX, 2)
  l = floor(xdist/2 + 1);
  upper = [1:l];
  xiSa = [-1*fliplr(upper) 0 upper];
  l = floor(ydist/2 + 1);
  upper = [1:l];
  yiSa = [-1*fliplr(upper) 0 upper];
else
  l = floor(xdist/2 + 1);
  upper = [0.5:l];
  xiSa = [-1*fliplr(upper) upper];
  l = floor(ydist/2 + 1);
  upper = [0.5:l];
  yiSa = [-1*fliplr(upper) upper];
end

[ys xs] = ndgrid(yiSa, xiSa);

rotPos = [cos(theta) sin(theta); -sin(theta) cos(theta)] * [xs(:)' ; ys(:)'];
xi = rotPos(1,:);
yi = rotPos(2,:);
inArray = find((abs(xi) < (nX-1)/2-1) & (abs(yi) < (nY-1)/2-1));

zi = zeros(length(yiSa), length(xiSa));
zi(inArray) = cubicConvInterp2(xSa, ySa, z, ...
                               xi(inArray), yi(inArray));
