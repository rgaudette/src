%doVisualize    
%
%   Calls: bgyor, mcontour, mslice.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:57 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: doVisualize.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:57  rickg
%  Matlab Source
%
%  Revision 1.4  1998/07/30 19:53:17  rjg
%  Change SIdefines codes to strings.
%
%  Revision 1.3  1998/06/10 18:27:09  rjg
%  Flipped grey colormap so that dark indicates a large value, better for
%  printing hardcopys.
%  Added silabel.
%
%  Revision 1.2  1998/06/03 16:35:11  rjg
%  Uses SIdefines codes
%  Figure is now created with default position/size
%
%  Revision 1.1  1998/04/29 15:14:07  rjg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

UIHandles = get(gcf, 'UserData');
set(UIHandles.hLight, 'Color', [1 0 0]);
drawnow;

ds = getall;
%%
%%  Reconstruct image of volume
%%
Xv = R(1):dr(1):R(2);
nX = length(Xv);
Yv = R(3):dr(2):R(4);
nY = length(Yv);
Zv = R(5):dr(3):R(6);
nZ = length(Zv);
nVoxel = nX * nY * nZ;


figure(2)
clf

orient landscape
switch ds.CMap
case 'grey'
    colormap(flipud(gray(256)));
case 'bgyor'
    colormap(bgyor(256));
end

switch ds.Visualize
case 'contour'
    mcontour(xhat, dr, R, ds.ZIndices, ds.LayoutVector, ds.nCLines);
case 'image'
    switch ds.CRange
    case 'fixed'
        mslice(xhat, dr, R, ds.ZIndices, ds.LayoutVector, ds.CRangeVal);
    case 'auto'
        mslice(xhat, dr, R, ds.ZIndices, ds.LayoutVector);
    end
end
silabel;

set(UIHandles.hLight, 'Color', [0 1 0]);
drawnow;
