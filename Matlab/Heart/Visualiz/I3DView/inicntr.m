%INICNTR        I3D contour plot initialization.
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
%  $Log: inicntr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/20 04:48:44  rjg
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

function inicntr
global Data nRows nCols idxSample idxElem
global xMin xMax yMin yMax zMin zMax Az El
global h3Fig h3dData h3dPoint

%%
%%  Setup inital figure
%%
figure(1)
clf
h3dFig = gcf;
if strcmp(computer, 'SGI')
    set(h3dFig, 'Position', [4 512 682 512]);
else
    set(h3dFig, 'Position', [4 340 600 400]);
end
%set(h3dFig, 'BackingStore', 'off');
Array = reshape(Data(:, idxSample), nRows, nCols);
h3dData = contour(Array);
set(gca, 'ydir', 'reverse')
axis([xMin xMax yMin yMax zMin zMax])
set(h3dData, 'EraseMode', 'normal')
colormap(vibgyor(128))
xlabel('Column Index')
ylabel('Row Index')
zlabel('Amplitude (mV)')
view([Az El])
grid
colorbar

%%
%%  Marker for array element displayed in 2d plot
%%
hold on
idxXElem = ceil(idxElem / nRows);
idxYElem = idxElem - (idxXElem - 1) * nRows;
h3dPoint = plot3(idxXElem, idxYElem, Array(idxYElem, idxXElem), 'w+');
set(h3dPoint, 'LineWidth', 3);
set(h3dPoint, 'EraseMode', 'normal')
hold off
drawnow