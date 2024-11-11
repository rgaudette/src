%I3DRDRAW       I3D redraw function
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
%  $Log: i3drdraw.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/20 04:45:04  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3drdraw(Data, DataParm, Viewport)
global Data nRows nCols idxSample idxElem
global h2dPointer h3dPoint h3dData flgFixZAxis
global hTxtSample

%%
%%  Redraw the 2d graph
%%
figure(2)
set(h2dPointer, 'XData', [idxSample idxSample]);
drawnow

%%
%%  Redraw the 3d graph
%%
figure(1)
Array = reshape(Data(:, idxSample), nRows, nCols);
set(h3dPoint, 'ZData', Array(idxElem));
set(h3dData, 'ZData', Array);
set(h3dData, 'CData', Array);
title(['Sample Index: ' int2str(idxSample)]); 

%%
%%  Check to see if z-axis is fixed
%%
if ~flgFixZAxis,
    Axis = axis;
    Axis(5) = matmin(Array);
    Axis(6) = matmax(Array);
    axis(Axis);
    colorbar
end

drawnow

set(hTxtSample, 'String', ['Sample: ' int2str(idxSample)]);
