%MCHPLT             Plot a multiple channel data set.
%
%    mchplt(matMCH, idxX, Axis, Title, XLabel, YLabel, ...
%           flgPrintFile, flgPeak, nPltPerPage)
%
%    matMCH         The multi-channel matrix to plot, each channel is in a
%                   seperate column. 
%
%    idxX           The X indicies coresponding to eaach row.
%
%    Axis           The X and Y axis to use for each axes.  Use the string
%                   'auto' to have matlab autoscale each axes.
%
%    Title          The string to be placed at the top of each page.  Each
%                   axes is also labeled with it's channel index starting at 1.
%
%    XLabel
%
%    YLabel
%
%    flgPrintFile   OPTIONAL: Send plot to printer or Encapsulated PostScript
%                   file. (default: none)
%
%    flgPeak        OPTIONAL: Label the peak value of each plot giving its 
%                   position and value.
%
%    nPltPerPage    OPTIONAL: The number of plots per page to use. (default: 4)
%
%    Calls: tag
%
%    Bugs: none.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:26 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mchplt.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:26  rickg
%  Matlab Source
%
%  
%     Rev 1.1   03 May 1994 10:15:24   rjg
%  Added underscore to print file output.
%  
%     Rev 1.0   02 May 1994 14:57:44   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mchplt(matMCH, idxX, Axis, Title, XLabel, YLabel, ...
                flgPrintFile, flgPeak, nPltPerPage)

%%
%%    Default values
%%
if nargin < 7,
    flgPrintFile = 0;
end

if isstr(flgPrintFile),
    PrintFile = flgPrintFile;
    flgPrintFile = 2;
end

if nargin < 8,
    flgPeak = 0;
end

if nargin < 9,
    nPltPerPage = 4;
end

%%
%%    Extract structure sizes
%%
[nSamp nCh] = size(matMCH);
nPages = ceil(nCh / nPltPerPage);

%%
%%    Axes constants
%%
Left = 0.13;
Width = 0.775;
Height = 0.12;
Bottom = [.74 .53 .32 .11];


for ipage = 1:nPages,

    %%
    %%    Clear figure window
    %%
    clf

    for iplot = 1:nPltPerPage,

        channel = (ipage - 1) * nPltPerPage + iplot;
        if channel > nCh,
            break;
        end
        %%
        %%    Create correct axes area
        %%
        hAxes = axes('position', [Left Bottom(iplot) Width Height]);

        %%
        %%    Plot trace of current channel
        %%
        plot(idxX, matMCH(:, channel))	

        axis(Axis)
        grid

        %%
        %%    Find peak value and range gate
        %%
	if flgPeak,
        	[Peak idxPeak] = max(matMCH(:,channel));
	end
        %%
        %%    Label plots when necessary
        %%
        if (iplot == nPltPerPage) | ...
           ((iplot == rem(nCh, nPltPerPage)) & ipage == nPages),
            xlabel(XLabel);
        else
            set(gca, 'XTickLabels', '');
        end

        title(['Channel: ' int2str(channel) ...
            '  Peak=' num2str(Peak) '  @ ' int2str(idxPeak)]);
    end

    %%
    %%    Generate title and y label on full page axes
    %%
    yLabelAxes = 0.9 - Bottom(iplot);
    hAxes = axes('position', [Left-0.03 Bottom(iplot) Width+0.06 yLabelAxes]);
    set(hAxes, 'visible', 'off');
    title(Title);
    ylabel(YLabel);

    tag('', 0);

    %%
    %%    Send plot to the appropriate device
    %%
    if flgPrintFile == 2,
        print('-deps', [PrintFile '_' int2str(ipage)]);
    elseif flgPrintFile == 1,
        print
    else
        disp('Hit any key to plot the next page');
        pause
    end

end
