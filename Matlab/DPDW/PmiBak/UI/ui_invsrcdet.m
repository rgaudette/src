%UI_INVSRCDET
function [UIHandles, YEnd] = ui_invsrcdet(hFig, UIHandles, XStart, szXFrame, YStart, szYEdit)

%%
%%  Source & Detector Data
%%
stYEdit = YStart - szYEdit ;
stYLabel = stYEdit - 2;
szYFrame = 10 * szYEdit + 27;
stYFrame = stYEdit - szYFrame;
YEnd = stYFrame;

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','left', ...
    'Position',[XStart stYFrame+szYFrame-5 szXFrame szYEdit], ...
    'String','Inverse Solution Source & Detector Data', ...
    'Style','text');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[XStart stYFrame szXFrame szYFrame], ...
    'Style','frame');

stXLabel1 = XStart + 2;
szXLabel1 = 55;
szXEdit = 120;
stXEdit1 = stXLabel1 + szXLabel1 + 1;
stXLabel2 = stXEdit1 + szXEdit + 2;
szXLabel2 = 30;

stYEdit = stYFrame + szYFrame - 4 - szYEdit;
stYLabel = stYEdit - 2;

%%
%%  Source X positions
%%
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYLabel szXLabel1 szYEdit], ...
    'HorizontalAlignment','right', ...
    'String','Source Pos. X:', ...
    'Style','text');
UIHandles.Inv_SrcXPos = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'Position',[stXEdit1 stYEdit szXEdit szYEdit], ...
    'HorizontalAlignment','right', ...
    'Style','edit');
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel2 stYLabel szXLabel2 szYEdit], ...
    'HorizontalAlignment','left', ...
    'String','cm', ...
    'Style','text');

%%
%%  Source Y positions
%%
stYEdit = stYEdit - 2 - szYEdit;
stYLabel = stYEdit - 2;
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYLabel szXLabel1 szYEdit], ...
    'HorizontalAlignment','right', ...
    'String','Y:', ...
    'Style','text');
UIHandles.Inv_SrcYPos = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'Position',[stXEdit1 stYEdit szXEdit szYEdit], ...
    'HorizontalAlignment','right', ...
    'Style','edit');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel2 stYLabel szXLabel2 szYEdit], ...
    'HorizontalAlignment','left', ...
    'String','cm', ...
    'Style','text');

%%
%%  Source Z positions
%%
stYEdit = stYEdit - 2 - szYEdit;
stYLabel = stYEdit - 2;
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYLabel szXLabel1 szYEdit], ...
    'HorizontalAlignment','right', ...
    'String','Z:', ...
    'Style','text');
UIHandles.Inv_SrcZPos = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'Position',[stXEdit1 stYEdit szXEdit szYEdit], ...
    'HorizontalAlignment','right', ...
    'Style','edit');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel2 stYLabel szXLabel2 szYEdit], ...
    'HorizontalAlignment','left', ...
    'String','cm', ...
    'Style','text');

%%
%%  Source Amplitudes
%%
szXEditAmp = 60;
stXLabelAmp = stXEdit1 + szXEditAmp + 1;
szXLabelAmp = 100;
stYEdit = stYEdit - 2 - szYEdit;
stYLabel = stYEdit - 2;
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYLabel szXLabel1 szYEdit], ...
    'HorizontalAlignment','right', ...
    'String','Amplitude:', ...
    'Style','text');
UIHandles.Inv_SrcAmp = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'Position',[stXEdit1 stYEdit szXEditAmp szYEdit], ...
    'HorizontalAlignment','right', ...
    'Style','edit');
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabelAmp stYLabel szXLabelAmp szYEdit], ...
    'HorizontalAlignment','left', ...
    'String','dB, per source plane', ...
    'Style','text');

%%
%%  Detector X positions
%%
stYEdit = stYEdit - 6 - szYEdit;
stYLabel = stYEdit - 2;
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYLabel szXLabel1 szYEdit], ...
    'HorizontalAlignment','right', ...
    'String','Det. Pos. X:', ...
    'Style','text');
UIHandles.Inv_DetXPos = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'Position',[stXEdit1 stYEdit szXEdit szYEdit], ...
    'HorizontalAlignment','right', ...
    'Style','edit');
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel2 stYLabel szXLabel2 szYEdit], ...
    'HorizontalAlignment','left', ...
    'String','cm', ...
    'Style','text');

%%
%%  Detector Y positions
%%
stYEdit = stYEdit - 2 - szYEdit;
stYLabel = stYEdit - 2;
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYLabel szXLabel1 szYEdit], ...
    'HorizontalAlignment','right', ...
    'String','Y:', ...
    'Style','text');
UIHandles.Inv_DetYPos = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'Position',[stXEdit1 stYEdit szXEdit szYEdit], ...
    'HorizontalAlignment','right', ...
    'Style','edit');
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel2 stYLabel szXLabel2 szYEdit], ...
    'HorizontalAlignment','left', ...
    'String','cm', ...
    'Style','text');

%%
%%  Detector Z positions
%%
stYEdit = stYEdit - 2 - szYEdit;
stYLabel = stYEdit - 2;
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYLabel szXLabel1 szYEdit], ...
    'HorizontalAlignment','right', ...
    'String','Z:', ...
    'Style','text');
UIHandles.Inv_DetZPos = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'Position',[stXEdit1 stYEdit szXEdit szYEdit], ...
    'HorizontalAlignment','right', ...
    'Style','edit');
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel2 stYLabel szXLabel2 szYEdit], ...
    'HorizontalAlignment','left', ...
    'String','cm', ...
    'Style','text');

%%
%%  Sensor position error
%%
stYEdit = stYEdit - 6 - szYEdit;
stYLabel = stYEdit - 2;
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','right', ...
    'Position',[stXLabel1 stYLabel szXLabel1 szYEdit], ...
    'String','Position Error:', ...
    'Style','text');
UIHandles.Inv_SensorError = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[0.65 0.65 0.65], ...
    'enable', 'off',...
    'HorizontalAlignment','right', ...
    'Position',[stXEdit1 stYEdit szXEdit szYEdit], ...
    'Style','edit');
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','left', ...
    'Position',[stXLabel2 stYLabel szXLabel2 szYEdit], ...
    'String','cm std.', ...
    'Style','text');


stYEdit = stYEdit - 4 - szYEdit;
stYLabel = stYEdit - 2;
 uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','right', ...
    'Position',[stXLabel1 stYLabel szXLabel1 szYEdit], ...
    'String','Mod. Freq.(s):', ...
    'Style','text');

UIHandles.Inv_ModFreq = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','right', ...
    'Position',[stXEdit1 stYEdit szXEdit szYEdit], ...
    'Style','edit');
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','left', ...
    'Position',[stXLabel2 stYLabel szXLabel2 szYEdit], ...
    'String','MHz', ...
    'Style','text');
