%volumeRotateInv  Inverse rotate the volume by the specified angles
%
%   vol = volumeRotateInv(vol, rotate, origin, method, extrapValue)
%
%   vol         The input and output volume.
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
%
%   method      OPTIONAL: The interpolation method (default: 'linear')
%               See intper3 for a list of interpolation methods.
%
%   extrapValue OPTIONAL: The value to set pixels which lie outside of the
%               valid interpolation region. (default: mean value of the
%               input volume).
%
%   volumeRotateInv rotates a 3D volume the amount specified by the argument
%   rotate.  The origin around which the rotation is applied is tken to be
%   the center of the volume unless otherwise specified. The order of the
%   Euler angles is reversed for this function
%
%   Calls: eulerRotate
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/18 21:44:40 $
%
%  $Revision: 1.9 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function vol = volumeRotateInv(vol, rotate, origin, method, extrapValue)

if nargin < 4 || isempty(method)
  method = 'linear';
end

szVol = size(vol);
if nargin < 3 | isempty(origin)
  origin = szVol ./ 2 + 0.5;
end

% Calculate the coordiates of each voxel
[locX locY locZ] = ndgrid(single([1:szVol(1)])-origin(1), ...
                          single([1:szVol(2)])-origin(2), ...
                          single([1:szVol(3)])-origin(3));

locRot = eulerRotate([locX(:)'; locY(:)'; locZ(:)'], -1 * rotate);
iX = reshape(locRot(1,:), size(vol));
iY = reshape(locRot(2,:), size(vol));
iZ = reshape(locRot(3,:), size(vol));
clear locRot

% Set values outside of the volume to the mean value
if nargin < 5
  extrapValue = single(mean(vol(:)));
end

% Interpolate at the new coordinates
vol = interpn(locX, locY, locZ, vol, iX, iY, iZ, method, extrapValue);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: volumeRotateInv.m,v $
%  Revision 1.9  2005/08/18 21:44:40  rickg
%  Input arg handling
%
%  Revision 1.8  2005/08/14 08:53:04  rickg
%  center -> origin
%
%  Revision 1.7  2005/07/25 06:14:32  rickg
%  Memory reduction using single and clear
%
%  Revision 1.6  2004/12/15 00:51:09  rickg
%  Help update
%
%  Revision 1.5  2004/10/29 18:34:10  rickg
%  Swapped order, sign and rotation method
%
%  Revision 1.4  2004/09/27 23:57:05  rickg
%  Exrtrapolated regions set to volume average
%
%  Revision 1.3  2004/09/07 23:28:29  rickg
%  Swapped x & y axis
%
%  Revision 1.2  2004/08/17 22:52:31  rickg
%  Added speed up for linear interpolation
%
%  Revision 1.1  2004/08/16 23:30:08  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%