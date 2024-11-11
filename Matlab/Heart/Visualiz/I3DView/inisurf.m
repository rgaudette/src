%INISURF        I3D contour plot initialization.
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
%  $Log: inisurf.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.4  1997/07/14 17:20:26  rjg
%  Added figure call to beginning of function.
%  grid -> grid on
%
%  Revision 1.3  1997/07/14 17:18:04  rjg
%  Updated for MATLAB 5.
%
%  Revision 1.2  1997/04/06 19:28:20  rjg
%  Commented out drawmode - fast
%
%  Revision 1.1  1996/09/20 04:49:10  rjg
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

function inisurf

global Data nRows nCols idxSample idxElem
global xMin xMax yMin yMax zMin zMax Az El
global h3dFig h3dData h3dPoint

%%
%%  Setup inital figure
%%
figure(h3dFig);
Array = reshape(Data(:, idxSample), nRows, nCols);
h3dData = surf(Array);
set(gca, 'ydir', 'reverse')
%set(gca, 'DrawMode', 'fast')
axis([xMin xMax yMin yMax zMin zMax])
set(h3dData, 'EraseMode', 'normal')
xlabel('Column Index')
ylabel('Row Index')
zlabel('Amplitude (mV)')
view([Az El])
grid on
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
