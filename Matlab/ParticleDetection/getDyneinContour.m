%getDyneinContour  Compute a dynein contour from a group of dynein points ...
%                  and a MT contour.

function dyneinContour = getDyneinContour(dyneinPoints, mtContour)

% clf
% plot3(mtContour(:,1), mtContour(:,2), mtContour(:,3), 'r');
% hold on
% plot3(mtContour(:,1), mtContour(:,2), mtContour(:,3), 'ro');
% plot3(dyneinPoints(:,1), dyneinPoints(:,2), dyneinPoints(:,3), 'bo');
% grid on


% Loop through the points getting the sample planes
nMTContour = size(mtContour, 1);
mtVec = mtContour(2:end, :) - mtContour(1:end-1, :);
mtLength = sqrt(sum(mtVec .^2, 2));

% Compte the rotation matrix for each contour segment
R = zeros(3, 3, nMTContour-1);
for iMT = 1:nMTContour-1
  R(:,:,iMT) = rot3D(mtVec(iMT, :));
end

tubeDynein = mapCart2Tube(mtContour, dyneinPoints);

%  compute the mean shift vector to move the contour onto each point
shiftSum = [ 0 0 0]';
idxDynPoints = [1:5];
for i = idxDynPoints
  %  Calculate the vector from each tube point to the point being matched
  %  exclude the last because we don't want to interpolate past the end of the
  %  tube
  diffVec = repmat(dyneinPoints(i,:), nMTContour-1, 1) - mtContour(1:end-1,:);

  %  project each difference vector onto the vector for each segment and
  %  normalize by the segment length
  projDist = sum(diffVec .* mtVec, 2) ./ (mtLength) .^2;
  
  %  Find the first non-negative projection distance less than or equal to one
  pairIndex = find((projDist >= 0) & (projDist <= 1));
  
  if isempty(pairIndex)
    fprintf('Point %d is not in the tube domain\n', i)
    error('Argument out of range');
  end
  if length(pairIndex) > 1
    pairIndex = pairIndex(1);
  end

  yShift = R(:,:, pairIndex) * [ 0 1 0]' * tubeDynein(i, 2);
  zShift = R(:,:, pairIndex) * [ 0 0 1]' * tubeDynein(i, 3);
  shiftSum = shiftSum + yShift + zShift;
end
shiftSum  = (shiftSum ./ length(idxDynPoints))';

dyneinContour = mtContour + repmat(shiftSum, size(mtContour, 1), 1);

%plot3(mtContour(:,1)+shiftSum(1), mtContour(:,2)+shiftSum(2), mtContour(:,3)+shiftSum(3), 'g');
%plot3(mtContour(:,1)+shiftSum(1), mtContour(:,2)+shiftSum(2), mtContour(:,3)+shiftSum(3), 'go');

