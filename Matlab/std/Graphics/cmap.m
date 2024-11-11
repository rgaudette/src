%CMAP           Basic color map with legend bar on the right of the plot.
%
%   [hMap hBar] = cmap(XValue, YValue, ZValue, Axis, CAxis, flgClip);
%
%   hMap        A handle to the color map axes.
%
%   hBar        A handle to the color bar legend.
%
%   XValue      The value corresponding to each column of ZValue, thus
%               XValue should have as many elements as ZValues has columns.
%
%   YValue      The value corresponding to each row of ZValue, thus
%               YValue should have as many elements as ZValues has rows.
%
%   ZValue      The array to be mapped.
%
%   Axis        The ranges for the X and Y axis.
%
%   CAxis       The color axis to use.
%
%   flgClip     OPTIONAL: Clip the ZValue data within the CAxis range
%                (prevents holes in the colormap).
%
%	CMAP displays a basic colormap with a bar legend on the right of
%   of the plot.
%
%   Calls: clip.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:05 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: cmap.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:05  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/15 22:42:20  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [hMap, hBar] = cmap(XValue, YValue, ZValue, Axis, CAxis, flgClip)

if nargin < 6,
    flgClip = 0;
end
%%
%%    Generate legend on side of plot
%%
hold off
clg
hBar = axes('position', [.88 .2 .03 .6]);
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
hMap = axes('position', [.17 .2 .6 .6])
set(gca, 'Box', 'on')
axis(Axis);
caxis(CAxis);
hold on

if flgClip,
    ZValue = clip(ZValue, CAxis(1), CAxis(2));
end

%%
%%    Display colormap
%%
pcolor(XValue, YValue, ZValue);
shading('flat')
set(gca, 'FontSize', 14)
set(gca, 'FontWeight', 'bold')

