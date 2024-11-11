%MKVG1	        Make a view graph out of a single plot.
%
%    mkvg1
%
%    Calls: none.
%
%    Bugs: need to move title to another axes to get it to print in the
%          correct spot.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:06 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mkvg1.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:06  rickg
%  Matlab Source
%
%  
%     Rev 1.0   23 Sep 1993 09:34:04   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%    Reposition the main plot
%%
set(gca, 'Position', [0.2 0.2 0.6 0.6]);

%%
%%    Get the current figure handle
%%
hCF = gcf;

%%
%%    Get the children of the current figure
%%
hCFChild = get(hCF, 'Children');
nCFChild = length(hCFChild);

%%
%%    Loop over each of the children checking for axes objects
%%
for hIndex = 1:nCFChild,
    %%
    %%    Look for axes objects
    %%
    if strcmp(get(hCFChild(hIndex), 'Type'), 'axes'),

        %%
        %%    Set the xlabel and ylabel to FontSize: 14, FontWeight: Bold
        %%

        set(hCFChild(hIndex),  'FontSize', 12);
        set(hCFChild(hIndex),  'FontWeight', 'bold');

        hXLabel = get(hCFChild(hIndex), 'xlabel');
        hYLabel = get(hCFChild(hIndex), 'ylabel');
        hTitle = get(hCFChild(hIndex), 'title');

        set(hXLabel, 'FontSize', 16);
        set(hXLabel, 'FontWeight', 'bold');
        set(hXLabel, 'VerticalAlignment', 'top')

        set(hYLabel, 'FontSize', 16);
        set(hYLabel, 'FontWeight', 'bold');
        set(hYLabel, 'VerticalAlignment', 'bottom')

        %%
        %%    Loop over each child
        %%
        hCAChild = get(hCFChild(hIndex), 'Children');
        nCAChild = length(hCAChild);
        for hIndex2 = 1:nCAChild,

            %%
            %%    If the object is a line set it's width to 1
            %%
            if strcmp(get(hCAChild(hIndex2), 'Type'),'line')
                set(hCAChild(hIndex2), 'LineWidth', 1);
            end

            %%
            %%    If the object is text set it's font size to 12, font weight
            %%    to bold.
            %%
            if strcmp(get(hCAChild(hIndex2), 'Type'),'text')
                set(hCAChild(hIndex2), 'FontSize', 12);
                set(hCAChild(hIndex2), 'FontWeight', 'bold');
            end
        end
    end
end

%%
%%    Place title as text object in new axes.
%%
set(hTitle, 'Visible', 'off');
strTitle = get(hTitle, 'String');
OldAxes = gca;
hTitleAxes = axes('Position', [0 0.85 1 0.1]);
set(hTitleAxes, 'Visible', 'off');
hNewTitle = text(0.5, 0, strTitle);
set(hNewTitle, 'HorizontalAlignment', 'center');
set(hNewTitle, 'VerticalAlignment', 'bottom');
set(hNewTitle, 'FontSize', 20);
set(hNewTitle, 'FontWeight', 'bold')

%%
%%    Add registration marks
%%
flgReg = input('Enter 1 to plot viewgraph registration marks (0/1): ');

if flgReg,
    hNewAxes = axes('Position', [0 0 1 1]);
    set(hNewAxes, 'Units', 'normalized')
    axis([0 1 0 1])
    hold on
    plot(0.045, 0.5, '+')
    plot(0.955, 0.5, '+')
    set(hNewAxes, 'visible', 'off');
    set(gcf, 'CurrentAxes', OldAxes);
end
