%MSLICE_LT         Show multiple slices of a 3D volume in a light background.
%
%   mslice_lt(X, CompVol, idxSlices, VisPlane, dimPlot, CAxis)
%
%   X           The 3D volume to show.
%
%   CompVol     A structure defining the computational volume.  This
%               structure should have the members: Type, X, Y and Z.  Type
%               should be uniform specifying a uniform sampling volume of
%               voxels. X, Y and Z are vectors specifying the centers of the
%               voxels.
%
%   idxSlices   OPTIONAL: The slices to show.
%
%   VisPlane    OPTIONAL: The dimension in which to slice up the volume.
%               The visualization plane will be constant in this
%               dimension.
%
%   dimPlot     OPTIONAL: The subplot dimensions (default: 2x3).
%
%   CAxis       OPTIONAL: The color axis range for all of the plots.  The
%               default is the range of each slice independently.
%
%   MSLICE
%
%   Calls: mslice
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:28 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mslice_lt.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:28  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mslice_lt(X, CompVol, idxSlices, VisPlane, dimPlot, CAxis)
colordef white
set(gcf, 'color', [0.8 0.8 0.8])
set(gcf, 'inverthardcopy', 'off')
if nargin == 2
    mslice(X, CompVol);
end
if nargin == 3
    mslice(X, CompVol, idxSlices);
end
if nargin == 4
    mslice(X, CompVol, idxSlices, VisPlane);
end
if nargin == 5
    mslice(X, CompVol, idxSlices, VisPlane, dimPlot);
end
if nargin == 6
    mslice(X, CompVol, idxSlices, VisPlane, dimPlot, CAxis);
end
