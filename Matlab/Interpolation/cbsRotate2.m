%csbRotate2     2D cubic B-spline rotation
%
%   r = cbsRotate2(z, angle)
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
%   Calls: cbsinterp2.
%
%   See also: cbscoeff2.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/21 00:33:52 $
%
%  $Revision: 1.1 $
%
%  $Log: cbsRotate2.m,v $
%  Revision 1.1  2004/01/21 00:33:52  rickg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function zi = cbsRotate2(z, angle)

theta = angle * pi / 180;

% Compute the cubic B-spline coefficients for the matrix
cbsc = cbscoeff2(z);

% Compute the dimensions needed to encompass the rotated domain
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

inArray = find((abs(xi) < (nX-1)/2) & (abs(yi) < (nY-1)/2));
zi = zeros(length(yiSa), length(xiSa));
zi(inArray) = cbsinterp2(z, cbsc, ...
                         xi(inArray) + (nX-1)/2, yi(inArray) + (nY-1)/2);
