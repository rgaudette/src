%I3DVIEW        Interactive 3d viewer
%
%   i3dview(Data, szArray)
%
%   Data        Array data, each column is a different time sample, each row a
%               different lead.
%
%   szArray     A 2 element vector describing the number of rows & columns in
%               sensor array.
%   Calls: many.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:54 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: i3dview.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.2  1996/09/22 22:45:31  rjg
%  Changed array size argument to required.
%
%  Revision 1.1  1996/09/20 04:47:58  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Movie] = i3dview(Data, szArray)

%global nRows nCols nSamples idxSample incrSample idxElem
%global h2dData h2dPointer hLegend
%global h3dFig h3dData h3dPoint flgFixZAxis
%global hTxtSample hTextIncr hTextAz hTextEl hTextType
%global posMessageL1 posMessageL2 posMessageL3 posMessageL4 posMessageL5 posMessageL6
%global xMin xMax yMin yMax zMin zMax Az El
%global nFrames Movie nRepeat frmRate
global DataParm %Veiwport Handles MovParm

%%
%%    Check to see that the array size is specified
%%
if nargin < 2,
    error('Array size not specified.');
else
    DataParm.nRows = szArray(1);
    DataParm.nCols = szArray(2);
    [DataParm.nElems DataParm.nSamples] = size(Data);
end

%%
%%  Initial viewport settings
%%
Viewport.xMin = 1;
Viewport.xMax = DataParm.nCols;
Viewport.yMin = 1;
Viewport.yMax = DataParm.nRows;
Viewport.zMax = matmax(Data);
Viewport.zMin = matmin(Data);
Viewport.Az = 322.5;
Viewport.El = 45;
Viewport.flgFixZAxis = 1;

%%
%%  Initial parameter values
%%
DataParm.idxSample = 1;
DataParm.incrSample = 1;
DataParm.idxElem = 1;

%%
%%  Default movie parameters
MovParm.nFrames = 30;
MovParm.nRepeat = 3;
MovParm.frmRate = 5;

%%
%%  Initialize the windows
%%
[Handles.h3dFig Handles.h2dFig Handles.hControl] = InitWindows(1, 2, 3);
    
%%
%%  Initialize 3D graph with mesh plot
%%
inimesh(Data, DataParm, Viewport, Handles)

%%
%%  Initial lead plot
%%
figure(Handles.h2dFig);
InitLeadPlot(Data, DataParm, Viewport, Handles)

%%
%%  Create button control system
%%
figure(Handles.hControl)

szControlWin = get(Handles.hControl, 'position')
hFrame = uicontrol('Style', 'frame', ...
        'ForegroundColor', [.75 .75 .75], ...
        'Position', [0 0 szControlWin(3) szControlWin(4)]);
%%
%%  Compute button and spacing sizes with regards to the window size
%%
npixBtn = szControlWin(4) ./ 20
npixWin = 20 * npixBtn;
npixSpc = 5;


%%
%%  Create a frame for the dialog box at the bottom of the window
%%
hFrame = uicontrol('Style', 'frame', ...
        'ForegroundColor', [.25 .25 .25], ...
        'Position', [2 2 196 6*npixBtn]);

MsgBox.posLine1 = [4 5*(npixBtn)+4 190 npixBtn-8];
MsgBox.posLine2 = [4 4*(npixBtn)+4 190 npixBtn-8];
MsgBox.posLine3 = [4 3*(npixBtn)+4 190 npixBtn-8];
MsgBox.posLine4 = [4 2*(npixBtn)+4 190 npixBtn-8];
MsgBox.posLine5 = [4    npixBtn+4  190 npixBtn-8];
MsgBox.posLine6 = [4    4  190 npixBtn-8];


hTxtSample = uicontrol('Style', 'text', ...
        'Position', [0 npixWin-npixBtn 100 npixBtn], ...
        'String', ['Sample: ' int2str(DataParm.idxSample)]);
        
hBtnFwd = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-npixBtn 100 npixBtn], ...
        'String', 'Forward', ...
        'CallBack', 'i3dfwd;i3drdraw');

        
hBtnBckwd = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-2*npixBtn 100 npixBtn], ...
        'String', 'Backward', 'CallBack',  'i3dbkwd;i3drdraw');

hTextIncr = uicontrol('Style', 'text', ...
        'Position', [0 npixWin-3*npixBtn 100 npixBtn], ...
        'String', ['Increment: ' int2str(DataParm.incrSample)]);
        
hBtnIncr = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-3*npixBtn 100 npixBtn], ...
        'String', 'Set Increment', 'CallBack', 'i3dincr;');

hBtnSpc = uicontrol('style', 'text', ...
        'position', [100 npixWin-3*npixBtn-npixSpc 100 npixSpc]);
        
hBtnSlct = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-4*npixBtn-npixSpc 100 npixBtn], ...
        'String', 'Element Select', 'CallBack', 'i3dslct');

hBtnJump = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-5*npixBtn-npixSpc 100 npixBtn], ...
        'String', 'Time Select', 'CallBack', 'i3djump;i3drdraw');

hBtnSpc = uicontrol('style', 'text', ...
        'position', [100 npixWin-5*npixBtn-2*npixSpc 100 npixSpc]);


hBtnZaxis = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-6*npixBtn-2*npixSpc 100 npixBtn], ...
        'String', 'Z Axis', 'CallBack', 'i3dzaxis');


hTextAz = uicontrol('Style', 'text', ...
        'Position', [0 npixWin-6*npixBtn-2*npixSpc 100 npixBtn], ...
        'String', ['Azimuth: ' num2str(Viewport.Az)]);

hTextEl = uicontrol('Style', 'text', ...
        'Position', [0 npixWin-7*npixBtn-2*npixSpc 100 npixBtn], ...
        'String', ['Elevation: ' num2str(Viewport.El)]);

hBtnView = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-7*npixBtn-2*npixSpc 100 npixBtn], ...
        'String', 'View Point', 'CallBack', 'i3dvwpt');

hBtnSpc = uicontrol('style', 'text', ...
        'position', [100 npixWin-7*npixBtn-3*npixSpc 100 npixSpc]);

hTextType = uicontrol('Style', 'text', ...
        'Position', [0 npixWin-8*npixBtn-3*npixSpc 100 npixBtn], ...
        'String', 'Mesh');

hBtnType = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-8*npixBtn-3*npixSpc 100 npixBtn], ...
        'String', 'Graph Type', 'CallBack', 'typeslct');

hBtnFaceted = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-9*npixBtn-3*npixSpc 50 npixBtn], ...
        'String', 'Facet', ...
        'Callback', 'i3dfacet');

hBtnInterp = uicontrol('style', 'pushbutton', ...
        'position', [150 npixWin-9*npixBtn-3*npixSpc 50 npixBtn], ...
        'String', 'Interp', ...
        'Callback', 'i3dinter');

hBtnSpc = uicontrol('style', 'text', ...
        'position', [100 npixWin-9*npixBtn-4*npixSpc 100 npixSpc]);

hBtnRec = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-10*npixBtn-4*npixSpc 100 npixBtn], ...
        'String', 'Record Movie', ...
        'CallBack', 'i3drecrd');
        
hBtnPlay = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-11*npixBtn-4*npixSpc 100 npixBtn], ...
        'String', 'Play Movie', ...
        'CallBack', 'i3dplyrd');

hBtnSpc = uicontrol('style', 'text', ...
        'position', [100 npixWin-11*npixBtn-5*npixSpc 100 npixSpc]);

hBtnQuit = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-12*npixBtn-5*npixSpc 100 npixBtn], ...
        'String', 'Quit', 'Callback', 'i3dclean');
    
%%
%%  InitWindows - initialize the requested windows (figures) for the 3D figure
%%  the 2D figure and the control window
%%
function [h3dFig, h2dFig, hControl ] = InitWindows(h3dFig, h2dFig, hControl)

%%
%%  Default figure handles
%%
if nargin < 3
    hControl = 3;
    if nargin < 2
        h2dFig = 2;
        if nargin < 1
            h3dFig = 1;
        end
    end
end

%%
%%  Find the size of the current screen resolution
%%
vScreen = get(0, 'ScreenSize');
widthBorder = 4;
widthTitleBar = 14;

%%
%%  Create the 3D figure window
%%
width3d = 0.7 * vScreen(3);
height = 0.6 * vScreen(4);
figure(h3dFig);
clf
set(h3dFig, 'Position', ...
    [4 vScreen(4)-height-2*widthBorder-widthTitleBar width3d height]);
set(h3dFig, 'MenuBar', 'none')
set(h3dFig, 'BackingStore', 'off');
set(h3dFig, 'Renderer', 'zbuffer');

%%
%%  Create the 2D figure
%%
height = 0.4 * vScreen(4);
figure(h2dFig);
clf
set(h2dFig, 'Position', ...
    [widthBorder widthBorder width3d height-5*widthBorder-2*widthTitleBar]);
set(h2dFig, 'MenuBar', 'none');
set(h2dFig, 'BackingStore', 'off');

%%
%%  Create the control window
%%
width = 0.25 *vScreen(3);
height = 0.6 * vScreen(4);

figure(hControl);
clf
if strcmp(computer, 'SGI')
    set(hControl , 'Position', [700 800 200 20*28])
else
    set(hControl, 'Position', ...
        [width3d+2*widthBorder ...
            vScreen(4)-height-2*widthBorder-widthTitleBar ...
            width height])
end
set(hControl, 'MenuBar', 'none');
set(hControl, 'BackingStore', 'off');


figure(h3dFig);
return


%%
%%  InitLeadPlot - create the initial lead plot
%%
function InitLeadPlot(Data, DataParm, Viewport, Handles)

%%
%%  Create a visible colororder
%%
set(gca, 'ColorOrder', ...
  [ 1 0 0;0 1 0;0 0 1;0 1 1;1 0 1;1 1 1]);

Handles.h2dData = plot(Data(DataParm.idxElem,:));
set(Handles.h2dData, 'EraseMode', 'normal')
axis([1 DataParm.nSamples Viewport.zMin Viewport.zMax]);
grid on
hold on

Handles.h2dPointer = plot([DataParm.idxSample DataParm.idxSample], ...
    [Viewport.zMin Viewport.zMax], 'r');
set(Handles.h2dPointer, 'EraseMode', 'normal')

xlabel('Sample Index')
ylabel('Amplitude (mV)')
Handles.hLegend = legend(['Lead: ', int2str(DataParm.idxElem)]);

return
