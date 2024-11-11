%mapTube2Cart   Map tube coordinates to cartesian cordinates
%
%   cartCoord = mapCart2Tube(tubePos, tubeCord, delta)
%
%   cartCoord   The position of the points in cartesian coordinates
%
%   tubePos     The points defining the line segments along which
%               the data was interpolated (Mx3).
%
%   tubeCoord   The position of the points in the tube domain
%
%   delta       A 3 element vector specifying the sample spacing of the planes
%               The first element specifies the inter-plane spacing, the
%               second specifies the sample spacing in the X-Y plane, and the
%               third specifies the sample spacing in the Z dimension.
%
%   mapTube2Cart computes the 
%
%   TODO implement delta

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/07/14 23:20:43 $
%
%  $Revision: 1.1 $
%
%  $Log: mapTube2Cart.m,v $
%  Revision 1.1  2004/07/14 23:20:43  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cartCoord = mapTube2Cart(tubePos, tubeCoord, delta)

if nargin > 2
  warning('delta is not yet implemented!');
end

%  Compute the vector and length of each segment and the cumulative length 
%  up to a given segment
tubeVec = tubePos(2:end, :) - tubePos(1:end-1, :);
segmentLength = sqrt(sum(tubeVec .^2, 2));
cumSegLength = cumsum([0 ; segmentLength]);

nPoints = size(tubeCoord, 1);
cartCoord = zeros(nPoints, 3);

for i = 1:nPoints
  
  % compute which segment the point is in.
  v = find(tubeCoord(i, 1) <=  cumSegLength);
  if isempty(v)
    fprintf('Point %d is not in the tube domain\n', i)
    error('Argument out of range');
  else
    idxSegment = v(1)-1;
  end
  
  R = rot3D(tubeVec(idxSegment, :));
  % Calculate the shift relative to the beginning of the segment
  dx = tubeCoord(i, 1) - cumSegLength(idxSegment);
  xShift = R * [ 1 0 0]' * dx;
  yShift = R * [ 0 1 0]' * tubeCoord(i, 2);
  zShift = R * [ 0 0 1]' * tubeCoord(i, 3);
  cartCoord(i, :) = tubePos(idxSegment, :) + (xShift + yShift + zShift)';
end
