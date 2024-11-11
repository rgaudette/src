%MSLICE         Show multiple slices of a 3D volume.
%
%   mslice(X, dr, R, idxSlices, dimPlot, CAxis)
%
%   X           The 3D volume to show.
%
%   dr          The grid size as a vector of the form [dx dy dz].
%
%   R           The region to compute the matrix over in the form
%               [xmin xmax ymin ymax zmin zmax].
%
%   idxSlices   OPTIONAL: The slices to show.
%
%   dimPlot     OPTIONAL: The subplot dimensions (default: 2x3).
%
%   CAxis       OPTIONAL: The color axis range for all of the plots.  The
%               default is the range of each slice independently.
%
%   MSLICE
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:58 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mslice.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:58  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/29 16:00:03  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mslice(X, dr, R, idxSlices, dimPlot, CAxis)

%%
%%  Create the sampling volume
%%
Xv = R(1):dr(1):R(2);
Yv = R(3):dr(2):R(4);
Zv = R(5):dr(3):R(6);

nX = length(Xv);
nY = length(Yv);
nZ = length(Zv);

%%
%%  Reshape the data in vector format, this won't affect a array
%%  already in 3D.
%%
X = reshape(X, nX, nY, nZ);

%%
%%  If the slice indices is not already given subsample so that there are 6
%%  images uniform located in depth.
%%
if nargin < 5
    nRows = 2;
    nCols = 3;
    if nargin < 4
        idxSlices = [1:nZ/6:nZ];
        idxSlices = round(idxSlices);
    end
else
    nRows = dimPlot(1);
    nCols = dimPlot(2);
end


cmin = min(X(:));
cmax = max(X(:));
for idxPlot = 1:length(idxSlices)
    subplot(nRows, nCols, idxPlot);
    imagesc(Xv, Yv, X(:,:, idxSlices(idxPlot)));
    set(gca, 'ydir', 'normal');
    grid on
    if nargin > 5,
        caxis(CAxis);
    end
    
    title(['Z = ' num2str(Zv(idxSlices(idxPlot)))]);
    colorbar('vert');
end
