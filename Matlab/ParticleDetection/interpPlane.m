%interpPlane    Interpolate planes from a 3D volume in a MRCImage object
%
%   [planes coord] = ...
%       interpPlane(mRCImage, center, normal, delta, dimension, method)
%
%   planes      The interpolated planes
%
%   coord       The coordinates of each sample location in the volume.  This
%               is a (M*N)x3 element array where M is the number of samples in
%               a plane and N is the number of planes.  The columns index the
%               X, Y, and Z dimensions respectively.
%
%   volume      The 3D volume data to be interpolated.
%
%   center      An Nx3 matrix specifying the center of each plane.
%
%   normal      A vector or vectors specifying the normal to each plane, if
%               only a single vector is specified then it is used for all
%               planes.
%
%   delta       A 2 element vector specifying the sample spacing.  The first
%               element specifies the spacing in the X-Y plane, the second in
%               the Z dimension.
%
%   dimension   A 2 element vector specifying dimensions of the plane(s).  The
%               first element specifies the dimension on the X-y plane, the
%               second is the size of the interpolation plane in the Z
%               dimension.
%
%   method      The method used to interpolate the data.
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none
%
%   Bugs: MRCImage.getVolume

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/07/14 23:20:43 $
%
%  $Revision: 1.1 $
%
%  $Log: interpPlane.m,v $
%  Revision 1.1  2004/07/14 23:20:43  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [planes, coords] = interpPlane(mRCImage, center, normal, delta, ...
                                        dimension, method)

% Replicate the normal vector
nPoints = size(center, 1);
if size(normal, 1) == 1
   normal = repmat(normal, nPoints, 1);
end

% Loop over each center calculating the sample coordinates associated with each
% center 
% TODO this can all be vectorized
upperHalf = [0:delta(1):dimension(1)/2];
deltaXY = [fliplr(-1 * upperHalf(2:end)) upperHalf]';
nXY = length(deltaXY);
upperHalf = [0:delta(2):dimension(2)/2];
deltaZ = [fliplr(-1 * upperHalf(2:end)) upperHalf]';
nZ = length(deltaZ);

% allocate the output arrays
planes = zeros(nXY, nZ, nPoints);
coords = zeros(nXY, nZ, 3, nPoints);

%  Construct the plane coordinates for each point
for i = 1:nPoints
  % rotate the normal vector by pi/2 and normalize
  inPlane = [normal(i,2) -1*normal(i,1)];
  inPlane = inPlane ./ norm(inPlane);
  rotCoordXY = deltaXY * inPlane;
  
  for j = 1:nZ
    coords(:, j, :, i) = [rotCoordXY repmat(deltaZ(j), nXY, 1)] ...
        + repmat(center(i,:), nXY, 1);
  end
end
%  TODO Reorganize coordinate reshaping
coords = reshape(coords, nXY * nZ, 3, nPoints);
coords = reshape(permute(coords, [1 3 2]), nXY * nZ * nPoints, 3);

% Extract a cube of data that encompasses all of the coord locations along with
% a buffer for the interpolation
minVector = floor(min(coords));
maxVector = ceil(max(coords));

% Test function
%plotBoxes(center, minVector, maxVector)
volume = double(getVolume(mRCImage, ...
                   [minVector(1) maxVector(1)], ...
                   [minVector(2) maxVector(2)], ...
                   [minVector(3) maxVector(3)]));

%  Interpolate the data at the given coordinates
%
[idxX idxY idxZ] = ndgrid([minVector(1):maxVector(1)], ...
                   [minVector(2):maxVector(2)], ...
                   [minVector(3):maxVector(3)]);
% NOTE: Since the MRC Data is in row raster format and MATLAB indexes in
% column raster format the notion of X and Y are reversed for the
% interpolation
planes = interp3(idxY, idxX, idxZ, volume, ...
                 coords(:, 2), coords(:, 1), coords(:, 3), method);
planes = reshape(planes, nXY, nZ, nPoints);

%
%  Debug and validation functions
function plotBoxes(center, minVector, maxVector)
plot3(center(:, 1), center(:, 2), center(:, 3), 'r')
hold on
% x min draw
drawvec = [minVector(1) minVector(2) minVector(3)
           minVector(1) minVector(2) maxVector(3)
           minVector(1) maxVector(2) maxVector(3)
           minVector(1) maxVector(2) minVector(3)
           minVector(1) minVector(2) minVector(3) ];
plot3(drawvec(:,1), drawvec(:,2), drawvec(:,3))

% x max draw
drawvec = [maxVector(1) minVector(2) minVector(3)
           maxVector(1) minVector(2) maxVector(3)
           maxVector(1) maxVector(2) maxVector(3)
           maxVector(1) maxVector(2) minVector(3)
           maxVector(1) minVector(2) minVector(3) ];
plot3(drawvec(:,1), drawvec(:,2), drawvec(:,3))

% y min draw
drawvec = [minVector(1) minVector(2) minVector(3)
           minVector(1) minVector(2) maxVector(3)
           maxVector(1) minVector(2) maxVector(3)
           maxVector(1) minVector(2) minVector(3)
           minVector(1) minVector(2) minVector(3) ];
plot3(drawvec(:,1), drawvec(:,2), drawvec(:,3))

% y max draw
drawvec = [minVector(1) maxVector(2) minVector(3)
           minVector(1) maxVector(2) maxVector(3)
           maxVector(1) maxVector(2) maxVector(3)
           maxVector(1) maxVector(2) minVector(3)
           minVector(1) maxVector(2) minVector(3) ];
plot3(drawvec(:,1), drawvec(:,2), drawvec(:,3))
