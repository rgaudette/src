%interpTubeTest Test script for interpTube
ax6Model = ImodModel('ax6.mod');
ax6points = getPoints(ax6Model, 1, 1)';

%ax6points = [0 0 0; 10 8 0; 20 12 0; 30 15 3];
%ax6points = [400 1000 100; 1300 200 60]
[tube coords planeLocs] = interpTube(ax6, ax6points, [1 1 1], [20 5], 'nearest');
