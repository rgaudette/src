%I3DCONT        Interactive 3D contour tool
%
%
%   TODO:   Fix element selection routine
%           replace flipud with reversed y dir
%           Add movie capabilities
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:49 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: i3dcont.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:49  rickg
%  Matlab Source
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h3dData = i3dcont(Data, szData)

%%
%%  Extract number of array elements and number of time samples present in data.
%%  Each time instant should be represented by column index, array element by
%%  row index.  Also extract data maxima and minima.
%%
[nElems nSamples] = size(Data);
nRows = szData(1);
nCols = szData(2);

%%
%%  Define range of data
%%
xMin = 1;
xMax = nCols;
yMin = 1;
yMax = nRows;
zMax = matmax(Data);
zMin = matmin(Data);

%%
%%  Initial parameter values
%%
idxSample = 130;
incrSample = 1;
idxElem = 1;
flgFixZAxis = 1;
flgQuit = 0;

%%
%%  Setup inital figures
%%
figure(1)
clf
h3dFig = gcf;
set(h3dFig, 'Position', [4 340 600 400]);
set(h3dFig, 'BackingStore', 'off');


figure(2)
clf
h2dFig = gcf;
set(h2dFig, 'Position', [4 4 600 275]);
%set(h2dFig, 'BackingStore', 'off');

%%
%%  Initial single element plot
%%
h2dData = plot(Data(idxElem,:), 'g');
set(h2dData, 'EraseMode', 'normal')
grid
hold on
axis([1 nSamples zMin zMax]);
h2dPointer = plot([idxSample idxSample], [zMin zMax], 'r');
set(h2dPointer, 'EraseMode', 'xor')
xlabel('Sample Index')
ylabel('Amplitude (mV)')
title(['Array Element : ' int2str(idxElem)]);

%%
%%  Initial array plot
%%
%%  Setting erase mode:
%%  On the PC:
%%      Normal -    Appears to work the best
%%      Background - Does not redraw axis but it does draw the surface twice
%%                  This makes it slower than 'normal'
%%      XOR -       This also performs several redraws, does present a faceted
%%                  view, and the colormaping is distortedd due to the XOR
%%                  operation.
%%      None -      Does not remove previous surface.
figure(1)
Array = flipud(reshape(Data(:, idxSample), nRows, nCols));
contour(Array, [-50:2:50]);
xlabel('South')
ylabel('West')
zlabel('Amplitude (mV)')
grid
%%
%%  Marker for array element displayed in 2d plot
%%
hold on
idxXElem = rem(idxElem, nRows);
idxYElem = ceil(idxElem / nRows);
h3dPoint = plot(idxXElem, idxYElem, 'w+');
set(h3dPoint, 'LineWidth', 3);
set(h3dPoint, 'EraseMode', 'normal')
hold off
drawnow

flgRedraw = 0;
while flgQuit == 0,
    if flgRedraw,

        %%
        %%  Redraw the 2d graph
        %%
        figure(2)
        set(h2dPointer, 'XData', [idxSample idxSample]);

        %%
        %%  Redraw the 3d graph
        %%
        figure(1)
        Array = flipud(reshape(Data(:, idxSample), nRows, nCols));
        contour(Array, [-0:0.5:20]);
        xlabel('South')
        ylabel('West')
        zlabel('Amplitude (mV)')
        grid
        
        %%
        %%  Check to see if z-axis is fixed
        %%
        if ~flgFixZAxis,
            axis([xMin xMax yMin yMax matmin(Array) matmax(Array)])
        end
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
    fprintf('J\tJump to a selected sample index using mouse in 2D view\n');
    fprintf('S\tSelect a new array element using mouse in 3D view\n');
    fprintf('Z\tmodify z axis in 3D view\n');
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
    %%  Select a sample index to view from the 2d plot
    %%
    if KeyIn == 'j',
        figure(2);
        [xval yval] = ginput(1);
        xval = round(xval);
        if xval > 1 & xval < nSamples,
            idxSample = xval;
            flgRedraw = 1;
        end
        figure(1)
    end

    %%
    %%  Select an element for the 2d plot
    %%
    if KeyIn == 's',
        newElem = input( ...
        'Enter a new X & Y (South & West) element pair as a vector:');
        if newElem(1) < 1 | newElem(1) > nRows,
            disp('X element out of range, hit any key to continue');
            pause
        end
        if newElem(2) < 1 | newElem(2) > nCols,
            disp('Y element out of range, hit any key to continue');
            pause
        end
        idxElem = newElem(2) + (newElem(1) - 1) * nCols;

        %%
        %%  Redraw element time plot in figure(2) and move marker
        %%
        figure(2)
        set(h2dData, 'YData', Data(idxElem,:));

        figure(1)
        set(h3dPoint, 'XData', newElem(1));
        set(h3dPoint, 'YData', newElem(2));
        set(h3dPoint, 'ZData', Array(idxElem));
    end

    %%
    %%  Z Axis control
    %%
    if KeyIn == 'z',
        figure(1)
        vecin = input(...
            'Enter a 2 element vector [zMin zMax] or 0 for default: ');
        if length(vecin) < 2,
            flgFixZAxis = 0;
            axis([1 nCols 1 nRows zMin zMax]);
        else
            flgFixZAxis = 1;
            axis([1 nCols 1 nRows vecin(1) vecin(2)])
            zMin = vecin(1);
            zMin = vecin(2);
        end
    end
            
    if KeyIn == 'q',
        flgQuit = 1;
    end
    prevKey = KeyIn;
end