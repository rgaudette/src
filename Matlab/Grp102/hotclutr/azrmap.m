%AZRMAP        Generate a colormap using range and azimuth as independent
%              variables.
%
%    [hAxC]= azrmap(matRange, matPower, vecAzimuth, Axis, CAxis, Title)
%
%    hAxC       Colorbar axes handle.
%
%    matRange   A matrix representing the range from the origin of each cell
%               in matPower.
%
%    matPower   A matrix containing the values to plot, each column is
%               considered a radial from the origin.
%
%    vecAzimuth Contains the azimuths corresponding to the columns of matPower.
%
%    Axis       A four element vector defining the range of the x and y axis
%               [xmin xmax ymin ymax].
%
%    CAxis      A two element vector defining the range of data to map the
%               colormap to.
%
%    Title      OPTIONAL: A string to be placed at the top of the map and
%               appropriately sized for a view graph.
%
%    XLabel     OPTIONAL: x label string.
%
%    YLabel     OPTIONAL: y label string.
%
%	    AZRMAP takes each column of matPower and maps its values to
%    to the current colormap creating a range, theta map.  In addition
%    a legend is drawn of the right side on the plot that displays how
%    amplitude maps to color.
%
%    Calls: az2pol, pol2cart
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: azrmap.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%     Rev 1.3   09 Dec 1993 14:54:20   rjg
%  Returns handle for colorbar axes.
%  
%     Rev 1.2   10 Nov 1993 22:01:28   rjg
%  Added grid and optional titles and labels for a viewgraph type plot.
%  
%     Rev 1.1   27 Oct 1993 11:07:30   rjg
%  Axes position moved up on page slightly.
%  
%     Rev 1.0   31 Aug 1993 23:43:28   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hAxC = azrmap(matRange, matPower, vecAzimuth, Axis, CAxis, ...
    Title, XLabel, YLabel)

%%
%%    Get number of range gates and azimuths.
%%
[nRanges nAzimuths] = size(matRange);

%%
%%    Convert azimuth vector to polar angles, get azimuth step size.
%%
vecPolarAZ = az2pol(vecAzimuth);
AzStep = diff(vecPolarAZ([2 1]));

%%
%%    Generate legend on side of plot
%%
hold off
clg
hAxC = axes('position', [.88 .2 .03 .6])
axis([0 1 min(CAxis) max(CAxis)])
caxis(CAxis);
vecLegend = linspace(min(CAxis), max(CAxis), 64)';
pcolor([0 1], vecLegend, [vecLegend vecLegend]);
shading('flat')
set(gca, 'XTickLabels', ' ');
set(gca, 'FontSize', 14)
set(gca, 'FontWeight', 'bold')

%%
%%    Plotting area for map.
%% 
axes('position', [.17 .2 .6 .6])
set(gca, 'Box', 'on')
axis(Axis);
caxis(CAxis);
hold on

%%
%%    Loop over each azimuth generating the X and Y points corresponding to
%%  each range cell.
%%
for idxAzimuth = 1:nAzimuths

    %%
    %%    Convert range-theta pairs to x-y pairs
    %%
    [X(:,idxAzimuth) Y(:,idxAzimuth) ] = pol2cart(vecPolarAZ(idxAzimuth) ...
        * ones(nRanges,1), matRange(:,idxAzimuth));

end
pcolor(X, Y, matPower);
shading('flat')
grid
set(gca, 'FontSize', 14)
set(gca, 'FontWeight', 'bold')
hold off

if nargin > 5,
    if nargin > 6,
        xlabel(XLabel)
        hXLabel = get(gca, 'xlabel');
        set(hXLabel, 'FontSize', 14);
        set(hXLabel, 'FontWeight', 'bold')
        if nargin > 7,
            ylabel(YLabel)
            hYLabel = get(gca, 'ylabel');
            set(hYLabel, 'FontSize', 14);
            set(hYLabel, 'FontWeight', 'bold')
        end
    end
    OldAxes = gca;
    hTitleAxes = axes('Position', [0 0.85 1 0.1]);
    set(hTitleAxes, 'Visible', 'off');
    hNewTitle = text(0.525, 0, Title);
    set(hNewTitle, 'HorizontalAlignment', 'center');
    set(hNewTitle, 'VerticalAlignment', 'bottom');
    set(hNewTitle, 'FontSize', 20);
    set(hNewTitle, 'FontWeight', 'bold')
%    set(gcf, 'CurrentAxes', OldAxes)
end

