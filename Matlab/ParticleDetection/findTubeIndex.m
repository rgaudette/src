%findTubeIndex  Find the index of points along an extracted tube
%
%   indices = findTubeIndex(tubePos, points, delta)
%
%   tubePos   The points defining the line segments along which
%                the data was interpolated (Mx3).
%
%   points       The coordinates of the indices to compute (Nx3).
%
%   delta        A 3 element vector specifying the sample spacing of the planes
%                The first element specifies the inter-plane spacing, the
%                second specifies the sample spacing in the X-Y plane, and the
%                third specifies the sample spacing in the Z dimension.
%
%   FindTubeIndex computes the indices of coordinates specified by points in a
%   data tube generated from interpTube.
%
%   TODO implement delta and off axis calculation
function indices = findTubeIndex(tubePos, points, delta)


%  Loop over each point
%  TODO vectorize
nPoints = size(points, 1);
nTubePos = size(tubePos, 1);

%  Compute the vector and length of each segment and the cumulative length 
%  up to a given segment
tubeVec = tubePos(2:end, :) - tubePos(1:end-1, :);
segmentLength = sqrt(sum(tubeVec .^2, 2));
cumSegLength = cumsum([0 ; segmentLength]);

for i = 1:nPoints
  %  Calculate the vector from each tube point to the point being matched
  %  exclude the last because we don't want to interpolate past the end of the
  %  tube
  diffVec =  repmat(points(i,:), nTubePos-1, 1) - tubePos(1:end-1,:);

  %  project each difference vector onto the vector for each segment and
  %  normalize by the segment length
  projDist = sum(diffVec .* tubeVec, 2) ./ (segmentLength) .^2
  
  %  Find the first non-negative projection distance less than or equal to one
  pairIndex = find((projDist >= 0) & (projDist <= 1));
  
  if isempty(pairIndex)
    fprintf('Point %d is not in the tube domain\n', i)
    error('Argument out of range');
  end
  if length(pairIndex) > 1
    pairIndex = pairIndex(1);
  end

  %  calculate the projection along the line segment this point is and compute
  %  the total distance along the contour the point is
  normTubeVec = tubeVec(pairIndex, :) ./ segmentLength(pairIndex);
  remDist = diffVec(pairIndex, :) * normTubeVec';
  totalDist(i) = remDist + cumSegLength(pairIndex);
end
indices = totalDist;
