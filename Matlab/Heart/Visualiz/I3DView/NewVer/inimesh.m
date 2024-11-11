%INIMESH        I3D mesh plot initialization.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:54 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: inimesh.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/20 04:48:57  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Setting erase mode:
%%  On the PC:
%%      Normal -    Appears to work the best
%%      Background - Does not redraw axis but it does draw the surface twice
%%                  This makes it slower than 'normal'
%%      XOR -       This also performs several redraws, does present a faceted
%%                  view, and the colormaping is distortedd due to the XOR
%%                  operation.
%%      None -      Does not remove previous surface.
%%
%%  On the SGI:
%%      Normal -    
%%      Background - 
%%      XOR -       
%%      None -

function inimesh(Data, DataParm, Viewport, Handles)

%%
%%  Create initial mesh plot.
%%
Array = reshape(Data(:, DataParm.idxSample), DataParm.nRows, DataParm.nCols);
Handles.h3dData = mesh(Array);
set(Handles.h3dData, 'EraseMode', 'normal')

%%
%%  Set the viewing parameters
%%
set(gca, 'ydir', 'reverse')
axis([Viewport.xMin Viewport.xMax Viewport.yMin Viewport.yMax ...
        Viewport.zMin Viewport.zMax])
view([Viewport.Az Viewport.El])

%%
%%  Grid and label the figure
%%
grid on
colormap(vibgyor(128))
xlabel('Column Index')
ylabel('Row Index')
zlabel('Amplitude (mV)')
colorbar

%%
%%  Marker for array element displayed in 2d plot
%%
hold on
DataParm.idxXElem = ceil(DataParm.idxElem / DataParm.nRows);
DataParm.idxYElem = DataParm.idxElem - (DataParm.idxXElem - 1) * DataParm.nRows;
Handles.h3dPoint = plot3(DataParm.idxXElem, DataParm.idxYElem, ...
    Array(DataParm.idxYElem, DataParm.idxXElem), 'w+');
set(Handles.h3dPoint, 'LineWidth', 3);
set(Handles.h3dPoint, 'EraseMode', 'normal')
hold off
drawnow
return