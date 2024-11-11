%MSLICE_SL      Show multiple slices of a 3D volume in slide format.
%
%   mslice_sl(X, dr, R, idxSlices, dimPlot, CAxis)
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
%  $Date: 2004/01/03 08:26:28 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mslice_sl.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:28  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/29 16:00:03  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mslice(X, dr, R, idxSlices, dimPlot, CAxis)
clf
%hBack = axes('position', [0 0 1 1]);
%set(gca, 'Color', [0.5 0.5 0.5]);
%set(gcf, 'NextPlot', 'add')
%print -dmeta

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

nRows = dimPlot(1);
nCols = dimPlot(2);


idxSlices = idxSlices(:)';
idxPlot = 1;
for CurrSlice = idxSlices
    subplot(nRows, nCols+1, idxPlot);

    if rem(idxPlot, nCols+1) == 0
        set(gca, 'visible', 'off');
        %%
        %%  Get the top corner of the total plot region
        %%
        if idxPlot == nCols+1
            v = get(gca, 'position');
            yMax = v(2)+v(4);
            xMax = v(1)+v(3);
        end
        idxPlot = idxPlot + 1;
        subplot(nRows, nCols+1, idxPlot);
    end

    imagesc(Xv, Yv, X(:,:, CurrSlice));
    set(gca, 'ydir', 'normal');
    grid on
    caxis(CAxis);
    title(['Z = ' num2str(Zv(CurrSlice)) ' cm']);
    
    %%
    %%  Get the bottom corner of the total plot region
    %%
    if idxPlot == (nCols+1) * (nRows - 1) + 1
        v = get(gca, 'position');
        xMin = v(1);
        yMin = v(2);
    end
    idxPlot = idxPlot + 1;
end

%%
%%  Create the colorbar on the right hand side
%%
hax = axes('position', [xMin yMin xMax-xMin yMax-yMin]);
imagesc([CAxis; CAxis]);
caxis(CAxis)
colorbar('vert');
delete(hax)