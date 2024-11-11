%findTubeIndexTest  Test script for findTubeIndex

% A simple one element contour all points on the line
delta = [1 1 1];

tubePos = [0 0 0  
           10 5 3];

points = [0 0 0;
          5 2.5 1.5;
          10 5 3];

indices = findTubeIndex(tubePos, points, delta)


% The same contour with the point off of the line
normal = [-1 -1 5];
points = [5 2.5 1.5] +  5 * normal;
indices = findTubeIndex(tubePos, points, delta)

% Two segment tube with points on each segment
tubePos = [0 0 0
           5 5 5
           10 10 10];
points = [2.5 2.5 2.5
          5 5 5
          7.5 7.5 7.5];
indices = findTubeIndex(tubePos, points, delta)
