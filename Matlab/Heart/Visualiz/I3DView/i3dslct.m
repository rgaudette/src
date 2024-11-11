%I3DSLCT        I3D element selector function.
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
%  $Log: i3dslct.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.2  1997/07/14 19:12:15  rjg
%  Updated the way the axis view is handle to be compatible with MATLAB 5.
%
%  Revision 1.1  1996/09/20 04:46:14  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3dslct
global Data nRows nCols idxElem idxSample
global h2dData h2dPointer h3dData h3dPoint hLegend
global posMessageL1

figure(3)
hMsg = uicontrol('Style', 'Text', 'HorizontalAlignment', 'Left', ...
        'Position', posMessageL1, ...
        'String', 'Press Enter in Figure 1 when done');

%%
%%  set the viewpoint to directly over the graph
%%
figure(1)
[CurrentAz CurrentEl] = view;
view([0 90])
[idxCols idxRows] = ginput;
figure(3)
delete(hMsg)

nPlotLeads = length(idxCols);

%%
%%  Clip selection to within the extent of the array.
%%
idxRows = round(idxRows);
idxBad = find(idxRows > nRows);
idxRows(idxBad) = ones(size(idxBad)) * nRows;

idxCols = round(idxCols);
idxBad = find(idxCols > nCols);
idxCols(idxBad) = ones(size(idxBad)) * nCols;
idxElem = idxRows + (idxCols - 1) * nRows;

%%
%%  Redraw element time plot in figure(2) and move marker
%%
figure(2)
delete(h2dData)
delete(hLegend);
h2dData = plot(Data(idxElem,:)');
cmdLegend = 'hLegend = legend(''Marker'', ';
for i = 1:nPlotLeads-1,
    cmdLegend = [ cmdLegend ' ''Lead:' int2str(idxRows(i)) ',' ...
    int2str(idxCols(i)) ''','];
end
cmdLegend = [ cmdLegend ' ''Lead:' int2str(idxRows(nPlotLeads)) ',' ...
int2str(idxCols(nPlotLeads)) ' '' '];
cmdLegend = [cmdLegend ');'];
eval(cmdLegend);

%%
%%  Update positional markers in 3D graph
%%
figure(1)
hold on
delete(h3dPoint)
h3dPoint = plot3(idxCols, idxRows, Data(idxElem, idxSample), 'w+');
set(h3dPoint, 'LineWidth', 3);
hold off

%%
%%  Reset the viewpoint
%%
view([CurrentAz CurrentEl]);