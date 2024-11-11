%GRDVIEW1       Display multiple views of the 3D gradient of a 3D sequence.
%
%   gradview(fX, fY, fZ, F, szArray)
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
%  $Log: grdview1.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:48  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/23 00:09:18  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function grdview1(fX, fY, fZ, F, szArray)

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
idxSample = 100;
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
Mag = sqrt(XData .^ 2 + YData .^ 2 + ZData .^ 2);
SpatAng = atan2(YData, XData) * (180/pi);
TempAng = atan2(ZData, sqrt(XData .^ 2 + YData .^ 2)) * (180/pi);

%%
%%  Create axis for cartesian and polar representations.
%%
clf
if strcmp(computer, 'PCWIN')
    colormap(vibgyor(128))
else
    colormap(vibgyor(256))
end
set(gcf, 'Units', 'Normalized');
set(gcf, 'BackingStore', 'off');

AspectRatio = 6/5;
AxesWidth = 0.25;
AxesHeight = AxesWidth * AspectRatio;
YTopRow = 0.43;
YBotRow = 0.06;
XLeftCol = 0.05;
XSpace = 0.02;

hFX = axes('Position', [XLeftCol YTopRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hFX, 'DrawMode', 'Fast');
set(hFX, 'YDir', 'Reverse');
set(hFX, 'clim', [zMin zMax]);
set(hFX, 'View', [0 90]);
hXSurf = surface(XData);
set(hXSurf, 'EraseMode', 'none')
title('X Gradient')
drawnow

hFY = axes('Position', ...
    [XLeftCol+AxesWidth+XSpace YTopRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hFY, 'DrawMode', 'Fast');
set(hFY, 'YTickLabels', '');
set(hFY, 'YDir', 'Reverse');
set(hFY, 'clim', [zMin zMax]);
hYSurf = surface(YData);
set(hYSurf, 'EraseMode', 'none')
title('Y Gradient')
drawnow

hFZ = axes('Position', ...
    [XLeftCol+2*(AxesWidth+XSpace) YTopRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hFY, 'DrawMode', 'Fast');
set(hFZ, 'YTickLabels', '');
set(hFZ, 'YDir', 'Reverse');
set(hFZ, 'clim', [zMin zMax]);
hZSurf = surface(ZData);
set(hZSurf, 'EraseMode', 'none');
title('Temporal Gradient');
drawnow

CBWidth = 0.03;
hCartCB = axes('Position', ...
    [XLeftCol+3*(AxesWidth+XSpace) YTopRow CBWidth AxesHeight]);
set(hCartCB, 'clim', [zMin zMax]);
colorbar(hCartCB);
drawnow

GradMin = matmin(Mag);
GradMax = matmax(Mag);
hMag = axes('Position', [XLeftCol YBotRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hMag, 'DrawMode', 'Fast');
set(hMag, 'YDir', 'Reverse');
set(hMag, 'CLim', [GradMin GradMax]);
hMagSurf = surface(Mag);
set(hMagSurf, 'EraseMode', 'none');
title('Gradient Magnitude')
drawnow

hMagCB = axes('Position', ...
    [XLeftCol+AxesWidth+XSpace YBotRow CBWidth AxesHeight]);
set(hMagCB, 'CLim', [GradMin GradMax]);    
colorbar(hMagCB);

hSpatAng = axes('Position', ...
    [XLeftCol+AxesWidth+CBWidth+4*XSpace YBotRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hSpatAng, 'DrawMode', 'Fast');
set(hSpatAng, 'YTickLabels', '');
set(hSpatAng, 'YDir', 'Reverse');
%hSpatSurf = surface(SpatAng);
hold on
hSpatQuiv = quiver(XData, YData);
hold off
title('Spatial Angle')
drawnow

hTempAng = axes('Position', ...
    [XLeftCol+2*AxesWidth+5*XSpace+CBWidth YBotRow AxesWidth AxesHeight]);
axis([xMin xMax yMin yMax]);
set(hTempAng, 'DrawMode', 'Fast');
set(hTempAng, 'YTickLabels', '');
set(hTempAng, 'YDir', 'Reverse');
%hTempSurf = surface(TempAng);
hold on
hTempQuiv = quiver(sqrt(XData .^ 2 + YData .^ 2), -1*ZData);
hold off
title('Temporal Angle')
drawnow

%hAngCB = axes('Position', ...
%    [XLeftCol+3*AxesWidth+5*XSpace+CBWidth YBotRow CBWidth AxesHeight]);
%set(hAngCB, 'CLim', [-180 180]);
%colorbar(hAngCB);
%drawnow

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
        Mag = sqrt(XData .^ 2 + YData .^ 2 + ZData .^ 2);
        GradMin = matmin(Mag);
        GradMax = matmax(Mag);
%        SpatAng = atan2(YData, XData) * (180/pi);
%        TempAng = atan2(ZData, sqrt(XData .^ 2 + YData .^ 2)) * (180/pi);

        if ~flgFixColor,
            CurrZMin = matmin([XData; YData; ZData]);
            CurrZMax = matmax([XData; YData; ZData]);
            
            set(hFX, 'CLim', [CurrZMin CurrZMax]);
            set(hFY, 'CLim', [CurrZMin CurrZMax]);
            set(hFZ, 'CLim', [CurrZMin CurrZMax]);
            set(hMag, 'CLim', [GradMin GradMax]);
            
            set(gcf, 'CurrentAxes', hCartCB);
            cla;
            set(hCartCB, 'CLim', [CurrZMin CurrZMax]);
            colorbar(hCartCB);

            set(gcf, 'CurrentAxes', hMagCB);
            cla;
            set(hMagCB, 'CLim', [GradMin GradMax]);
            colorbar(hMagCB);
        end

        set(hXSurf, 'CData', XData);
        set(hYSurf, 'CData', YData);
        set(hZSurf, 'CData', ZData);
        set(hMagSurf, 'CData', Mag);
        set(hTime, 'XData', [idxSample idxSample]);
%        set(hSpatSurf, 'CData', SpatAng);
%        set(hTempSurf, 'CData', TempAng);
        set(gcf, 'CurrentAxes', hSpatAng);
        delete(hSpatQuiv);
        hold on
        hSpatQuiv = quiver(XData, YData);
        hold off

        set(gcf, 'CurrentAxes', hTempAng);
        delete(hTempQuiv);
        hold on
        hTempQuiv = quiver(sqrt(XData .^ 2 + YData .^ 2), -1*ZData);
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