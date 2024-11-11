%PRTPLQ         Create lead plots of rectangular subsections of plaque.
%
%    prtplq(Data, szData, szPlot, Markers, strTitle, flgPrint)
%
%    Data        The plaque data to be mapped out.
%
%    szData      The size of the plaque array.
%
%    szPlot      The number of rows & columns to plot [nRows nCols].
%
%    Markers     Time indices at which to place vertical markers.  Each column
%                contains a different marker.  Markers should have the same
%                number of rows as Plaque
%
%    strTitle    A title sub-string for each page.
%
%    flgPrint    Send the plots to postscript files.
%
%    Calls:  leadmap, leadlbl

function prtplq(Data, szData, szPlot, Markers, strTitle, flgPrint)

if nargin < 6,
    flgPrint = 0;
end

Name = upper(strTitle);
Date = date;

%%
%%    Dimensions of array
%%nDataCols = nElems / nDataRows;

[nElems nSamples] = size(Data);

%%
%%  Plot layout
%%
nRows = szPlot(1);
nCols = szPlot(2);
nHorizPages = ceil(szData(2) ./ nCols);
nVertPages = ceil(szData(1) ./ nRows);



idxRowStart = 1;

for iVPage = 1:nVertPages,
    idxRows = [idxRowStart:idxRowStart+nRows-1];
    idxRows = idxRows(idxRows <= szData(1));

    idxColStart = 1;
    for iHPage = 1:nHorizPages,
        idxCols = [idxColStart:idxColStart+nCols-1];
        idxCols = idxCols(idxCols <= szData(2));

        haxes=leadmap(Data, szData, idxRows, idxCols, Markers, szPlot);

        Title = [Name ' - Rows ' int2str(idxRowStart) ':' ...
            int2str(idxRowStart+nRows-1) ' Columns ' int2str(idxColStart) ...
            ':' int2str(idxColStart+nCols-1) ' ' Date];
        [hx hy hf] = leadlbl('Time (uS)', 'Amplitude (mV)', Title);
        disp(['Block ' int2str(iVPage) ',' int2str(iHPage)]);
        orient landscape

        if flgPrint, 
            print -dwinc
        else
            disp('Hit <Enter> for next page ...')
            pause
        end

        idxColStart = idxColStart + nCols;


    end
    idxRowStart = idxRowStart + nRows;
end