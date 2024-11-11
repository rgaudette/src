function varargout = intDenoise(varargin)
% INTDENOISE M-file for intDenoise.fig
%      INTDENOISE, by itself, creates a new INTDENOISE or raises the existing
%      singleton*.
%
%      H = INTDENOISE returns the handle to a new INTDENOISE or the handle to
%      the existing singleton*.
%
%      INTDENOISE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTDENOISE.M with the given input arguments.
%
%      INTDENOISE('Property','Value',...) creates a new INTDENOISE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before intDenoise_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to intDenoise_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/03/11 01:53:50 $
%
%  $Revision: 1.2 $
%
%  $Log: intDenoise.m,v $
%  Revision 1.2  2004/03/11 01:53:50  rickg
%  Moved threshold functions out of file
%  Fixed bug in swt denoising that did not threshold v and d details
%  Fixed bug in swt denoising that had the non-white thresholds backwards
%  Added ability to show difference
%
%  Revision 1.1  2004/03/04 20:39:53  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Edit the above text to modify the response to help intDenoise

% Last Modified by GUIDE v2.5 10-Mar-2004 15:59:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @intDenoise_OpeningFcn, ...
                   'gui_OutputFcn',  @intDenoise_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
  % check to see if the first argument in a file, the we assume it is data to be
  % opened
  fid = fopen(varargin{1}, 'r');
  if fid == -1
    gui_State.gui_Callback = str2func(varargin{1});
  else
    fclose(fid);
  end
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before intDenoise is made visible.
function intDenoise_OpeningFcn(hObject, eventdata, handles, varargin)
if nargin < 2
  disp('Usage: intDenoise(''mRCFilename'')')
end

% Load in the MRC stack header 
handles.mRCStack = MRCImage(varargin{1}, 0);
initializeUI(handles);

% Selection region boundaries initialization
handles.lineTop = [];
handles.lineBottom = [];
handles.lineLeft = [];
handles.lineRight = [];

handles.image = ...
    getImage(handles.mRCStack, ...
             str2double(get(handles.sectionNumber, 'String')));
setBlackLevelUI(double(min(handles.image(:))), handles);
setWhiteLevelUI(double(max(handles.image(:))), handles);

% Choose default command line output for intDenoise
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
initializeAxis
showImage(handles)

% UIWAIT makes intDenoise wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = intDenoise_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function sectionNumber_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function sectionNumber_Callback(hObject, eventdata, handles)
sectionNumber = str2double(get(hObject,'String'));
nSections = getNZ(handles.mRCStack);
if sectionNumber < 1 | sectionNumber > nSections
  fprintf('Section number must be between 1 and %d\n', nSections)
end

% Update the image data
handles.image = getImage(handles.mRCStack, sectionNumber);
set(handles.transform, 'Enable', 'on');

% TODO: Reset the state on the UI objects
guidata(hObject, handles);
showImage(handles)


% --- Executes during object creation, after setting all properties.
function zoomValue_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function zoomValue_Callback(hObject, eventdata, handles)
showImage(handles);



% --- Executes during object creation, after setting all properties.
function sldBlack_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function sldBlack_Callback(hObject, eventdata, handles)
blackValue = get(hObject,'Value');
setBlackLevelUI(blackValue, handles);
checkWhiteLevelUI(blackValue, handles)
setContrast(handles)

% --- Executes during object creation, after setting all properties.
function blackLevel_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function blackLevel_Callback(hObject, eventdata, handles)
blackValue = str2double(get(hObject,'String'));
setBlackLevelUI(blackValue, handles);
checkWhiteLevelUI(blackValue, handles);
setContrast(handles)

function setBlackLevelUI(blackValue, handles)
set(handles.sldBlack, 'Value', blackValue);
set(handles.blackLevel, 'String', int2str(blackValue));

function checkWhiteLevelUI(blackValue, handles)
whiteValue = str2double(get(handles.whiteLevel,'String'));
if blackValue > whiteValue
  setWhiteLevelUI(blackValue + 10 * eps, handles);
end


% --- Executes during object creation, after setting all properties.
function sldWhite_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function sldWhite_Callback(hObject, eventdata, handles)
whiteValue = get(hObject,'Value');
setWhiteLevelUI(whiteValue, handles);
checkBlackLevelUI(whiteValue, handles);
setContrast(handles)


% --- Executes during object creation, after setting all properties.
function whiteLevel_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in whiteLevel.
function whiteLevel_Callback(hObject, eventdata, handles)
whiteValue = str2double(get(hObject,'String'));
setWhiteLevelUI(whiteValue, handles)
checkBlackLevelUI(whiteValue, handles)
setContrast(handles)

function setWhiteLevelUI(whiteValue, handles)
set(handles.whiteLevel,'String', int2str(whiteValue));
set(handles.sldWhite, 'Value', whiteValue);

function checkBlackLevelUI(whiteValue, handles)
blackValue = str2double(get(handles.blackLevel,'String'));
if blackValue > whiteValue
  setBlackLevelUI(whiteValue - 10 * eps, handles)
end


function setContrast(handles)
set(gca, 'CLim', ...
         [get(handles.sldBlack, 'value') get(handles.sldWhite, 'value')]);


% --- Executes on button press in rbDiscreteWT.
function rbDiscreteWT_Callback(hObject, eventdata, handles)
setStationaryWT(0, handles);
set(handles.transform, 'Enable', 'on');

% --- Executes on button press in rbStationaryWT.
function rbStationaryWT_Callback(hObject, eventdata, handles)
setStationaryWT(1, handles);
set(handles.transform, 'Enable', 'on');

function setStationaryWT(state, handles)
if state
  set(handles.rbStationaryWT, 'Value', 1);
  set(handles.rbDiscreteWT, 'Value', 0);
else
  set(handles.rbStationaryWT, 'Value', 0);
  set(handles.rbDiscreteWT, 'Value', 1);
end 



% --- Executes during object creation, after setting all properties.
function waveletFamily_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in waveletFamily.
function waveletFamily_Callback(hObject, eventdata, handles)
contents = get(hObject, 'String');
waveletFamily = contents{get(hObject, 'Value')};
updateWaveletOrder(waveletFamily, handles);
set(handles.transform, 'Enable', 'on');

function updateWaveletOrder(waveletFamily, handles)
switch  waveletFamily
 case 'haar'
  set(handles.analysisOrder, 'Enable', 'off');
  set(handles.synthOrder, 'Enable', 'off');
  
 case 'db'
  set(handles.analysisOrder, 'Enable', 'on');
  set(handles.synthOrder, 'Enable', 'off');

 case 'sym'
  set(handles.analysisOrder, 'Enable', 'on');
  set(handles.synthOrder, 'Enable', 'off');
 
 case 'coif'
  set(handles.analysisOrder, 'Enable', 'on');
  set(handles.synthOrder, 'Enable', 'off');

 case 'bior'
  set(handles.analysisOrder, 'Enable', 'on');
  set(handles.synthOrder, 'Enable', 'on');
 
 case 'rbio'
  set(handles.analysisOrder, 'Enable', 'on');
  set(handles.synthOrder, 'Enable', 'on');
end


% --- Executes during object creation, after setting all properties.
function waveletLevel_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function waveletLevel_Callback(hObject, eventdata, handles)
set(handles.transform, 'Enable', 'on');

% --- Executes on button press in transform.
function transform_Callback(hObject, eventdata, handles)
computeTransform(handles)
set(hObject, 'Enable', 'off');

% --- Executes during object creation, after setting all properties.
function analysisOrder_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function analysisOrder_Callback(hObject, eventdata, handles)
set(handles.transform, 'Enable', 'on');

% --- Executes during object creation, after setting all properties.
function synthOrder_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function synthOrder_Callback(hObject, eventdata, handles)
set(handles.transform, 'Enable', 'on');


% --- Executes on button press in rbHardThreshold.
function rbHardThreshold_Callback(hObject, eventdata, handles)
setHardThreshold(1, handles)

% --- Executes on button press in rbSoftThreshold.
function rbSoftThreshold_Callback(hObject, eventdata, handles)
setHardThreshold(0, handles)

function setHardThreshold(state, handles)
if state
  set(handles.rbHardThreshold, 'Value', 1);
  set(handles.rbSoftThreshold, 'Value', 0);
else
  set(handles.rbHardThreshold, 'Value', 0);
  set(handles.rbSoftThreshold, 'Value', 1);
end 

% --- Executes during object creation, after setting all properties.
function noiseStructure_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in noiseStructure.
function noiseStructure_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function threshFunction_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in threshFunction.
function threshFunction_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function threshSlider_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function threshSlider_Callback(hObject, eventdata, handles)
setThresholdWeighting(get(hObject,'Value'), handles);
denoiseAndUpdate(hObject, handles);


% --- Executes during object creation, after setting all properties.
function threshWeighting_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function threshWeighting_Callback(hObject, eventdata, handles)
setThresholdWeighting(str2double(get(hObject,'String')), handles); 
denoiseAndUpdate(hObject, handles);

function setThresholdWeighting(value, handles)
if value > get(handles.threshSlider, 'Max')
  set(handles.threshSlider, 'Max', value);
end
if value < get(handles.threshSlider, 'Min')
  set(handles.threshSlider, 'Min', value);
end
set(handles.threshSlider, 'Value', value);
set(handles.threshWeighting, 'String', num2str(value))
  


% --- Executes on button press in btnDenoise.
function btnDenoise_Callback(hObject, eventdata, handles)
denoiseAndUpdate(hObject, handles);

% --- Executes on button press in tbtnSwapView.
function tbtnSwapView_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
  showImage(handles);
  set(hObject, 'String', 'Denoised Image');
else
  showReconstruction(handles)
  set(hObject, 'String', 'Orig. Image');
end

function initializeUI(handles)
% Set the default values of the UI elements
set(handles.sectionNumber, 'String', '1');
set(handles.zoomValue, 'String', '1.0');

switch getModeString(handles.mRCStack)
 case 'uint8'
  set(handles.sldBlack, 'Min', 0);
  set(handles.sldWhite, 'Min', 0);
  set(handles.sldBlack, 'Max', 255);
  set(handles.sldWhite, 'Max', 255);
  set(handles.sldBlack, 'Value', 0);
  set(handles.sldWhite, 'Value', 255);

  set(handles.sldBlack, 'SliderStep', [1 10]./255);
  set(handles.sldWhite, 'SliderStep', [1 10]./255);
 case 'int16'
  set(handles.sldBlack, 'Min', -32768);
  set(handles.sldWhite, 'Min', -32769);
  set(handles.sldBlack, 'Max', 32767);
  set(handles.sldWhite, 'Max', 32767);
  set(handles.sldBlack, 'Value', 0);
  set(handles.sldWhite, 'Value', 32767);
  set(handles.sldBlack, 'SliderStep', [1 1000]./65536);
  set(handles.sldWhite, 'SliderStep', [1 1000]./65536);
end

setStationaryWT(1, handles);
set(handles.waveletFamily, 'Value', 3);
contents = get(handles.waveletFamily, 'String');
waveletFamily = contents{get(handles.waveletFamily, 'Value')};
updateWaveletOrder(waveletFamily, handles);
set(handles.analysisOrder, 'String', '6');
set(handles.synthOrder, 'String', '3');
set(handles.waveletLevel, 'String', '3');

setHardThreshold(1, handles)
set(handles.threshFunction, 'Value', 1);


% Initialize the figure and axes
function initializeAxis
set(gcf, 'Renderer', 'openGL')
set(gca, 'ydir', 'normal')
axis('image')
colormap(gray(256));
set(gca, 'ButtonDownFcn', @axesButtonFcn)

% Start to draw the selection box over the image, this function is called
% when the user first pressed the left mouse button over the image
function axesButtonFcn(obj, eventData)
point = get(gca, 'CurrentPoint');
handles = guidata(gcf);
handles.startX = point(1,1);
handles.startY = point(1,2);
hold on

if ishandle(handles.lineTop)
  delete(handles.lineTop)
end
if ishandle(handles.lineLeft)
  delete(handles.lineLeft)
end
if ishandle(handles.lineBottom)
  delete(handles.lineBottom)
end
if ishandle(handles.lineRight)
  delete(handles.lineRight)
end
handles.lineTop = ...
    plot([handles.startX handles.startX], [handles.startY handles.startY], 'g');
handles.lineLeft = ...
    plot([handles.startX handles.startX], [handles.startY handles.startY], 'g');
handles.lineBottom = ...
    plot([handles.startX handles.startX], [handles.startY handles.startY], 'g');
handles.lineRight = ...
    plot([handles.startX handles.startX], [handles.startY handles.startY], 'g');
hold off
guidata(gcf, handles);
set(gcf, 'WindowButtonMotionFcn', @axesMouseMoveFcn);
set(gcf, 'WindowButtonUpFcn', @axesUpFcn);


% Redraw the selection box as the mouse is moved
function axesMouseMoveFcn(obj, eventData)
point = get(gca, 'CurrentPoint');
stopX = point(1,1);
stopY = point(1,2);
handles = guidata(gcf);

set(handles.lineTop, 'XData', [handles.startX stopX]);
set(handles.lineTop, 'YData', [stopY stopY]);
set(handles.lineLeft, 'XData', [handles.startX handles.startX]);
set(handles.lineLeft, 'YData', [handles.startY stopY]);
set(handles.lineBottom, 'XData', [handles.startX stopX]);
set(handles.lineBottom, 'YData', [handles.startY handles.startY]);
set(handles.lineRight, 'XData', [stopX stopX]);
set(handles.lineRight, 'YData', [handles.startY stopY]);


% Reset the mouse movement funxtions
function axesUpFcn(obj, eventData)
set(gcf, 'WindowButtonMotionFcn', '');
set(gcf, 'WindowButtonUpFcn', '');

% --- Executes on button press in btnSelectedRegion.
function btnSelectedRegion_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectedRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.lineTop)
  disp('Select a region with the mouse first')
  beep
  return;
end
xValues = round(get(handles.lineTop, 'XData'));
yValues = round(get(handles.lineLeft, 'YData'));
handles.image = handles.image(xValues(1):xValues(2), yValues(1):yValues(2));
showImage(handles);
guidata(hObject, handles);

% --- Executes on button press in btnViewFull.
function btnViewFull_Callback(hObject, eventdata, handles)
% hObject    handle to btnViewFull (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.image = ...
    getImage(handles.mRCStack, ...
             str2double(get(handles.sectionNumber, 'String')));
showImage(handles)
guidata(hObject, handles);


% --- Executes when figure1 window is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Update the axes with the specified image in the handles
function showImage(handles)
hImage = imagesc(rot90(handles.image));
setBlackLevelUI(double(min(handles.image(:))), handles);
setWhiteLevelUI(double(max(handles.image(:))), handles);
setContrast(handles);

set(hImage, 'ButtonDownFcn', @axesButtonFcn);
fitAxes(str2double(get(handles.zoomValue, 'String')));
set(handles.tbtnSwapView, 'value', 1)
set(handles.tbtnSwapView, 'String', 'Denoised Image');


%  Compute the selected wavelet transform, storing the result in handles.decomp
%  and handles.decompStruct
function computeTransform(handles)
contents = get(handles.waveletFamily, 'String');
familyString = contents{get(handles.waveletFamily, 'Value')};
switch familyString
 case 'db'
  familyString = [familyString get(handles.analysisOrder, 'String')];
 case 'sym'
  familyString = [familyString get(handles.analysisOrder, 'String')];
 case 'coif'
  familyString = [familyString get(handles.analysisOrder, 'String')];
 case 'bior'
  familyString = [familyString get(handles.analysisOrder, 'String') ...
                   '.' get(handles.analysisOrder, 'String')];
 case 'rbio'
  familyString = [familyString get(handles.analysisOrder, 'String') ...
                   '.' get(handles.analysisOrder, 'String')];
end
handles.familyString = familyString;
decompLevel = str2double(get(handles.waveletLevel, 'String'));
fprintf('%s %d ', familyString, decompLevel);
stationaryWT = get(handles.rbStationaryWT, 'Value');
if stationaryWT
  fprintf('stationary\n');
  %FIXME
  im = double(handles.image);
  [nX nY] = size(im);
  nX = floor(nX / 2 ^ decompLevel) * 2 ^ decompLevel;
  nY = floor(nY / 2 ^ decompLevel) * 2 ^ decompLevel;
  im = im(1:nX, 1:nY);
  handles.SWC = swt2(im, decompLevel, familyString);
else
  fprintf('discrete\n');
  [handles.decomp handles.decompStruct] = ...
      wavedec2(double(handles.image), decompLevel, familyString);
end
guidata(gcf, handles);
showTransform(handles);


% TODO:implement
function showTransform(handles)
%handles.decompStruct


function denoiseAndUpdate(hObject, handles)
handles.recon = denoiseImage(handles);
guidata(hObject, handles);
showReconstruction(handles);


function recon = denoiseImage(handles)
contents = get(handles.noiseStructure, 'String');
noiseStructure = contents{get(handles.noiseStructure, 'Value')};
contents = get(handles.threshFunction, 'String');
threshFunction = contents{get(handles.threshFunction, 'Value')};

if get(handles.rbHardThreshold, 'Value')
  sorh = 'h';
else
  sorh = 's';
end
tWeight = str2double(get(handles.threshWeighting, 'String'));
fprintf('%s %s %s %f\n', sorh, threshFunction, noiseStructure, tWeight);
stationaryWT = get(handles.rbStationaryWT, 'Value');
if stationaryWT
  tSWC = swtThreshold(handles.SWC, sorh, ...
                      noiseStructure, threshFunction, tWeight);
  [nX nY] = size(handles.image);
  decompLevel = str2double(get(handles.waveletLevel, 'String'));
  nX = floor(nX / 2 ^ decompLevel) * 2 ^ decompLevel;
  nY = floor(nY / 2 ^ decompLevel) * 2 ^ decompLevel;
  recon = double(handles.image);
  recon(1:nX, 1:nY) = iswt2(tSWC, handles.familyString);

else
  tDecomp = dwtThreshold(handles.decomp, handles.decompStruct, sorh, ...
                         noiseStructure, threshFunction, tWeight);
  recon = waverec2(tDecomp, handles.decompStruct, handles.familyString);
end





function showReconstruction(handles)
hImage = imagesc(rot90(handles.recon));
setBlackLevelUI(double(min(handles.recon(:))), handles);
setWhiteLevelUI(double(max(handles.recon(:))), handles);
setContrast(handles);
set(handles.tbtnSwapView, 'value', 0);
set(handles.tbtnSwapView, 'String', 'Orig. Image');


function showDifference(handles)
difference = handles.recon - double(handles.image);
hImage = imagesc(rot90(difference));
setBlackLevelUI(min(difference(:)), handles);
setWhiteLevelUI(max(difference(:)), handles);
setContrast(handles);


function fitAxes(scale)
% Get the current figure position, the current axes, and axis dimensions
set(gca, 'DataAspectRatioMode', 'manual');
set(gca, 'PlotBoxAspectRatioMode', 'manual');
set(gcf, 'units', 'pixels');
set(gca, 'units', 'pixels');
figPosition = get(gcf, 'position');
axesPosition = get(gca, 'position');
axisSize = axis;

% Calculate the new axes size
nAxesPixelsX = (axisSize(2) - axisSize(1)) * scale;
nAxesPixelsY = (axisSize(4) - axisSize(3)) * scale;
newAxesPosition = axesPosition;
newAxesPosition(3) = nAxesPixelsX;
newAxesPosition(4) = nAxesPixelsY;

% Calculate the new figure window size and set it, keeping the upper left
% corner of the window stationary
nFigPixelsY =  max(700, axesPosition(2) + nAxesPixelsY + 20);
windLocY = figPosition(2) + figPosition(4);
figPosition(2) = windLocY - nFigPixelsY;
figPosition(3) = axesPosition(1) + nAxesPixelsX + 20;
figPosition(4) = nFigPixelsY;

% Need to set figure properties before the axis properties
set(gcf, 'position', figPosition);
set(gca, 'position', newAxesPosition);


% --- Executes on button press in btnDifference.
function btnDifference_Callback(hObject, eventdata, handles)
showDifference(handles)

