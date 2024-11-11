%SCALECMP       Compare the responses of 2 scales
%
%   scalecmp(scale1, scale1, szArray, Data);
%
%   szArray     The size of data array for each instance of Z.
%
%   Calls: arrows2.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:52 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: scalecmp.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:52  rickg
%  Matlab Source
%
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hArrwScale2 = scalecmp(scale1, scale2, szArray, Data)

%%
%%  Extract number of array elements and number of time samples present in 
%%  data.  Each time instant should be represented by column index, array 
%%  element by row index.  Also extract data maxima and minima.
%%
[nElems nSamples] = size(scale1);

nRows = szArray(1);
nCols = szArray(2);

%%
%%  Initial parameters
%%
idxSample = 80;
idxElem = 136;
incrSample = 1;
flgCFixScale1 = 0;
flgCFixScale2 = 0;
if nargin > 3,
    IDScale1Source = 3;
else
    IDScale1Source = 1;
end

%%
%%  Find the extrema for all functions
%%
xMin = 1;
xMax = nCols;
yMin = 1;
yMax = nRows;
minScale1 = matmin(scale1);
maxScale1 = matmax(scale1);
minScale2 = matmin(scale2);
maxScale2 = matmax(scale2);

%%
%%  Axes layout
%%
xScale1Start = 0.05;
xScale1Width = 0.35;
xScale2Start = 0.45;
xScale2Width = xScale1Width;
yPlotStart = 0.1;
yPlotWidth = 0.8;

xCBStart = 0.85
xCBWidth = 0.07;
yCBWidth = 0.8;


%%
%%  Create figure for scale1 and scale2 surfaces.
%%
hDerivFig = figure(1);
clf reset
%set(hDerivFig, 'Position', [4 1024-700-4 875 700]);
set(hDerivFig, 'Units', 'Normalized');
set(hDerivFig, 'MenuBar', 'none');
orient landscape
colormap(bgyor(128))
set(hDerivFig, 'BackingStore', 'off');

%%
%%  Scale1 axes initialization
%%
hAxScale1 = axes('Position', [xScale1Start yPlotStart xScale1Width yPlotWidth]);
thisScale1 = reshape(scale1(:, idxSample), nRows, nCols);
hSurfScale1 = surf(thisScale1);
set(hAxScale1, 'YDir', 'Reverse');
set(hAxScale1, 'View', [0 90]);
set(hAxScale1, 'DrawMode', 'Fast');
set(hAxScale1, 'CLim', [minScale1 maxScale1]);
%set(hSurfScale1, 'FaceColor', 'Interp');
%set(hSurfScale1, 'EraseMode', 'normal')
axis([1 nCols 1 nRows]);
title('Scale 1')


%%
%%  Scale1 axis colorbar
%%
hAxCBScale1 = axes('Position', [xCBStart yPlotStart xCBWidth yCBWidth]);
set(hAxCBScale1, 'CLim', [minScale1 maxScale1]);
hCBScale1 = colorbar(hAxCBScale1);
set(gcf, 'NextPlot', 'Add');

%%
%%  scale2 axis initialization
%%
hAxScale2 = axes('Position', [xScale2Start yPlotStart xScale2Width yPlotWidth]);
thisScale2 = reshape(scale2(:, idxSample), nRows, nCols);
hSurfScale2 = surf(thisScale2);
set(hAxScale2, 'YDir', 'Reverse');
set(hAxScale2, 'View', [0 90]);
set(hAxScale2, 'DrawMode', 'Fast');
set(hAxScale2, 'CLim', [minScale2 maxScale2]);
axis([1 nCols 1 nRows]);
title('Scale 2')

%%
%%  Spatial scale2 axis colorbar
%%
%hAxCBScale2 = axes('Position', [xScale2Start yCBStart xScale2Width yCBWidth]);
%set(hAxCBScale2, 'CLim', [minScale2 maxScale2]);
%hCBScale2 = colorbar(hAxCBScale2);
%set(gcf, 'NextPlot', 'Add');

%%
%%  Single lead plot
%%
hScale1Fig = figure(2);
clf

if IDScale1Source == 3,
    hScale1Data = plot(Data(idxElem, :), 'g');
    minLead = matmin(Data);
    maxLead = matmax(Data);
elseif IDScale1Source == 1,
    hScale1Data = plot(scale1(idxElem, :), 'g');
    minLead = matmin(scale1);
    maxLead = matmax(scale1);
end
hold on
axis([1 nSamples minLead maxLead]);
xlabel('Sample Index')
ylabel('Amplitude');
grid
hScale1Pointer = plot([idxSample idxSample], [minLead maxLead], 'r');
hold off
figure(1)

flgQuit = 0; flgRedraw = 0;
while flgQuit == 0,
    if flgRedraw,

        %%
        %%  Redraw the scale1 image
        %%
        thisScale1 = reshape(scale1(:, idxSample), nRows, nCols);
        set(hSurfScale1, 'ZData', thisScale1);
        set(hSurfScale1, 'CData', thisScale1);

        if ~flgCFixScale1,
            maxScale1 = matmax(thisScale1);
            minScale1 = matmin(thisScale1);
            set(hAxScale1, 'CLim', [minScale1 maxScale1]);
            delete(hAxCBScale1);
            hAxCBScale1 = axes('Position', [xCBStart yPlotStart xCBWidth yCBWidth]);
            set(hAxCBScale1, 'CLim', [minScale1 maxScale1]);
            hCBScale1 = colorbar(hAxCBScale1);

        end

        %%
        %%  Redraw the spatial scale2ient
        %%
        thisScale2 = reshape(scale2(:, idxSample), nRows, nCols);
        set(hSurfScale2, 'ZData', thisScale2);
        set(hSurfScale2, 'CData', thisScale2);


%        if ~flgCFixScale2
%            maxScale2 = matmax(thisScale2);
%            minScale2 = matmin(thisScale2);
%            set(hAxScale2, 'CLim', [minScale2 maxScale2]);
%            delete(hAxCBScale2);
%            hAxCBScale2 = axes('Position', ...
%                [xScale2Start yCBStart xScale2Width yCBWidth]);
%            set(hAxCBScale2, 'CLim', [minScale2 maxScale2]);
%            hCBScale2 = colorbar(hAxCBScale1);
%
%        end

        %%
        %%  update the pointer in the scale1oral figure
        %%
        figure(2)
        set(hScale1Pointer, 'XData', [idxSample idxSample]);

        figure(1)
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
    fprintf('R\tRecord a movie\n');
    fprintf('P\tPlay a movie\n');
    fprintf('T\tscale1oral color range\n');
    fprintf('G\tSpatial scale2ient color range\n');
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
    %%  Change the sample index increment value
    %%
    if KeyIn == 'k'
        idxSample = input('Enter a new sample index: ');
        flgRedraw = 1;
    end

    %%
    %%  Select an element for the 2d plot
    %%
    if KeyIn == 's',
        newElem = input( ...
        'Enter the row & column indces for the lead as a vector: ');
        if newElem(1) < 1 | newElem(1) > nRows,
            disp('Row index out of range, hit any key to continue');
            pause
        elseif newElem(2) < 1 | newElem(2) > nCols,
            disp('Column index out of range, hit any key to continue');
            pause
        else
            idxElem = newElem(1) + (newElem(2) - 1) * nRows;

            %%
            %%  Redraw element time plot in figure(2) and move marker
            %%
            figure(2)
            if IDScale1Source == 1,
                set(hScale1Data, 'YData', scale1(idxElem,:));
            elseif IDScale1Source == 2,
                set(hScale1Data, 'YData', scale2(idxElem,:));
            else
                set(hScale1Data, 'YData', Data(idxElem,:));    
            end
            set(hScale1Pointer, 'XData', [idxSample idxSample]);
            title(['Array Element : ' int2str(idxElem)]);

            figure(1)
        end
    end

    %%
    %%  Adjust the scale1oral color range
    %%
    if KeyIn == 't'
        vecIn = input( ...
            'Enter the min and max color ranges [CMin Cmax] or 0 for auto: ');
        if length(vecIn) > 1
            set(hAxScale1, 'Clim', vecIn);
            delete(hAxCBScale1);
            hAxCBScale1 = axes('Position', [xCBStart yPlotStart xCBWidth yCBWidth]);
            set(hAxCBScale1, 'CLim', [vecIn(1) vecIn(2)]);
            hCBScale1 = colorbar(hAxCBScale1);

            flgCFixScale1 = 1;
        else
            flgCFixScale1 = 0;
        end
    end

    %%
    %%  Adjust the scale1 color range
    %%
    if KeyIn == 'g'
        vecIn = input( ...
            'Enter the min and max color ranges [CMin Cmax] or 0 for auto: ');
        if length(vecIn) > 1
            set(hAxScale2, 'Clim', vecIn);
%            delete(hAxCBScale2);
%            hAxCBScale2 = axes('Position', ...
%                [xScale2Start yCBStart xScale2Width yCBWidth]);
%            set(hAxCBScale2, 'CLim', vecIn);
%            hCBScale2 = colorbar(hAxCBScale2);
%            flgCFixScale2 = 1;
        else
            flgCFixScale2 = 0;
        end
    end

    if KeyIn == 'q',
        flgQuit = 1;
    end

    prevKey = KeyIn;
end