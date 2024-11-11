%mapCart2Tube   Map cartesian coordinates to tube cordinates
%
%   tubeCoord = mapCart2Tube(tubePos, points, delta)
%
%   tubeCoord   The position of the points in the tube domain
%
%   tubePos     The points defining the line segments along which
%               the data was interpolated (Mx3).
%
%   points      The coordinates of the indices to compute (Nx3).
%
%   delta       A 3 element vector specifying the sample spacing of the planes
%               The first element specifies the inter-plane spacing, the
%               second specifies the sample spacing in the X-Y plane, and the
%               third specifies the sample spacing in the Z dimension.
%
%   mapTube2Cart computes the positions of coordinates specified by points in
%   data tube generated from interpTube.
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
%  $Log: mapCart2Tube.m,v $
%  Revision 1.1  2004/07/14 23:20:43  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tubeCoord, idxSegment] = mapCart2Tube(tubePos, points, delta)
if nargin > 2
  warning('delta is not yet implemented!');
end

%  Loop over each point
%  TODO vectorize
nPoints = size(points, 1);
nTubePos = size(tubePos, 1);

%  Compute the vector and length of each segment and the cumulative length 
%  up to a given segment
tubeVec = tubePos(2:end, :) - tubePos(1:end-1, :);
segmentLength = sqrt(sum(tubeVec .^2, 2));
cumSegLength = cumsum([0 ; segmentLength]);

tubeCoord = zeros(nPoints, 3);
idxSegment = zeros(nPoints, 1);

for i = 1:nPoints
  %  Calculate the vector from each tube point to the point being matched.
  %  Exclude the last because we don't want to interpolate past the end of the
  %  tube.
  diffVec = repmat(points(i,:), nTubePos-1, 1) - tubePos(1:end-1,:);

  %  project each difference vector onto the vector for each segment and
  %  normalize by the segment length
  projDist = sum(diffVec .* tubeVec, 2) ./ (segmentLength) .^ 2;
  
  %  Find the first non-negative projection distance less than or equal to one
  pairIndex = find((projDist >= 0) & (projDist <= 1));
  
  if isempty(pairIndex)
    points(i,:)
    fprintf('Point %d is not in the tube domain\n', i)
    error('Argument out of range');
  end

  idxSegment(i) = pairIndex(1);

  %  calculate the projection along the line segment this point is and compute
  %  the total distance along the contour the point is
  normTubeVec = tubeVec(idxSegment(i), :) ./ segmentLength(idxSegment(i));
  remDist = diffVec(idxSegment(i), :) * normTubeVec';
  tubeCoord(i, 1) = remDist + cumSegLength(idxSegment(i));

  %  Compute the off line coordinates
  offLine = diffVec(idxSegment(i), :) - remDist * normTubeVec;
  R = rot3D(tubeVec(idxSegment(i), :));
  tubeCoord(i, 2) = offLine * R *[ 0 1 0]';
  tubeCoord(i, 3) = offLine * R *[ 0 0 1]';
end
