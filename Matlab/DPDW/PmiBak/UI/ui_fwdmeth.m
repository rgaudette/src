%UI_FWDMETH
function [UIHandles, YEnd] = ui_fwdmeth(hFig, UIHandles, XStart, ...
    szXFrame, YStart, szYEdit)

%%
%%  Forward solution Method  
%%
stYEdit = YStart - szYEdit ;
stYLabel = stYEdit - 2;
szYFrame = 8 * (szYEdit + 2) + 9;
stYFrame = stYEdit - szYFrame;
YEnd = stYFrame;

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','left', ...
    'Position',[XStart stYFrame+szYFrame-5 szXFrame szYEdit], ...
    'String','Forward Solution Method', ...
    'Style','text');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[XStart stYFrame szXFrame szYFrame], ...
    'Style','frame');

stXLabel1 = XStart + 2;
szXLabel1 = 70;
szXEdit1 = 142;
stXEdit1 = stXLabel1 + szXLabel1 + 1;
stYEdit = stYEdit - 2 - szYEdit;
stYLabel = stYEdit - 2;

UIHandles.Fwd_MatlabVar = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYEdit szXLabel1 szYEdit], ...
    'callback', 'rbFwdMethod(''Matlab Variable'')', ...
    'String','Matlab Variable:', ...
    'Style','radiobutton');

UIHandles.Fwd_MatlabVarName = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'Position',[stXEdit1 stYEdit szXEdit1 szYEdit], ...
    'HorizontalAlignment','left', ...
    'Style','edit');

stYEdit = stYEdit - 2 - szYEdit;
stYLabel = stYEdit - 2;
szXLabel1 = 55;
stXEdit1 = stXLabel1 + szXLabel1;
szXEdit1 = 80;
UIHandles.Fwd_Born = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYEdit szXLabel1 szYEdit], ...
    'callback', 'rbFwdMethod(''Born'')', ...
    'String','Born', ...
    'Style','radiobutton');

stXLabel2 = XStart+szXFrame/2;
szXLabel2 = 40;
stXEdit2 = stXLabel2 + szXLabel2;
UIHandles.Fwd_Rytov = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel2 stYEdit szXLabel2 szYEdit], ...
    'callback', 'rbFwdMethod(''Rytov'')', ...
    'String','Rytov', ...
    'enable', 'off', ...
    'Style','radiobutton');
stYEdit = stYEdit - 2 - szYEdit;
stYLabel = stYEdit - 2;
szXLabel = 100;
UIHandles.Fwd_Spherical = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYEdit szXLabel szYEdit], ...
    'callback', 'rbFwdMethod(''Spherical'')', ...
    'String','Spherical Harmonic', ...
    'Style','radiobutton');

szXLabel2 = 25;
stXEdit2 = stXLabel2 + szXLabel2;
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel2 stYLabel szXLabel szYEdit], ...
    'String','order', ...
    'HorizontalAlignment','left', ...
    'Style','text');

UIHandles.Fwd_Order = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'Position',[stXEdit2 stYEdit szXEdit1 szYEdit], ...
    'HorizontalAlignment','left', ...
    'Style','edit');


stYEdit = stYEdit - 2 - szYEdit;
UIHandles.Fwd_FDFD = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYEdit szXLabel szYEdit], ...
    'callback', 'rbFwdMethod(''FDFD'')', ...
    'String','Finite Difference - F. D.', ...
    'Style','radiobutton');

UIHandles.Fwd_FiniteElem = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel2 stYEdit szXLabel szYEdit], ...
    'callback', 'rbFwdMethod(''FEM'')', ...
    'String','Finite Element', ...
    'enable', 'off', ...
    'Style','radiobutton');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[XStart+10 stYEdit-2.0 szXFrame-10 1.0], ...
    'Style','frame');
%%
%%  Forward problem boundary condition implementation
%%
stYEdit = stYEdit - szYEdit - 4;
stYLabel = stYEdit - 2;
UIHandles.Fwd_ExtrapBnd = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYEdit 93.75 szYEdit], ...
    'callback', 'rbFwdBoundary(''Extrapolated'')', ...
    'String','Extrapolated Boundary', ...
    'Style','radiobutton');

UIHandles.Fwd_InfMedium = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[XStart+szXFrame/2 stYEdit 68.25 szYEdit], ...
    'callback', 'rbFwdBoundary(''Infinite'')', ...
    'String','Infinite Medium', ...
    'Style','radiobutton');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[XStart+10 stYEdit-2.0 szXFrame-10 1.0], ...
    'Style','frame');

%%
%%  Forward problem computation volume
%%
stYEdit =  stYEdit - 5 - szYEdit;
stYLabel = stYEdit - 2;

szXEdit = 40;
szXLabel1 = 24;
stXEdit1 = stXLabel1 +szXLabel1+1;

szXLabel2 = 20;
stXLabel2 = stXEdit1 + szXEdit + 2;
stXEdit2 = stXLabel2 + szXLabel2 + 1;

szXLabel3 = 20;
stXLabel3 = stXEdit2 + szXEdit + 2;
stXEdit3 = stXLabel3 + szXLabel3 + 1;

szXLabel4 = 10;
stXLabel4 = stXEdit3 + szXEdit + 3;

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','right', ...
    'Position',[stXLabel1 stYLabel szXLabel1 szYEdit], ...
    'String','X min:', ...
    'Style','text');
UIHandles.Fwd_XMin = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stXEdit1 stYEdit szXEdit szYEdit], ...
    'Style','edit');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','right', ...
    'Position',[stXLabel2 stYLabel szXLabel2 szYEdit], ...
    'String','max:', ...
    'Style','text');
UIHandles.Fwd_XMax = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stXEdit2 stYEdit szXEdit szYEdit], ...
    'Style','edit');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','right', ...
    'Position',[stXLabel3 stYLabel szXLabel3 szYEdit], ...
    'String','step:', ...
    'Style','text');
UIHandles.Fwd_XStep = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stXEdit3 stYEdit szXEdit szYEdit], ...
    'Style','edit');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel4 stYLabel szXLabel4 szYEdit], ...
    'String','cm', ...
    'Style','text');

stYEdit =  stYEdit - 2 - szYEdit;
stYLabel = stYEdit - 2;

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','right', ...
    'Position',[stXLabel1 stYLabel szXLabel1 szYEdit], ...
    'String','Y min:', ...
    'Style','text');
UIHandles.Fwd_YMin = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stXEdit1 stYEdit szXEdit szYEdit], ...
    'Style','edit');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','right', ...
    'Position',[stXLabel2 stYLabel szXLabel2 szYEdit], ...
    'String','max:', ...
    'Style','text');
UIHandles.Fwd_YMax = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stXEdit2 stYEdit szXEdit szYEdit], ...
    'Style','edit');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','right', ...
    'Position',[stXLabel3 stYLabel szXLabel3 szYEdit], ...
    'String','step:', ...
    'Style','text');
UIHandles.Fwd_YStep = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stXEdit3 stYEdit szXEdit szYEdit], ...
    'Style','edit');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel4 stYLabel szXLabel4 szYEdit], ...
    'String','cm', ...
    'Style','text');

stYEdit =  stYEdit - 2 - szYEdit;
stYLabel = stYEdit - 2;

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','right', ...
    'Position',[stXLabel1 stYLabel szXLabel1 szYEdit], ...
    'String','Z min:', ...
    'Style','text');
UIHandles.Fwd_ZMin = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stXEdit1 stYEdit szXEdit szYEdit], ...
    'Style','edit');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','right', ...
    'Position',[stXLabel2 stYLabel szXLabel2 szYEdit], ...
    'String','max:', ...
    'Style','text');
UIHandles.Fwd_ZMax = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stXEdit2 stYEdit szXEdit szYEdit], ...
    'Style','edit');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','right', ...
    'Position',[stXLabel3 stYLabel szXLabel3 szYEdit], ...
    'String','step:', ...
    'Style','text');
UIHandles.Fwd_ZStep = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stXEdit3 stYEdit szXEdit szYEdit], ...
    'Style','edit');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel4 stYLabel szXLabel4 szYEdit], ...
    'String','cm', ...
    'Style','text');
