%AZRMAP        Generate a colormap using range and azimuth as independent
%              variables.
%
%    azrmap(matRange, matPower, vecAzimuth, Axis, CAxis)
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
%  $Log: azrmap2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function azrmap(matRange, matPower1, matPower2, vecAzimuth, Axis, CAxis)


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
axes('position', [.88 .2 .03 .6])
axis([0 1 min(CAxis) max(CAxis)])
caxis(CAxis);
vecLegend = linspace(min(CAxis), max(CAxis), 64)';
pcolor([0 1], vecLegend, [vecLegend vecLegend]);
set(gca, 'XTickLabels', ' ');
shading('flat')
set(gca, 'FontWeight', 'bold')

%%
%%    Plotting area for map.
%% 
axes('position', [.17 .2 .25 .6])
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
pcolor(X, Y, matPower1);
shading('flat')
grid
hold off
set(gca, 'FontWeight', 'bold')

xlabel('KILOMETERS')
hXL1 = get(gca, 'xlabel');
set(hXL1, 'FontSize', 14);
set(hXL1, 'FontWeight', 'bold');

ylabel('KILOMETERS')
hYL1 = get(gca, 'ylabel');
set(hYL1, 'FontSize', 14);
set(hYL1, 'FontWeight', 'bold');

title('VERTICAL')
hT1 = get(gca, 'title');
set(hT1, 'FontSize', 16);
set(hT1, 'FontWeight', 'bold');

%%
%%    Plotting area for 2nd map.
%% 
axes('position', [.52 .2 .25 .6])
set(gca, 'Box', 'on')
axis(Axis);
caxis(CAxis);
hold on

pcolor(X, Y, matPower2);
shading('flat')
grid
hold off
set(gca, 'FontWeight', 'bold')

xlabel('KILOMETERS')
hXL2 = get(gca, 'xlabel');
set(hXL2, 'FontSize', 14);
set(hXL2, 'FontWeight', 'bold');

ylabel('KILOMETERS')
hYL2 = get(gca, 'ylabel');
set(hYL2, 'FontSize', 14);
set(hYL2, 'FontWeight', 'bold');

title('HORIZONTAL')
hT2 = get(gca, 'title');
set(hT2, 'FontSize', 16);
set(hT2, 'FontWeight', 'bold');
