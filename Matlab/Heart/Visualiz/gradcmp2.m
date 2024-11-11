%GRADCMP2       Compare temporal gradient at two scales
%
%   gradcmp2(fX, fY, fZ1, fZ2, F, szArray)
%
%   fX          X dimension partial derivative estimate.
%
%   fY          Y dimension partial derivative estimate.
%
%   fZ1         Z dimension partial derivative estimate #1.
%
%   fZ2         Z dimension partial derivative estimate #2.
%
%   F           Original 3D signal
%
%   szArray     The size of data array for each instance of Z.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:46 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: gradcmp2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:46  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/23 00:07:32  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function gradcmp2(fX, fY, fZ1, fZ2, F, szArray)

%%
%%  Extract number of array elements and number of time samples present in 
%%  data.  Each time instant should be represented by column index, array 
%%  element by row index.  Also extract data maxima and minima.
%%
[nElems nSamples] = size(fX);

nRows = szArray(1);
nCols = szArray(2);

%%
%%  Initial parameters
%%
idxSample = 125;
idxLead = 136;
incrSample = 1;
flgFixColor = 0;

%%
%%  Find the extrema for all functions
%%
xMin = 1;
xMax = nCols;
yMin = 1;
yMax = nRows;

fZ1Min = matmin(fZ1);
fZ1Max = matmax(fZ1);
fZ2Min = matmin(fZ2);
fZ2Max = matmax(fZ2);

%%
%%  Extract spatial arrays from functions, and compute polar coordinates
%%
XData = reshape(fX(:, idxSample), nRows, nCols);
YData = reshape(fY(:, idxSample), nRows, nCols);
Z1Data = reshape(fZ1(:, idxSample), nRows, nCols);
Z2Data = reshape(fZ2(:, idxSample), nRows, nCols);
GradMag = sqrt(XData .^ 2 + YData .^2);
SpatAng = atan2(YData, XData) * (180/pi);
Temp1Ang = atan2(Z1Data, GradMag) * (180/pi);
Temp2Ang = atan2(Z2Data, GradMag) * (180/pi);

GradMin = matmin(GradMag);
GradMax = matmax(GradMag);

%%
%%  Create axis for cartesian and polar representations.
%%
clf
colormap(vibgyor(128))
set(gcf, 'Units', 'Normalized');
set(gcf, 'BackingStore', 'off');
set(gcf, 'MenuBar', 'none');
%%
%%  Axis layout constants
%%
AspectRatio = 6/5;
AxesWidth = 0.24;
AxesHeight = AxesWidth * AspectRatio;
YTopRow = 0.43;
YBotRow = 0.06;
XLeftCol = 0.05;
XSpace = 0.02;
CBWidth = 0.03;

%%
%%  Gradient magnitude display
%%
hGradMag = axes('Position', [XLeftCol YTopRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hGradMag, 'YDir', 'Reverse');
set(hGradMag, 'CLim', [GradMin GradMax]);
set(hGradMag, 'View', [0 90]);
hGradSurf = surface(GradMag);
title('Spatial Gradient Magnitude')
drawnow

%%
%%  Gradient magnitude colorbar
%%
hGradMagCB = axes('Position', ...
    [XLeftCol+AxesWidth+XSpace/3 YTopRow CBWidth AxesHeight]);
set(hGradMagCB, 'CLim', [GradMin GradMax]);    
colorbar(hGradMagCB);

%%
%%  Z #1 display
%%
hFZ1 = axes('Position', ...
    [XLeftCol+AxesWidth+2*XSpace+CBWidth YTopRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hFZ1, 'DrawMode', 'Fast');
set(hFZ1, 'YTickLabels', '');
set(hFZ1, 'YDir', 'Reverse');
set(hFZ1, 'clim', [fZ1Min fZ1Max]);
hZ1Surf = surface(Z1Data);
set(hZ1Surf, 'EraseMode', 'none')
title('Z #1')
drawnow

%%
%%  Z #1 colorbar
%%
hFZ1CB = axes('Position', ...
    [XLeftCol+2*AxesWidth+4*XSpace YTopRow CBWidth AxesHeight]);
set(hFZ1CB, 'CLim', [fZ1Min fZ1Max]);    
colorbar(hFZ1CB);

%%
%%  Z #2 display
%%
hFZ2 = axes('Position', ...
    [XLeftCol+2*AxesWidth+6*XSpace+CBWidth YTopRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hFZ2, 'DrawMode', 'Fast');
set(hFZ2, 'YTickLabels', '');
set(hFZ2, 'YDir', 'Reverse');
set(hFZ2, 'clim', [fZ2Min fZ2Max]);
hZ2Surf = surface(Z2Data);
set(hZ2Surf, 'EraseMode', 'none');
title('Z #2')
drawnow

%%
%%  Z #2 colorbar
%%
hFZ2CB = axes('Position', ...
    [XLeftCol+3*AxesWidth+6*XSpace+CBWidth+XSpace/3 YTopRow CBWidth AxesHeight]);
set(hFZ2CB, 'clim', [fZ2Min fZ2Max]);
colorbar(hFZ2CB);
drawnow

%%
%%  Spatial angle display
%%
hSpatAng = axes('Position', ...
 [XLeftCol YBotRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hSpatAng, 'DrawMode', 'Fast');
set(hSpatAng, 'YDir', 'Reverse');
hold on
set(gca, 'colororder', [1 0 0])
hSpatQuiv = quiver(XData, YData);
hold off
title('Spatial Angle')
drawnow

%%
%%  Temporal angle #1 display
%%
hTempAng1 = axes('Position', ...
    [XLeftCol+AxesWidth+2*XSpace+CBWidth YBotRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hTempAng1, 'DrawMode', 'Fast');
set(hTempAng1, 'YTickLabels', '');
set(hTempAng1, 'YDir', 'Reverse');
hold on
set(gca, 'colororder', [1 0 0])
hTempQuiv1 = quiver(GradMag, -1*Z1Data);
hold off
title('Z1 Angle')
drawnow

%%
%%  Temporal angle #1 display
%%
hTempAng2 = axes('Position', ...
    [XLeftCol+2*AxesWidth+6*XSpace+CBWidth YBotRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hTempAng2, 'DrawMode', 'Fast');
set(hTempAng2, 'YTickLabels', '');
set(hTempAng2, 'YDir', 'Reverse');
%hTempSurf = surface(TempAng);
hold on
set(gca, 'colororder', [1 0 0])
hTempQuiv2 = quiver(GradMag, -1*Z2Data);
hold off
title('Z2 Angle')
drawnow


%%
%%  Draw single lead plot at top
%%
hLeadAx = axes('position', [0.25 0.82 0.5 0.15]);
[nLeads nSamps] = size(F);
plot(F(idxLead,:), 'g');
axis([0 nSamps -50 25])
grid
xlabel('Time (mS)');
ylabel('Amplitude (mV)');
hold on
hTime = plot([idxSample idxSample], [-100 100], 'r');
hold off

flgQuit = 0; flgRedraw = 0;
while flgQuit == 0,
    if flgRedraw,

        %%
        %%  Redraw the cartesian maps
        %%
        XData = reshape(fX(:, idxSample), nRows, nCols);
        YData = reshape(fY(:, idxSample), nRows, nCols);
        Z1Data = reshape(fZ1(:, idxSample), nRows, nCols);
        Z2Data = reshape(fZ2(:, idxSample), nRows, nCols);

        GradMag = sqrt(XData .^ 2 + YData .^2);
        GradAng = atan2(YData, XData) * (180/pi);

        GradMin = matmin(GradMag);
        GradMax = matmax(GradMag);
        fZ1Min = matmin(Z1Data);
        fZ1Max = matmax(Z1Data);
        fZ2Min = matmin(Z2Data);
        fZ2Max = matmax(Z2Data);

        if ~flgFixColor,
            set(hGradMag, 'CLim', [GradMin GradMax]);
            set(hFZ1, 'clim', [fZ1Min fZ1Max]);
            set(hFZ2, 'clim', [fZ2Min fZ2Max]);

            set(gcf, 'CurrentAxes', hGradMagCB);
            cla;
            set(hGradMagCB, 'CLim', [GradMin GradMax]);
            colorbar(hGradMagCB);
            
            set(gcf, 'CurrentAxes', hFZ1CB);
            cla;
            set(hFZ1CB, 'CLim', [fZ1Min fZ1Max]);
            colorbar(hFZ1CB);
            
            set(gcf, 'CurrentAxes', hFZ2CB);
            cla;
            set(hFZ2CB, 'CLim', [fZ2Min fZ2Max]);
            colorbar(hFZ2CB);
        end

        set(hGradSurf, 'CData', GradMag);
        set(hZ1Surf, 'CData', Z1Data);
        set(hZ2Surf, 'CData', Z2Data);
        set(hTime, 'XData', [idxSample idxSample]);

        set(gcf, 'CurrentAxes', hSpatAng);        
        delete(hSpatQuiv);
        hold on
        hSpatQuiv = quiver(XData, YData);
        hold off

        set(gcf, 'CurrentAxes', hTempAng1);
        delete(hTempQuiv1);
        hold on
        hTempQuiv1 = quiver(GradMag, -1*Z1Data);
        hold off

        set(gcf, 'CurrentAxes', hTempAng2);
        delete(hTempQuiv2);
        hold on
        hTempQuiv2 = quiver(GradMag, -1*Z2Data);
        hold off
        drawnow;

        flgRedraw = 0;
    end

    %%
    %%  Options menu
    %%
    clc;
    fprintf('Current sample index\t%d\n', idxSample);
    fprintf('\n\n');
    fprintf('F\tforward one step\n');
    fprintf('B\tbackward one step\n');
    fprintf('I\tAdjust sample step size\n\n');
    fprintf('J\tJump to a different sample index \n');
    fprintf('P\tPlay a movie\n');
    fprintf('R\tRecord a movie\n');
    fprintf('Z\tmodify color axis view\n');
    fprintf('Q\tQuit routine\n');
    
    KeyIn = input('Next command : ', 's');

    if KeyIn == ''
        KeyIn = prevKey;
    end

    %%
    %%  Decrement the sample index and redraw
    %%
    if KeyIn == 'b'
        idxSample = idxSample - incrSample;
        flgRedraw = 1;
    end

    %%
    %%  Increment the sample index and cause a redraw
    %%
    if KeyIn == 'f'
        idxSample = idxSample + incrSample;
        flgRedraw = 1;
    end

    %%
    %%  Change the sample index increment value
    %%
    if KeyIn == 'i'
        incrSample = input('Enter a new sample increment value: ');
    end

    %%
    %%  Change the sample index increment value
    %%
    if KeyIn == 'j'
        idxSample = input('Enter a new sample index: ');
        flgRedraw = 1;
    end

    if KeyIn == 'q',
        flgQuit = 1;
    end
    prevKey = KeyIn;
end