%VIEWPLQ        Create lead plots of rectangular subsections of plaque.
%
%    viewplq(Leads, Markers, szPlot, Axis)
%
%    Leads      The lead structure to be plotted.
%
%    Markers    Time indices at which to place vertical markers.  Each column
%               contains a different marker.  Markers should have the same
%               number of rows as Leads.data
%
%    szPlot     The number of plots to place on the screen at once.
%
%    Axis       [OPTIONAL] Set the axis for the plots
%
%    Calls:  leadmap, leadlbl

function viewplq(Leads, Markers, szPlot, Axes)

%%
%%    Dimensions of data default is square
%%
[nElems nSamples] = size(Leads.data);
nDataRows = Leads.nRows;
nDataCols = Leads.nCols;

%%
%%   Calculate layout of axes
%%
if nargin < 3,
    nRows = 8;
    nCols = 8;
else
    nRows = szPlot(1);
    nCols = szPlot(2);
end
nHorizPages = ceil(nDataCols ./ nCols);
nVertPages = ceil(nDataRows ./ nRows);

idxRowStart = 1;
while idxRowStart <= nRows*nVertPages
    idxRows = [idxRowStart:idxRowStart+nRows-1];
    idxRows = idxRows(idxRows <= nDataRows);
    
    idxColStart = 1;
    while idxColStart <= nCols*nHorizPages
        idxCols = [idxColStart:idxColStart+nCols-1];
        idxCols = idxCols(idxCols <= nDataCols);
        
        %%
        %%  Plot the selected leads
        %%
        haxes = leadmap(Leads.data, [Leads.nRows Leads.nCols], ...
            idxRows, idxCols, Markers);
        %%
        %%  Adjust the axis if requested
        %%
        if nargin > 3,
            set(haxes, 'XLim', Axes(1:2));
            set(haxes, 'YLim', Axes(3:4));
        end
        
        %%
        %%  Get input from user <return> to go forward, b to go back
        %%
        s = input(' ', 's');
        if ~isempty(s)
            if strcmp(s, 'b')
                if idxColStart ~= 1,
                    idxColStart = idxColStart - nCols;
                else
                    idxRowStart = idxRowStart - nRows;
                    idxRows = [idxRowStart:idxRowStart+nRows-1];
                    idxRows = idxRows(idxRows <= nDataRows);
                    idxColStart = (nHorizPages-1) * nCols + 1;
                end
            end
        else    
               idxColStart = idxColStart + nCols;
        end
    end
    idxRowStart = idxRowStart + nRows;
end
