%SP_POSSLIDE
function sp_posslide

%%
%%  Extract the global data structure from UserData and the current axes width
%%
Data = get(gcf, 'UserData');
Xrange = get(gca, 'xlim');
AxWidth = Xrange(2) - Xrange(1);

%%
%%  Get the current slider value
%%
SliderValue = get(Data.hPosSlider, 'Value');

AxStart = SliderValue * Data.nPtsMax;
AxStop = AxStart + AxWidth;
if AxStop > Data.nPtsMax
    AxStop = Data.nPtsMax;
    AxStart = AxStop - AxWidth;
end
set(gca, 'xlim', [AxStart AxStop]);
