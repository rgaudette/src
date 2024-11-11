%LEADMAP        Plot the leads as a function of time in the form of an array.
%
%    hAxes = leadmap(Data, szData, idxRows, idxCols, Markers, szPlotArray)
%
%    hAxes       Axes handle for each plot.
%
%    Data        Data to be plotted in standard plaque format.
%
%    szData      The dimensions of the plque array.
%
%    idxRows     The rows of the plaque array to plot.
%
%    idxCols     The columns of the plaque array to plot
%
%    Markers     [OPTIONAL] Time indices at which to place vertical markers.
%                Each column contains a different marker.  Markers should
%                have the same number of rows as the data.
%
%    szPlotArray [OPTIONAL] The size of the subplot array to use.
%
%    Calls: arrplot

function hAxes = leadmap(Data, szData, idxRows, idxCols, ...
                         Markers, szPlotArray)

%%
%%  Initialization
%%
idxRows = idxRows(:)';
idxCols = idxCols(:)';

%%
%%    Extract data ranges
%%
[nElems nSamples] = size(Data);
dataMin = matmin(Data);
dataMax = matmax(Data);

%%
%%  Define the size of the plot array
%%
if nargin > 5,
    nPlotRows = szPlotArray(1);
    nPlotCols = szPlotArray(2);
else
    nPlotRows = length(idxRows);
    nPlotCols = length(idxCols);
end

%%
%%  Fill in the Leads array with the data selected by idxRows, idxCols
%%
nLeads = length(idxRows) * length(idxCols);
idxLeads = zeros(nLeads,1);
Leads = zeros(nSamples, nLeads);
idxL = 1;
for idxR = idxRows,
    for idxC = idxCols,
        idxLeads(idxL) = (idxC - 1) * szData(1) + idxR;
        idxL = idxL + 1;
    end
end
Leads = Data(idxLeads, :)';

%%
%%  Display the leads
%%
hAxes = arrplot(Leads, [nPlotRows nPlotCols], ...
    [length(idxRows) length(idxCols)]);

%%
%%  Remove x & y tick labels for interior plots
%%
for idxPlot = 1:length(hAxes)
    if hAxes(idxPlot) > 0

        subplot(hAxes(idxPlot));
        axis([0 nSamples dataMin dataMax]);
        grid

        %%
        %%  Only label axis if this is an edge plot.
        %%
        if rem(idxPlot, nPlotCols) ~= 1,
            set(gca, 'YTickLabel', '');
        end
        if idxPlot <= nPlotCols * (nPlotRows - 1),
            set(gca, 'XTickLabel', '');
        end

    end
end

%%
%%  Remove the non-existant plots
%%
hAxes = hAxes(find(hAxes > 0));

if nargin > 4,
    [junk nMarkers] = size(Markers);
    yPts = [dataMin dataMax]' * ones(1, nMarkers);

    for idxPlot = 1:length(idxLeads),
        if hAxes(idxPlot) > 0 
            subplot(hAxes(idxPlot));
            set(gca, 'ColorOrder', [0 0 1; 0 1 0; 1 0 0]);
            hold on
            h = plot(ones(2,1) * Markers(idxLeads(idxPlot),:), yPts, 'b-.');
            set(h, 'linewidth', 2)
            hold off
        end
        if idxPlot <= length(idxCols)
            column = ceil(idxLeads(idxPlot)/szData(1));
            row = idxLeads(idxPlot) - (column - 1) * szData(1);
            title(['Lead #' int2str(idxLeads(idxPlot))...
                ' ('int2str(row) ',' int2str(column) ')']);
        end
    end
end
