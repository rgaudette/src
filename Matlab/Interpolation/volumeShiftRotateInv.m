%volumeShiftRotateInv   Shift and Inverse rotate a volume
%
%   vol = volumeShiftRotateInv(vol, shift, rotate, origin, method, extrapValue)
%
%   vol         The input and output volume.
%
%   shift       The amount to shift the volume [dX dY dZ].
%
%   rotate      Rotate is a 3 element vector it specifies the euler angles
%               [Phi Theta Psi] (in radians).
%
%   origin      OPTIONAL: The index location of the coordinate origin. The
%               volume is indexed in the following format.  The X-axis is
%               mapped to the row index, the Y-axis is mapped to the column
%               index and the Z-axis is mapped to the 3rd or plane index.
%               (default: [], the center of the volume)
%
%   method      OPTIONAL: The interpolation method (default: 'linear')
%               See intpern for a list of interpolation methods.
%
%   extrapValue OPTIONAL: The value to set pixels which lie outside of the
%               valid interpolation region. (default: mean value of the
%               input volume).
%
%   volumeShiftRotateInvShift shifts the volume by the shift argument then
%   inverse rotates a 3D volume the amount specified by the argument rotate.
%   The point around which the rotation is applied is taken to be the
%   center of the volume unless otherwise specified.
%
%   Calls: eulerRotate
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/07/25 06:14:32 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vol = ...
    volumeShiftRotateInv(vol, shift, rotate, origin, method, extrapValue)

if nargin < 5
  method = 'linear';
end

szVol = size(vol);
if nargin < 4 | isempty(origin)
  origin = szVol ./ 2 + 0.5
end

% Calculate the coordiates of each voxel in the original domain
[locX locY locZ] = ndgrid(single([1:szVol(1)])-origin(1), ...
                          single([1:szVol(2)])-origin(2), ...
                          single([1:szVol(3)])-origin(3));

% Rotate the voxel coordinates, the inverse order and change of euler angle
% sign is due to the fact that we are calculating the locations of the
% untransformed volume which will map to the transformed sample points.
locRot = eulerRotate([locX(:)'; locY(:)'; locZ(:)'], -1 * rotate);
locRot(1,:) = locRot(1,:) - shift(1);
locRot(2,:) = locRot(2,:) - shift(2);
locRot(3,:) = locRot(3,:) - shift(3);

iX = reshape(locRot(1,:), szVol);
iY = reshape(locRot(2,:), szVol);
iZ = reshape(locRot(3,:), szVol);
clear locRot

% Set values outside of the volume to the mean value
if nargin < 6
  extrapValue = single(mean(vol(:)));
end

% Interpolate at the new coordinates
vol = interpn(locX, locY, locZ, vol, iX, iY, iZ, method, extrapValue);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: volumeShiftRotateInv.m,v $
%  Revision 1.3  2005/07/25 06:14:32  rickg
%  Memory reduction using single and clear
%
%  Revision 1.2  2004/12/15 16:02:36  rickg
%  Removed Az rotation, not going to implement
%  Fixed help
%
%  Revision 1.1  2004/12/01 01:05:28  rickg
%  Initial revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
