%volumeRotateShift   Rotate and shift by the specified angles and voxels
%
%   vol = volumeRotateShift(vol, rotate, shift, origin, method, extrapValue)
%
%   vol         The input and output volume.
%
%   rotate      Rotate is a 3 element vector it specifies the euler angles
%               [Phi Theta Psi] (in radians).
%
%   shift       The amount to shift the volume [dX dY dZ].
%
%   origin      OPTIONAL: The index location of the coordinate origin. The
%               volume is indexed in the following format.  The X-axis is
%               mapped to the row index, the Y-axis is mapped to the column
%               index and the Z-axis is mapped to the 3rd or plane index.
%               (default: [], the center of the volume)
%
%   method      OPTIONAL: The interpolation method (default: 'linear')
%               See intper3 for a list of interpolation methods.
%
%   extrapValue OPTIONAL: The value to set pixels which lie outside of the
%               valid interpolation region. (default: mean value of the
%               input volume).
%
%   volumeRotateShift inverse rotates a 3D volume the amount specified
%   by the argument rotate then shifts the volume by the shift argument.
%   The point around which the rotation is applied is taken to be the
%   origin of the volume unless otherwise specified.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/07/25 06:14:32 $
%
%  $Revision: 1.7 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vol = volumeRotateShift(vol, rotate, shift, origin, method, ...
  extrapValue)

if nargin < 5
  method = 'linear';
end

szVol = size(vol);
if nargin < 4 | isempty(origin)
  origin = szVol ./ 2 + 0.5;
end

% Calculate the coordiates of each voxel and then shift the coordinates
[locX locY locZ] = ndgrid(single([1:szVol(1)])-origin(1), ...
                          single([1:szVol(2)])-origin(2), ...
                          single([1:szVol(3)])-origin(3));
locRot = eulerRotateInv(...
  [locX(:)' - shift(1); locY(:)' - shift(2); locZ(:)' - shift(3)], ...
  -1 * rotate);
iX = reshape(locRot(1,:), size(vol));
iY = reshape(locRot(2,:), size(vol));
iZ = reshape(locRot(3,:), size(vol));
clear locRot

% Set values outside of the volume to the mean value
if nargin < 6
  extrapValue = single(mean(vol(:)));
end

% Interpolate at the new coordinates
vol = interpn(locX, locY, locZ, vol, iX, iY, iZ, method, extrapValue);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: volumeRotateShift.m,v $
%  Revision 1.7  2005/07/25 06:14:32  rickg
%  Memory reduction using single and clear
%
%  Revision 1.6  2004/12/15 00:51:45  rickg
%  Fixed order!
%  Help update
%
%  Revision 1.5  2004/09/27 23:57:05  rickg
%  Exrtrapolated regions set to volume average
%
%  Revision 1.4  2004/09/10 04:31:48  rickg
%  Internal change of center to origin
%
%  Revision 1.3  2004/09/10 04:03:20  rickg
%  Comment updates
%
%  Revision 1.2  2004/09/07 23:28:29  rickg
%  Swapped x & y axis
%
%  Revision 1.1  2004/09/04 05:38:23  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
