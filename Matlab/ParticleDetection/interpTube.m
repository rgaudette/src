%interpTube     Interpolate a "tube" from a 3D volume in a MRCImage object
%
%   [tube R coords wireFrame] = ...
%       interpTube(mRCImage, points, delta, dimension, method)
%
%   tube        The interpolated planes.
%
%   R           The set off rotation matrices used to rotate a X vector to
%               the direction of each line segment.
%
%   coords      The coordinates of each sample location in the volume.  This
%               is a Mx3xN element array where M is the number of samples in
%               a plane and N is the number of planes.  The columns index the
%               X, Y, and Z dimensions respectively.
%
%   wireFrame   An 8x3xN array identifying the boundaries of the each of the
%               N tubes generated.
%
%   mRCImage    The 3D volume data to be interpolated as a MRCImage object.
%
%   points      The points defining the line segments along which
%               the data will be interpolated.
%
%   delta       A 3 element vector specifying the sample spacing of the planes
%               The first element specifies the inter-plane spacing, the
%               second specifies the sample spacing in the X-Y plane, and the
%               third specifies the sample spacing in the Z dimension.
%
%   dimension   A 2 element vector specifying the size of the sample plane.
%               The first element specifies the X-Y plane size and the
%               second specifies the Z dimension size.
%
%   method      The interpolation method (from interp3).
%               'nearest' - nearest neighbor interpolation
%               'linear'  - linear interpolation
%               'cubic'   - cubic interpolation
%               'spline'  - spline interpolation
% 
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: lineSamp, interpPlane
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/07/14 23:20:43 $
%
%  $Revision: 1.1 $
%
%  $Log: interpTube.m,v $
%  Revision 1.1  2004/07/14 23:20:43  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tube, R, yInterp, zInterp, coords, wireFrame] = ...
    interpTube(mRCImage, points, delta, dimension, method)

% Loop through the points getting the sample planes
nPoints = size(points, 1);
pointVec = points(2:end, :) - points(1:end-1, :);
pointLength = sqrt(sum(pointVec .^2, 2));

% Define the interpolation locations in the plane normal to the line segments
yInterp = [0:delta(2):dimension(1)/2];
yInterp = [fliplr(-yInterp(2:end)) yInterp];
zInterp = [0:delta(3):dimension(2)/2];
zInterp = [fliplr(-zInterp(2:end)) zInterp];

% Set the remainder such that first sample point is at the beggining of the
% model
remainder = delta(1);
tube = [];
R = zeros(3,3,nPoints-1);
coords = [];
wireFrameX = [];
wireFrameY = [];
wireFrameZ = [];

fprintf('Segment: ');
for iPoint = 1:nPoints-1
  fprintf('%d ', iPoint);
  %  calculate the amount to shift the interpolation volume due the remainder
  %  from the last line segment
  offset = delta(1) - remainder;

  %  Calculate the interpolation locations along the x-axis
  xInterp = [offset:delta(1):pointLength(iPoint)];
  remainder = pointLength(iPoint) - xInterp(end);
  if ~isempty(xInterp)
    [xLoc yLoc zLoc] = ndgrid(xInterp, yInterp, zInterp);
    interpSize = size(xLoc);
    interpLoc = [xLoc(:) yLoc(:) zLoc(:)];
  
    %  Rotate then shift  interpolation grid to match the direction of the
    %  model vector and position of the start of the model segment
    %  The 0.5 term is to shift IMOD model coordinates to MATLAB 1 base
    %  indexing
    R(:,:,iPoint) = rot3D(pointVec(iPoint, :));
    interpLoc = (R(:,:,iPoint) * interpLoc')';

    interpLoc(:, 1) = interpLoc(:, 1) + (points(iPoint, 1) + 0.5);
    interpLocX = reshape(interpLoc(:, 1), interpSize);
    wireFrameX = [wireFrameX ...
                  interpLocX(1,1,1) interpLocX(end,1,1) ...
                  interpLocX(end,end,1) interpLocX(1,end,1) ...
                  interpLocX(1,1,end) interpLocX(end,1,end) ...
                  interpLocX(end,end,end) interpLocX(1,end,end)];
    
    interpLoc(:, 2) = interpLoc(:, 2) + (points(iPoint, 2) + 0.5);
    interpLocY = reshape(interpLoc(:, 2), interpSize);
    wireFrameY = [wireFrameY ...
                  interpLocY(1,1,1) interpLocY(end,1,1) ...
                  interpLocY(end,end,1) interpLocY(1,end,1) ...
                  interpLocY(1,1,end) interpLocY(end,1,end) ...
                  interpLocY(end,end,end) interpLocY(1,end,end)];
     
    interpLoc(:, 3) = interpLoc(:, 3) + (points(iPoint, 3) + 0.5);
    interpLocZ = reshape(interpLoc(:, 3), interpSize);
    wireFrameZ = [wireFrameZ ...
                  interpLocZ(1,1,1) interpLocZ(end,1,1) ...
                  interpLocZ(end,end,1) interpLocZ(1,end,1) ...
                  interpLocZ(1,1,end) interpLocZ(end,1,end) ...
                  interpLocZ(end,end,end) interpLocZ(1,end,end)];
     
    % Extract a cube of data from the volume and interpolate the to the new
    % locattions
    idxMin = floor(min(interpLoc));
    idxMax = ceil(max(interpLoc));
    
    volume = double(getVolume(mRCImage, ...
                       [idxMin(1) idxMax(1)], ...
                       [idxMin(2) idxMax(2)], ...
                       [idxMin(3) idxMax(3)]));
    
    thisTube = interpn([idxMin(1):idxMax(1)], ...
                       [idxMin(2):idxMax(2)], ...
                       [idxMin(3):idxMax(3)], ...
                       volume, ...
                       interpLocX, interpLocY, interpLocZ, ...
                       method);
    tube = [tube; thisTube];
  else
    fprintf('Empty segment: %d\n', iPoint);
  end
end
wireFrame = [reshape(wireFrameX, 8, 1, nPoints-1) ...
             reshape(wireFrameY, 8, 1, nPoints-1) ...
             reshape(wireFrameZ, 8, 1, nPoints-1)];
fprintf('\n');
