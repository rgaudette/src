%SP_WIDTHSLIDE
function sp_widthslide

%%
%%  Extract the global data structure from UserData and the current axes width
%%
Data = get(gcf, 'UserData');
Xrange = get(gca, 'xlim');

SliderValue = get(Data.hWidthSlider, 'Value');
AxWidth = SliderValue * Data.nPtsMax;
if AxWidth <= 0
    AxWidth = 1E-8;
end
set(gca, 'xlim', [Xrange(1) Xrange(1)+AxWidth]);

%%
%%  Reset the step sizes for the position slider, a large step will be 95% 
%%  of the axis width, a small step will be 10% of the axis width
%%
LargeStep = 0.95 * AxWidth / Data.nPtsMax;
SmallStep = 0.10 * AxWidth / Data.nPtsMax;

set(Data.hPosSlider, 'SliderStep', [SmallStep LargeStep]);

