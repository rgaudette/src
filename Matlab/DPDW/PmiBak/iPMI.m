%iPMI           Interactive Photon Migration Imaging.
%
%   ipmi(dsPMI)
%
%   ds          OPTIONAL: The PMI data structure to use.
%
%
%   iPMI is the interactive GUI to the Photon Migration Imaging system.
%   iPMI will read a PMI data structure filling in the GUI with any values
%   present in the structure.  If a PMI data structure is not supplied no
%   field will be filled in.  To use a previously calculated (or partially
%   calculated) data structure call that data structure ds.  This is the
%   name the execution routines in PMI will read from and write to.
%
%
%   Calls: ui_fwdmed, ui_fwdsrcdet, ui_anomaly, ui_fwdmeth, ui_vistech,
%          ui_invmed, ui_invsrcdet, ui_invmod, ui_recalg
%
%   Callbacks: doFwdCalc, doMeasData, cleanFwdSys, doInvCalc, doNoise,
%              doRecon, doVisualize, btnShrinkWindow
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:31 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: iPMI.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:31  rickg
%  Matlab Source
%
%  Revision 2.2  1999/02/05 20:50:25  rjg
%  Some GUI postional resizing.
%  Added entries for a block object
%  Noise value relabeling (hopefully clearer)
%  Vector norm relative noise
%
%  Revision 2.1  1998/08/07 21:30:10  rjg
%  Added the ability to slice in all three dimensions.
%  Plots now are place on a new figure until reset.
%
%  Revision 2.0  1998/08/05 16:06:56  rjg
%  Updated control dialog box.
%  Added depth and amplitude of sources.
%
%  Revision 1.5  1998/07/30 20:04:06  rjg
%  Removed SIdefines codes, uses string now.
%  UI for all three noise models
%  UI for TCG
%
%  Revision 1.4  1998/06/04 16:13:55  rjg
%  Changed label for SNR to dB from dB peak
%
%  Revision 1.3  1998/06/03 16:47:56  rjg
%  Uses SIdefines codes
%  Interface implementation for PMI execution
%  MTSVD interface
%  ART interface
%  restructured sphere object layout
%
%  Revision 1.2  1998/04/29 15:18:39  rjg
%  Added busy light.
%  
%  Created second column for reconstruction and visualization techniques.
%
%  Revision 1.1  1998/04/28 20:11:22  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function iPMI(ds)

%%
%%  Global UI layout parameters
%%
if strcmp(computer, 'LNX86')
    stYColumn = 600;
    stXFrm = 4;
    szXFrm = 275;
    szXColumn = szXFrm + 8;
    szYEdit = 17;
    szFonts = 9;
    FontName = 'arial';
else
    stYColumn = 535;
    stXFrm = 4;
    szXFrm = 220;
    szXColumn = szXFrm + 8;
    szYEdit = 15;
    szFonts = 8;
    FontName = 'Arial';
end    

UIHandles.FullWindow = [3*szXColumn stYColumn];
UIHandles.BtnWindow = [3*szXColumn 27];
a = figure('Units','points', ...
    'Color', [0.7529 0.7529 0.7529], ...
    'Position',[3 24 3*szXColumn stYColumn]);
UI_Handles.FigControl = a;

UIHandles.CurrFigure = gcf + 1;


set(a, 'MenuBar', 'none', 'NumberTitle', 'off', 'Name', ...
    'Photon Migration Imaging');

set(a, 'DefaultUicontrolFontSize', szFonts)
set(a, 'DefaultUicontrolFontName', FontName)


%%
%%  Busy light
%%
hBusyAx = axes('units', 'points', ...
    'position', [3*szXColumn-20 1 20 20], ...
    'Color' ,'none', ...
    'visible', 'off');
hold on
UIHandles.hLight = plot(0.5, 0.5, 'og');
set(UIHandles.hLight, 'LineWidth', 8);

%%
%%  Initial reference point
%%

UIHandles.vTAB1 = [];
UIHandles.vTAB2 = [];

%%
%% 1st Column
%%
[UIHandles YEnd] = ui_fwdmed(a, UIHandles, stXFrm, szXFrm, stYColumn, ...
    szYEdit);

[UIHandles YEnd] = ui_fwdsrcdet(a, UIHandles, stXFrm, szXFrm, YEnd, ...
    szYEdit);

%%
%%  2nd Column
%%
stXFrm = stXFrm + szXColumn;

[UIHandles YEnd] = ui_anomaly(a, UIHandles, stXFrm, szXFrm, stYColumn, ...
    szYEdit);

[UIHandles YEnd] = ui_fwdmeth(a, UIHandles, stXFrm, szXFrm, YEnd, ...
    szYEdit);

[UIHandles YEnd] = ui_vistech(a, UIHandles, stXFrm, szXFrm, YEnd, ...
    szYEdit);

%%
%%  3rd Column
%%
stXFrm = stXFrm + szXColumn;

[UIHandles YEnd] = ui_invmed(a, UIHandles, stXFrm, szXFrm, stYColumn, ...
    szYEdit);

[UIHandles YEnd] = ui_invsrcdet(a, UIHandles, stXFrm, szXFrm, YEnd, ...
    szYEdit);

[UIHandles YEnd] = ui_invmod(a, UIHandles, stXFrm, szXFrm, YEnd, ...
    szYEdit);

[UIHandles YEnd] = ui_recalg(a, UIHandles, stXFrm, szXFrm, YEnd, ...
    szYEdit);

%%
%%  Calculation and control buttons
%%
uicontrol('Parent',a, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'String', 'Calc Fwd Sys', ...
    'callback', 'doFwdCalc', ...
    'Position',[5 5 58 17 ]', ...
    'Style','pushbutton');

uicontrol('Parent',a, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'String', 'Meas. Data', ...
    'callback', 'doMeasData', ...
    'Position',[65 5 58 17 ]', ...
    'Style','pushbutton');

uicontrol('Parent',a, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'String', 'Clean Fwd Sys', ...
    'callback', 'ds = cleanFwdSys(ds);', ...
    'Position',[125 5 58 17 ]', ...
    'Style','pushbutton');


uicontrol('Parent',a, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'String', 'Calc Inv Sys', ...
    'callback', 'doInvCalc', ...
    'Position',[185 5 58 17 ]', ...
    'Style','pushbutton');

uicontrol('Parent',a, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'String', 'Add Noise', ...
    'callback', 'doNoise', ...
    'Position',[245 5 58 17 ]', ...
    'Style','pushbutton');

uicontrol('Parent',a, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'String', 'Reconstruct', ...
    'callback', 'doRecon', ...
    'Position',[305 5 58 17 ]', ...
    'Style','pushbutton');

uicontrol('Parent',a, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'String', 'Visualize', ...
    'callback', 'doVisualize', ...
    'Position',[365 5 58 17 ]', ...
    'Style','pushbutton');

uicontrol('Parent',a, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'String', 'Reset Fig#', ...
    'callback', 'rstFigCnt;', ...
    'Position',[425 5 58 17 ]', ...
    'Style','pushbutton');

UIHandles.hBtnShrink = uicontrol('Parent',a, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'String', 'Shrink Window', ...
    'callback', 'btnShrinkWindow', ...
    'Position',[485 5 58 17 ]', ...
    'Style','pushbutton');


set(gcf, 'UserData', UIHandles);

if nargin > 0
    setall(ds, gcf);
end
orient tall