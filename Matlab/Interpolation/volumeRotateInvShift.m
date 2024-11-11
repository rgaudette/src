%volumeRotateInvShift   Inverse rotate and shift 
%
%   vol = volumeRotateInvShift(vol, rotate, shift, origin, method, extrapValue)
%
%   vol         The input and output volume.
%
%   rotate      Rotate is a 3 element vector it specifies the euler angles
%               [Phi Theta Psi] (in radians).
%
%   shift       The amount to shift the volume [dX dY dZ].
%
%   origin      OPTIONAL: The center of rotation for the volume specified
%               in terms of the base-1 matlab indexing.
%
%   method      OPTIONAL: The interpolation method (default: 'linear')
%               See interp3 for a list of interpolation methods.
%
%   extrapValue OPTIONAL: The value to set pixels which lie outside of the
%               valid interpolation region. (default: mean value of the
%               input volume).
%
%   volumeRotateInvShift inverse rotates a 3D volume the amount specified
%   by the argument rotate then shifts the volume by the shift argument.
%   The point around which the rotation is applied is taken to be the
%   center of the volume unless otherwise specified.
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

function vol = ...
    volumeRotateInvShift(vol, rotate, shift, origin, method, extrapValue)

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
locRot = eulerRotateInv([locX(:)'; locY(:)'; locZ(:)'], -1 * rotate);

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
%  $Log: volumeRotateInvShift.m,v $
%  Revision 1.7  2005/07/25 06:14:32  rickg
%  Memory reduction using single and clear
%
%  Revision 1.6  2004/12/15 22:32:39  rickg
%  Help section edits
%  Az El rotation removal
%
%  Revision 1.5  2004/11/04 17:10:13  rickg
%  Moved shift into the arguments of the eulerRotate function.  This results in shifting the volume after rotation!
%
%  Revision 1.4  2004/10/29 18:37:33  rickg
%  Swapped order, sign and rotation method
%
%  Revision 1.3  2004/09/27 23:57:05  rickg
%  Exrtrapolated regions set to volume average
%
%  Revision 1.2  2004/09/10 04:32:28  rickg
%  Internal change of center to origin
%  Comment updates
%
%  Revision 1.1  2004/09/07 23:27:14  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
