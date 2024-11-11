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
%  Revision 1.4  1997/07/14 20:19:32  rjg
%  Added button sizing w.r.t. screen size.
%  Added a private window init function.
%  Change comments regarding square image.
%
%  Revision 1.3  1997/04/06 19:27:15  rjg
%  Added a 6th message line
%  Include nRepeat & frmRate as globals
%  Setup color order
%  Changed callback function for movie playing to i3dplyrd
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

global Data nRows nCols nSamples idxSample incrSample idxElem
global h2dData h2dPointer hLegend
global h3dFig h3dData h3dPoint flgFixZAxis
global hTxtSample hTextIncr hTextAz hTextEl hTextType
global posMessageL1 posMessageL2 posMessageL3 posMessageL4 posMessageL5 posMessageL6
global xMin xMax yMin yMax zMin zMax Az El
global nFrames Movie nRepeat frmRate

%%
%%  Extract number of array elements and number of time samples present in data.
%%  Each time instant should be represented by column index, array element by
%%  row index.  Also extract data maxima and minima.
%%
[nElems nSamples] = size(Data);

%%
%%    Check to see that the array size is specified
%%
if nargin < 2,
    error('Array size not specified.');
else
    nRows = szArray(1);
    nCols = szArray(2);
end


%%
%%  Initial axis ranges
%%
xMin = 1;
xMax = nCols;
yMin = 1;
yMax = nRows;
zMax = matmax(Data);
zMin = matmin(Data);
Az = 322.5;
El = 45;

%%
%%  Initial parameter values
%%
idxSample = 1;
incrSample = 1;
idxElem = 1;
flgFixZAxis = 1;
nFrames = 30;
nRepeat = 3;
frmRate = 5;

%%
%%  Initialize the window layout
%%
[h3dFig h2dFig hControl] = InitWindows(1, 2, 3);

%%
%%  Initialize 3D graph with mesh plot
%%
inimesh;

%%
%%  Initial lead plot
%%
figure(h2dFig);
set(gca, 'ColorOrder', ...
  [ 1 0 0;0 1 0;0 0 1;0 1 1;1 0 1;1 1 1]);
h2dData = plot(Data(idxElem,:));
set(h2dData, 'EraseMode', 'normal')
grid
hold on
axis([1 nSamples zMin zMax]);
h2dPointer = plot([idxSample idxSample], [zMin zMax], 'r');
set(h2dPointer, 'EraseMode', 'normal')
xlabel('Sample Index')
ylabel('Amplitude (mV)')
hLegend = legend(['Lead: ', int2str(idxElem)]);

%%
%%  Create button control system
%%
figure(hControl)

%%
%%  Compute button and spacing sizes with regards to the window size
%%
szControlWin = get(hControl, 'position');
npixBtn = szControlWin(4) ./ 20;
npixWin = 20 * npixBtn;
npixSpc = 5;

%%
%%  Create a frame for the dialog box at the bottom of the window
%%
hFrame = uicontrol('Style', 'frame', ...
        'ForegroundColor', [.25 .25 .25], ...
        'Position', [2 2 196 6*npixBtn]);


posMessageL1 = [4 5*(npixBtn)+4 190 npixBtn-4];
posMessageL2 = [4 4*(npixBtn)+4 190 npixBtn-4];
posMessageL3 = [4 3*(npixBtn)+4 190 npixBtn-4];
posMessageL4 = [4 2*(npixBtn)+4 190 npixBtn-4];
posMessageL5 = [4    npixBtn+4  190 npixBtn-4];
posMessageL6 = [4    4  190 npixBtn-4];

hTxtSample = uicontrol('Style', 'text', ...
        'Position', [0 npixWin-npixBtn 100 npixBtn], ...
        'String', ['Sample: ' int2str(idxSample)]);
%%
%%  Extract the current background color for the UI controls and make that
%%  the background color for the figure
BckgrndColor = get(hTxtSample, 'BackgroundColor');
set(hControl, 'Color', BckgrndColor);

hBtnFwd = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-npixBtn 100 npixBtn], ...
        'String', 'Forward', 'CallBack', 'i3dfwd;i3drdraw');

        
hBtnBckwd = uicontrol('style', 'pushbutton', ...
        'position', [100 npixWin-2*npixBtn 100 npixBtn], ...
        'String', 'Backward', 'CallBack',  'i3dbkwd;i3drdraw');

hTextIncr = uicontrol('Style', 'text', ...
        'Position', [0 npixWin-3*npixBtn 100 npixBtn], ...
        'String', ['Increment: ' int2str(incrSample)]);
        
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
        'String', ['Azimuth: ' num2str(Az)]);

hTextEl = uicontrol('Style', 'text', ...
        'Position', [0 npixWin-7*npixBtn-2*npixSpc 100 npixBtn], ...
        'String', ['Elevation: ' num2str(El)]);

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
%colordef none
clf
%set(h3dFig, 'Color', [0 0 0])
%set(h3dFig, 'Renderer', 'zbuffer');
set(h3dFig, 'Position', ...
    [4 vScreen(4)-height-2*widthBorder-widthTitleBar width3d height]);
set(h3dFig, 'MenuBar', 'none')
%set(h3dFig, 'BackingStore', 'off');

%%
%%  Create the 2D figure
%%
height = 0.4 * vScreen(4);
figure(h2dFig);
clf
%set(h3dFig, 'Color', [0 0 0])
%set(h2dFig, 'Renderer', 'zbuffer');
set(h2dFig, 'Position', ...
    [widthBorder widthBorder+20 width3d height-5*widthBorder-2*widthTitleBar-20]);
set(h2dFig, 'MenuBar', 'none');
%set(h2dFig, 'BackingStore', 'off');

%%
%%  Create the control window
%%
width = 0.2 *vScreen(3);
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
%set(hControl, 'BackingStore', 'off');


figure(h3dFig);
return
