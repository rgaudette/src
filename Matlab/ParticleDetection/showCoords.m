%showCoords     Display the sample coordinates from planeInterp
%
%  showCoords(coord, center)

function showCoords(coord, center)

clf
nPlanes = size(coord, 3);
hold on
cs = ['r'; 'g'; 'c'; 'b'; 'm'; 'k'];
for i = 1:nPlanes
  plot3(coord(:, 1, i), coord(:, 2, i), coord(:, 3, i), ...
        ['o' cs(rem(i, length(cs))+1)] );
end

if nargin > 1
  plot3(center(:,1), center(:,2), center(:,3))
end

xlabel('X axis')
ylabel('Y axis')
zlabel('Z axis')
