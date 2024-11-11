%MATPLOT        Plot the columns of a matrix in individual axis.
%
%   [hAxes] = matplot(Data, strLineType)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:05 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: matplot.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:05  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/15 22:55:57  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [hAxes] = matplot(Data, strLineType)

if nargin < 2,
    strLineType = 'r';
end

%%
%%  Find number plots necessary
%%

[nPoints nPlot] = size(Data);
hAxes = zeros(nPlot,1);

if nPlot > 10,
    disp('Over maximum of 10 plots.');
    return;
end

%%
%%  Loop over each column
%%
for iPlot = 1:nPlot,
    hAxes(iPlot) = subplot(nPlot,1, iPlot);
    plot(Data(:,iPlot), strLineType);
    grid
end
