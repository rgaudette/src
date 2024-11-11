%parseStalkModelTest2  Test the parseStalkModel function
clf
% Load in the stalk model
imodStalk = ImodModel('sideview_stalk.mod');

% parse the the stalk model
[imodHead imodCentroid initMotiveList] = parseStalkModel(imodStalk, 0);

nStalk = getNContours(getObject(imodStalk, 1));
for iStalk = 1:nStalk
  % Calculate the stalk vector for each contour
  ptsStalk = getPoints(imodStalk, 1, iStalk);
  vecStalk = ptsStalk(:, 2) - ptsStalk(:, 1);

  % Apply the euler rotations (inverse) that is applied in the
  % motlAveraging function 
  rotStalk = eulerRotateInv(vecStalk, initMotiveList([17 19 18], iStalk) * -pi / 180);
  
  % Plot the rotated vector in 3D
  plot3([0 rotStalk(1)], [0 rotStalk(2)], [0 rotStalk(3)], '-')
  hold on
  plot3(rotStalk(1), rotStalk(2), rotStalk(3), 'v')
  xlabel('X')
  ylabel('Y')
  zlabel('Z')
end
grid on
