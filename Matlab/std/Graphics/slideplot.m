%SLIDEPLOT
function slideplot(line1, line2, line3, line4)

%%
%%  Initializations
%%
figPlot = gcf;
clf;

%%
%%  Find the length of the largest vector to plot.
%%
nLine2 = 0; nLine3 = 0; nLine4 = 0;
nLine1 = length(line1);
if nargin > 1
    nLine2 = length(line2);
    if nargin > 2
        nLine3 = length(line3);
        if nargin > 3
            nLine4 = length(line4);
        end
    end
end
Data.nPtsMax = max([nLine1 nLine2 nLine3 nLine4]);

%%
%%  Create the plot axes, saving the default position
%%
Data.hAx = axes('Units', 'normalized');
Data.AxOrigPos = get(Data.hAx, 'position');
set(Data.hAx, 'Position',  [0.1 0.21 0.85 0.72]);


%%
%%  Position slider
%%
Data.hPosSlider = uicontrol('Parent', figPlot, ...
	'Units', 'normalized', ...
	'Position', [0.1 0.11 0.8 0.05], ...
	'Style', 'slider', ...
	'Callback', 'sp_posslide',...
    'Value', 0);

%%
%%  Plot width slider
%%
Data.hWidthSlider = uicontrol('Parent', figPlot, ...
	'Units', 'normalized', ...
	'Position', [0.1 0.05 0.8 0.05], ...
	'Style', 'slider', ...
	'Callback', 'sp_widthslide', ...
    'Value', 1);

%%
%%  Position label
%%
Data.hPosText = uicontrol('Parent', figPlot, ...
	'Units', 'normalized', ...
	'BackgroundColor', [0.615686 0.615686 0.682353], ...
	'Position', [0.02 0.11 0.07 0.05], ...
	'String', 'Position', ...
	'Style', 'text');

%%
%%  Plot width label
%%
Data.hWidthText = uicontrol('Parent', figPlot, ...
	'Units', 'normalized', ...
	'BackgroundColor', [0.615686 0.615686 0.682353], ...
	'Position', [0.02 0.05 0.07 0.05], ...
	'String', 'Width', ...
	'Style', 'text');

%%
%%  Done button
%%
Data.hDoneBtn = uicontrol('Parent', figPlot, ...
	'Units','normalized', ...
    'Style', 'pushbutton', ...
    'Position', [0.91 0.055 0.1 0.1], ...
    'String', 'Done', ...
    'Callback', 'sp_done');

%%
%%  Global data is stored in the UserData member of the current figure
%%
set(gcf, 'UserData', Data);

%%
%%  Plot the vectors provided in the command line
%%
hLine1 = plot(line1, 'b');
hold on
if nargin > 1
    hLine2 = plot(line2, 'r');
    if nargin > 2
        hLine3 = plot(line3, 'g');
        if nargin > 3
            hLine4 = plot(line4, 'm');
        end
    end
end
hold off
grid on
ylim = get(gca, 'YLim');
set(gca, 'YLimMode', 'manual');
set(gca, 'YLim', ylim);