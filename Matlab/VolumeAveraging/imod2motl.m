%imod2motl      Extract an initial motive list from an Imod model
%
%   motiveList = imod2motl(imodModel, idxObject, idxContour, ...
%                          idxReference, flgTheta)
%
%   motiveList  The initial motive list.
%
%   imodModel   The IMODModel specifying the potential particle locations.
%               The points in the model must be ordered such that lines
%               connection consecutive points indicate an approximate
%               rotational orientation.
%
%   idxObject   The index of the object and contour in the model to use.
%   idxContour
%
%   idxReference  The index of the reference particle, all other particles 
%               rotations will be specified relative to this particle.
%
%   flgTheta    OPTIONAL: Calculate a Theta in addition to the Phi estimate
%               from the model (default: 0).
%
%   Calls: imodPoints2Index
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.5 $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function motiveList = imod2motl(imodModel, idxObject, idxContour, ...
                                idxReference, flgTheta, flgSwapYZ)

                              global PRINT_ID
if PRINT_ID
    fprintf('$Id: imod2motl.m,v 1.5 2005/08/15 23:17:36 rickg Exp $\n');
end

if nargin < 5
  flgTheta = 0;
end

if nargin < 6
  flgSwapYZ = 0;
end

% Extract the points from the model
points = imodPoints2Index(getPoints(imodModel, idxObject, idxContour));
nPoints = size(points, 2);

if flgSwapYZ 
  points = points([1 3 2], :);
end
% Create the empty motive list
motiveList = zeros(20, nPoints);
motiveList(1,:) = 1;
motiveList(4,:) = [1:nPoints];
motiveList(5,:) = 1;

% Find the reference particle angles
if idxReference == 1
  vRef = points(:, idxReference+1) - points(:, idxReference);
elseif idxReference == nPoints
  vRef = points(:, idxReference) - points(:, idxReference-1);
else
  vRef = points(:, idxReference+1) - points(:, idxReference-1);
end

phiRef = atan2(vRef(2), vRef(1));

if flgTheta
  disp('Theta not yet implemented');
end

% Find the angles of each particle
phiParticle = zeros(1, nPoints);
phiParticle(1) = atan2(points(2,2) - points(2,1), points(1,2) - points(1,1));
phiParticle(end) = atan2(points(2,end) - points(2,end-1), ...
                         points(1,end) - points(1,end-1));

phiParticle(2:end-1) = atan2(points(2, 3:end) - points(2, 1:end-2), ...
                             points(1, 3:end) - points(1, 1:end-2));

phiRel = phiParticle - phiRef;

% Insert the angles into the motive list
motiveList(17, :) = phiRel * 180 / pi;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: imod2motl.m,v $
%  Revision 1.5  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.4  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.3  2004/12/01 20:56:46  rickg
%  Updated comments
%
%  Revision 1.2  2004/11/08 05:30:40  rickg
%  Fixed 1/2 sample error in model to index mapping
%
%  Revision 1.1  2004/08/23 16:15:54  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
