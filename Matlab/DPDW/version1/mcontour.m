%MCONTOUR       Show multiple contours of a 3D volume.
%
%   mcontour(X, dr, R, idxContours, dimPlot, nCLines)
%
%   X           The 3D volume to show.
%
%   dr          The grid size as a vector of the form [dx dy dz].
%
%   R           The region to compute the matrix over in the form
%               [xmin xmax ymin ymax zmin zmax].
%
%   idxSlices   OPTIONAL: The contours to show.
%
%   dimPlot     OPTIONAL: The subplot dimensions (default: 2x3).
%
%   nCLines     OPTIONAL: The values of the contour lines to display.
%
%   MCONTOUR
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
%  $Log: mcontour.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:58  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/29 16:02:51  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mcontour(X, dr, R, idxSlices, dimPlot, nCLines)

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


for idxPlot = 1:length(idxSlices)
    subplot(nRows, nCols, idxPlot);
    if nargin > 5
        cs = contour(Xv, Yv,  X(:,:, idxSlices(idxPlot)), nCLines);
    else
        cs = contour(Xv, Yv,  X(:,:, idxSlices(idxPlot)));
    end
    clabel(cs)
    grid on
    title(['Z = ' num2str(Zv(idxSlices(idxPlot)))]);
end
