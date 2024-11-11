%ARRPLOT        Plot a group of signals in the form of an array.
%
%   [hAxes hLine] = arrplot(Data, szLayout, szData)
%
%   hAxes       Axes handle for each plot.
%
%   hLine       Line handle for each plot.
%
%   Data        Data to be plotted, each column represents a plot.
%
%   szLayout    A two element vector specifying the number of rows and 
%               columns of plots.
%
%   szData      [OPTIONAL] A two element vector specifying the number of
%               rows and columns present in the data.  This is useful if
%               the data is smaller than the plot array layout.
%
%   ARRPLOT plots a number of signals by an array of axis.  Each column of the
%   matrix Data should contain a different sequence to plot.  The sequences
%   are plotted column-wise from Data.
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:05 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: arrplot.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:05  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/15 22:43:17  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hAxes = arrplot(Data, szLayout, szData)

%%
%%  Initialization
%%
[nSamples nPlots] = size(Data);
hAxes = zeros(nPlots,1);

if nargin < 3,
    szData = szLayout;

    if (nPlots ~= prod(szLayout))
        disp('Number of plots does not equal number of data sequences');
        error('Specify a sub-array using szData');
    end
end

clf

for idxRow = 1:szData(1),
    for idxCol = 1:szData(2),

        idxPlot = idxCol + (idxRow - 1) * szLayout(2);
        hAxes(idxPlot) = subplot(szLayout(1), szLayout(2), idxPlot);

        idxData = idxCol + (idxRow - 1) * szData(2);
        h = plot(Data(:, idxData), 'r');

%        set(h, 'LineWidth', 1);

    end
end