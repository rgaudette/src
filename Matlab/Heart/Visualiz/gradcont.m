%GRADCONT       Multiple contour display of the 3D gradient of a 3D sequence.
%
%   gradcont(fX, fY, fZ, fZ2, F, szArray)
%
%   fX          X dimension partial derivative estimate.
%
%   fY          Y dimension partial derivative estimate.
%
%   fZ          Z dimension  partial derivative estimate.
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
%  $Date: 2004/01/03 08:24:48 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: gradcont.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:48  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/23 00:08:42  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function gradcont(fX, fY, fZ, fZ2, F, szArray)
%%
%%  Extract number of array elements and number of time samples present in 
%%  data.  Each time instant should be represented by column index, array 
%%  element by row index.  Also extract data maxima and minima.
%%
[nElems nSamples] = size(fX);

%%
%%    Assume image is square
%%
nRows = szArray(1);
nCols = szArray(2);

%%
%%  Initial parameters
%%
idxSample = 300;
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
m1 = matmin(fX); m2 = matmin(fY); m3 = matmin(fZ);
zMin = min([m1 m2 m3]);
m1 = matmax(fX); m2 = matmax(fY); m3 = matmax(fZ);
zMax = max([m1 m2 m3]);

%%
%%  Extract spatial arrays from functions, and compute polar coordinates
%%
XData = reshape(fX(:, idxSample), nRows, nCols);
YData = reshape(fY(:, idxSample), nRows, nCols);
ZData = reshape(fZ(:, idxSample), nRows, nCols);
Z2Data = reshape(fZ2(:, idxSample), nRows, nCols);
SpatMag = sqrt(XData .^ 2 + YData .^2);
SpatAng = atan2(YData, XData) * (180/pi);
TempAng = atan2(ZData, SpatMag) * (180/pi);
Temp2Ang = atan2(Z2Data, SpatMag) * (180/pi);

%%
%%  Create axis for cartesian and polar representations.
%%
clf
colormap(vibgyor(128))

set(gcf, 'Units', 'Normalized');
set(gcf, 'BackingStore', 'off');

AspectRatio = 6/5;
AxesWidth = 0.24;
AxesHeight = AxesWidth * AspectRatio;
YTopRow = 0.43;
YBotRow = 0.06;
XLeftCol = 0.05;
XSpace = 0.06;
CBWidth = 0.03;

GradMin = matmin(SpatMag);
GradMax = matmax(SpatMag);

hMag = axes('Position', [XLeftCol YTopRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
hSpatSurf = contour(SpatMag, [0:1:11]);
grid
set(hMag, 'YDir', 'Reverse');
title('Spatial Gradient Magnitude')
axis('square')
drawnow

hFY = axes('Position', ...
    [XLeftCol+AxesWidth+XSpace YTopRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
hYSurf = contour(ZData, [-10:1:10]);
grid
set(hFY, 'YDir', 'Reverse');
title('Scale 2 Gradient')
axis('square')
drawnow

hFZ = axes('Position', ...
    [XLeftCol+2*AxesWidth+2*XSpace YTopRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
hZSurf = contour(Z2Data, [-10:1:10]);
grid
set(hFZ, 'YDir', 'Reverse');
title('Scale 4 Gradient')
axis('square')
drawnow

hSpatAng = axes('Position', ...
 [XLeftCol YBotRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hSpatAng, 'DrawMode', 'Fast');
set(hSpatAng, 'YDir', 'Reverse');
%hSpatSurf = surface(SpatAng);
hold on
hSpatQuiv = quiver(XData, -1*YData);
hold off
axis('square');
title('Spatial Angle')
drawnow

hTempAng1 = axes('Position', ...
 [XLeftCol+AxesWidth+XSpace YBotRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hTempAng1, 'DrawMode', 'Fast');
set(hTempAng1, 'YTickLabels', '');
set(hTempAng1, 'YDir', 'Reverse');
hold on
hTempQuiv1 = quiver(SpatMag, -1*ZData);
hold off
axis('square');
title('Scale 2 Angle')
drawnow

hTempAng2 = axes('Position', ...
    [XLeftCol+2*AxesWidth+2*XSpace YBotRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hTempAng2, 'DrawMode', 'Fast');
set(hTempAng2, 'YTickLabels', '');
set(hTempAng2, 'YDir', 'Reverse');
%hTempSurf = surface(TempAng);
hold on
hTempQuiv2 = quiver(SpatMag, -1*Z2Data);
hold off
axis('square');
title('Scale 4 Angle')
drawnow


%%
%%  Draw single lead plot at top
%%

hLeadAx = axes('position', [0.25 0.82 0.5 0.15]);
[nLeads nSamps] = size(F)
plot(F(idxLead,:));
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
        st = clock;
        
        XData = reshape(fX(:, idxSample), nRows, nCols);
        YData = reshape(fY(:, idxSample), nRows, nCols);
        ZData = reshape(fZ(:, idxSample), nRows, nCols);
        Z2Data = reshape(fZ2(:, idxSample), nRows, nCols);

        SpatMag = sqrt(XData .^ 2 + YData .^2);
        SpatAng = atan2(YData, XData) * (180/pi);

        GradMin = matmin(SpatMag);
        GradMax = matmax(SpatMag);
        TempMin = matmin([ZData Z2Data]);
        TempMax = matmax([ZData Z2Data]);

        set(gcf, 'CurrentAxes',  hMag);
        axis([xMin xMax yMin yMax]);
        hSpatSurf = contour(SpatMag, [0:1:10]);
        set(hMag, 'YDir', 'Reverse');
        grid
        axis('square')
        title('Spatial Gradient Magnitude')
        drawnow

        set(gcf, 'CurrentAxes',  hFY);
        axis([xMin xMax yMin yMax]);
        hYSurf = contour(ZData,[-10:1:10]);
        grid
        set(hFY, 'YDir', 'Reverse');
        title('Scale 2 Gradient')
        axis('square')
        drawnow

        set(gcf, 'CurrentAxes',  hFZ);
        axis([xMin xMax yMin yMax]);
        hZSurf = contour(Z2Data, [-10:1:10]);
        grid
        set(hFZ, 'YDir', 'Reverse');
        title('Scale 4 Gradient')
        axis('square')
        drawnow

        
        set(hTime, 'XData', [idxSample idxSample]);

        set(gcf, 'CurrentAxes', hSpatAng);        
        delete(hSpatQuiv);
        hold on
        hSpatQuiv = quiver(XData, -1*YData);
        hold off

        set(gcf, 'CurrentAxes', hTempAng1);
        delete(hTempQuiv1);
        hold on
        hTempQuiv1 = quiver(SpatMag, -1*ZData);
        hold off

        set(gcf, 'CurrentAxes', hTempAng2);
        delete(hTempQuiv2);
        hold on
        hTempQuiv2 = quiver(SpatMag, -1*Z2Data);
        hold off
        drawnow;
        etime(clock, st)
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