%zeroproj       Zero projection data out of the volume of interest
%
%  r = zeroproj(r, theta, thickness)
function r = zeroproj(r, theta, thickness)

[nProj nTheta] = size(r)
mid = nProj / 2;

% length of a line from the center of the image to the corner and offset
% angle (alpha) of the line w.r.t the projection angle

l = sqrt(mid^2 + (thickness/2)^2);
alpha = atan(thickness / 2 / mid);

% calculate the number of zeroed entries at both ends of the projection for
% each projection
% FIXME angles < 0 or > 2*pi
theta = theta * pi / 180;
nZeros = zeros(size(theta));

idxQuad1Quad3 = [find(theta >= 0 & theta < pi/2) ...
                 find(theta >= pi & theta < 3*pi/2)];
nZeros(idxQuad1Quad3) = floor(mid - l * abs(cos(theta(idxQuad1Quad3) - alpha)));

idxQuad2Quad4 = [find(theta >= pi/2 & theta < pi) ...
                 find(theta >= 3*pi/2 & theta < 2*pi)];
nZeros(idxQuad2Quad4) = floor(mid - l * abs(cos(theta(idxQuad2Quad4) + alpha)));

nZeros = max(nZeros, 0);
mid - max(nZeros)

for i = 1:nTheta
  r(1:nZeros(i), i) = 0;
  r(end-nZeros(i)+1:end, i) = 0;
end
