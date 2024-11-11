%bilinearRotate2    2D bilinear rotation
%
%   r = bilinRotate2(x, angle)
%
%   r           The rotated image
%
%   x           The image to rotate
%
%   angle       The rotation angle of the 2D sequence
%
%
%   Rotates around the center of the matrix, assumed unit sampling grid
%
%   Calls: none.
%
%   See also: bilinearInterp2
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/21 00:33:09 $
%
%  $Revision: 1.1 $
%
%  $Log: bilinearRotate2.m,v $
%  Revision 1.1  2004/01/21 00:33:09  rickg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function zi = bilinearRotate2(x, angle)

theta = angle * pi / 180;

% Compute the dimensions needed to encompass the rotated domain
[nY nX] = size(x);
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

% Shift the intperolation position


inArray = find((abs(xi) < (nX-1)/2) & (abs(yi) < (nY-1)/2));
zi = zeros(length(yiSa), length(xiSa));
zi(inArray) = ...
    bilinearInterp2(x, xi(inArray) + (nX-1)/2, yi(inArray) + (nY-1)/2);
