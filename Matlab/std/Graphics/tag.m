%TAG            Label the bottom left corner of the current plot.
%
%    ht = tag(Name, flgResize)
%
%    ht         Handle to the text object.
%
%    Name       OPTIONAL: A string to be placed before the date and time.
%               (default: rjg)
%
%    flgResize  OPTIONAL: A flag specifying whether the graph should be
%               resized to fit in a three ring binder.
%
%
%    Calls: tring
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:07 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: tag.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:07  rickg
%  Matlab Source
%
%  
%     Rev 1.2   11 Apr 1994 09:10:12   rjg
%  Added optional function parameters to modify name and decide if
%  the graph gets resized or not.
%  
%  
%     Rev 1.1   01 Sep 1993 15:35:26   rjg
%  Adjest text printing position.
%  
%     Rev 1.0   31 Aug 1993 23:29:22   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ht = tag(Name, flgResize)

%%
%%  Static parameters
%%
xTextStart = 0.1;
yTextStart = 0.03;

%%
%%    Default parameters
%%
if nargin < 2,
    flgResize = 0;
    if nargin < 1,
        Name = 'rjg';
    end
end


%%
%%    Create time and data string.
%%
Time = clock;
Month = ['Jan'
         'Feb'
         'Mar'
         'Apr'
         'May'
         'Jun'
         'Jul'
         'Aug'
         'Sep'
         'Oct'
         'Nov'
         'Dec'];
strDate = sprintf(['%02.0f-' Month(Time(2),:) '-%02.0f'], Time(3), Time(1));
strTime = sprintf('%02.0f:%02.0f:%02.0f', Time(4), Time(5), Time(6));

%%
%%    Call three ring binder sizing function.
%%
if flgResize,
    tring
end

%%
%%    Create a new set of axes to draw the text in.
%%
OldAxes = gca;

axes('Position', [0 0 1 1])
set(gca, 'Visible', 'off');
ht = text(xTextStart, yTextStart, [Name ' '   strDate '  ' strTime]);
set(ht, 'VerticalAlignment', 'bottom');
set(ht, 'FontName', 'Times')
set(ht, 'FontSize', 10);

%%
%%    Return old axes to CurrentAxes
%%
set(gcf, 'CurrentAxes', OldAxes);

