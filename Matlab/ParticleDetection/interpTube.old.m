%interpTube     Interpolate a "tube" from a 3D volume in a MRCImage object
%
%   [tube coords planeLocs] = ...
%       interpTube(mRCImage, points, delta, dimension, method)
%
%   tube        The interpolated planes.
%
%   coords      The coordinates of each sample location in the volume.  This
%               is a Mx3xN element array where M is the number of samples in
%               a plane and N is the number of planes.  The columns index the
%               X, Y, and Z dimensions respectively.
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
%  $Log: interpTube.old.m,v $
%  Revision 1.1  2004/07/14 23:20:43  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tube, coords, planeLocs] = ...
    interpTube(mRCImage, points, delta, dimension, method)

% Loop through the points getting the sample planes
nPoints = size(points, 1);
offset = 0;
tube = [];
coords = [];
planeLocs = [];
fprintf('Segment: ');
for iPoint = 1:nPoints-1
  fprintf('%d ', iPoint);

  %  Compute the plane locations along the current line offset the first
  %  point by the remainder of the last pair
  [segmentPlaneLocs remainder] = ...
      lineSamp(points(iPoint,:), points(iPoint+1,:), delta(1), offset);
  offset = delta(1) - remainder;
  planeLocs = [planeLocs; segmentPlaneLocs];

  %  if there are any plane locations, interpolate the data and append 
  %  TODO check to see that lineSamp handles a line segment that is shorter
  %  than delta
  if ~isempty(segmentPlaneLocs) 
    
    [segmentTube segmentCoords] = ...
        interpPlane(mRCImage, segmentPlaneLocs, ...
                    points(iPoint+1,:) - points(iPoint, :), ...
                    delta(2:3), dimension, method);
    tube = cat(3, tube, segmentTube);
    %coords = cat(3, coords, segmentCoords);
    coords = [coords;  segmentCoords];
  else
    fprintf('Empty segment: %d\n', iPoint);
  end
  
    
end

