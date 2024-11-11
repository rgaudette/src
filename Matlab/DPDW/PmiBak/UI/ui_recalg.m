%UI_RECALG
function [UIHandles, YEnd] = ui_recalg(hFig, UIHandles, XStart, szXFrame, YStart, szYEdit)

szYFrame = 5 * szYEdit + 7 * 2;
stYFrame = YStart - szYFrame - szYEdit;
YEnd = stYFrame;
stYEdit = YStart - szYEdit;
stYLabel = stYEdit - 2;


%%
%%  Reconstruction algoirthm
%%
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','left', ...
    'Position',[XStart stYFrame+szYFrame-5 szXFrame szYEdit], ...
    'String','Reconstruction Algorithm', ...
    'Style','text');

uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[XStart stYFrame szXFrame szYFrame], ...
    'Style','Frame');
stXLabel1 = XStart + 2;
stXLabel2 = XStart + szXFrame/2;
stYEdit = stYFrame + szYFrame - 2 - szYEdit;
UIHandles.BackProj = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYEdit 85 szYEdit], ...
    'callback', 'rbRecon(''Back Projection'')', ...
    'String','Back Projection', ...
    'Style','radiobutton');


UIHandles.MinNorm = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel2 stYEdit 85 szYEdit], ...
    'callback', 'rbRecon(''Min. Norm'')', ...
    'String','Minimum Norm', ...
    'Style','radiobutton');


stYEdit = stYEdit - szYEdit - 2;
szXART = 65;
stNIter = stXLabel1 + szXART + 1;
szNIter = 35;

UIHandles.ART = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1  stYEdit szXART szYEdit], ...
    'callback', 'rbRecon(''ART'')', ...
    'String','ART iterations:', ...
    'Style','radiobutton');

UIHandles.ARTnIter = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stNIter stYEdit szNIter szYEdit], ...
    'Style','edit');


szXSIRT = 65;
stNIter = stXLabel2 + szXSIRT + 1;
UIHandles.SIRT = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel2 stYEdit szXSIRT szYEdit], ...
    'callback', 'rbRecon(''SIRT'')', ...
    'String','SIRT iterations:', ...
    'Style','radiobutton');

UIHandles.SIRTnIter = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stNIter stYEdit szNIter szYEdit], ...
    'Style','edit');


szXTSVD = 65;
stNSV = stXLabel1 + szXTSVD + 1;
stYEdit = stYEdit - szYEdit - 2;

UIHandles.TSVD = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYEdit szXTSVD szYEdit], ...
    'callback', 'rbRecon(''TSVD'')', ...
    'String','TSVD # s.v.:', ...
    'Style','radiobutton');

UIHandles.TSVDnSV = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stNSV stYEdit szNIter szYEdit], ...
    'Style','edit');


stYEdit = stYEdit - szYEdit - 2;
stYLabel = stYEdit - 2;
UIHandles.MTSVD = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYEdit szXTSVD szYEdit], ...
    'callback', 'rbRecon(''MTSVD'')', ...
    'String','MTSVD # s.v.:', ...
    'Style','radiobutton');

UIHandles.MTSVDnSV = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stNSV stYEdit szNIter szYEdit], ...
    'Style','edit');

stLabel1 = stNSV + szNIter + 1;
szLabel1 = 38;
uicontrol('Parent',hFig, ...
    'Units','points', ...
    'HorizontalAlignment','left', ...
    'Position',[stLabel1 stYLabel szLabel1 szYEdit], ...
    'String',',  lambda:', ...
    'Style','text');
stMTSVDL = stLabel1 + szLabel1 + 1;
szMTSVDL = 40;
UIHandles.MTSVDLambda = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stMTSVDL stYEdit szNIter szYEdit], ...
    'Style','edit');

szXTCG = 65;
stNTCG = stXLabel1 + szXTCG + 1;
stYEdit = stYEdit - szYEdit - 2;

UIHandles.TCG = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'Position',[stXLabel1 stYEdit szXTCG szYEdit], ...
    'callback', 'rbRecon(''TCG'')', ...
    'String','TCG iterations:', ...
    'Style','radiobutton');
UIHandles.TCGnIter = uicontrol('Parent',hFig, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','left', ...
    'Position',[stNTCG stYEdit szNIter szYEdit], ...
    'Style','edit');
