%GRADCMP3       Compare the gradient and temporal derivative of a 3D seqeunce.
%
%   grdcmp3(df_dt, grad, szArray, Data);
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
%  $Date: 2004/01/03 08:24:47 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: gradcmp3.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:47  rickg
%  Matlab Source
%
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hArrwGrad = grdcmp3(df_dt, grad, szArray, Data)

%%
%%  Extract number of array elements and number of time samples present in 
%%  data.  Each time instant should be represented by column index, array 
%%  element by row index.  Also extract data maxima and minima.
%%
[nElems nSamples] = size(df_dt);

nRows = szArray(1);
nCols = szArray(2);

%%
%%  Initial parameters
%%
idxSample = 80;
idxElem = 136;
incrSample = 1;
flgCFixTemp = 0;
flgCFixGrad = 0;
if nargin > 3,
    IDTempSource = 3;
else
    IDTempSource = 1;
end

%%
%%  Find the extrema for all functions
%%
xMin = 1;
xMax = nCols;
yMin = 1;
yMax = nRows;
maxDfDt = matmax(df_dt);
minDfDt = matmin(df_dt);
maxGrad = matmax(abs(grad));

%%
%%  Axes layout
%%
xTempStart = 0.05;
xTempWidth = 0.42;
xGradStart = 0.54;
xGradWidth = xTempWidth;
yPlotStart = 0.22;
yPlotWidth = 0.7;
yCBStart = 0.05;
yCBWidth = 0.1;


%%
%%  Create figure for temporal derivative and gradient.
%%
hDerivFig = figure(1);
clf reset
set(hDerivFig, 'Position', [4 1024-700-4 875 700]);
set(hDerivFig, 'Units', 'Normalized');
set(hDerivFig, 'MenuBar', 'none');
orient landscape
colormap(vibgyor(128))
set(hDerivFig, 'BackingStore', 'off');

%%
%%  Temporal derivative axes initialization
%%
hAxTemp = axes('Position', [xTempStart yPlotStart xTempWidth yPlotWidth]);
thisDfDt = reshape(df_dt(:, idxSample), nRows, nCols);
hSurfTemp = surf(thisDfDt);
set(hAxTemp, 'YDir', 'Reverse');
set(hAxTemp, 'View', [0 90]);
set(hAxTemp, 'DrawMode', 'Fast');
set(hAxTemp, 'CLim', [minDfDt maxDfDt]);
%set(hSurfTemp, 'FaceColor', 'Interp');
set(hSurfTemp, 'EraseMode', 'normal')
axis([1 nCols 1 nRows]);
title('Temporal Derivative')

%%
%%  Temporal axis colorbar
%%
hAxCBTemp = axes('Position', [xTempStart yCBStart xTempWidth yCBWidth]);
set(hAxCBTemp, 'CLim', [minDfDt maxDfDt]);
hCBTemp = colorbar(hAxCBTemp);


%%
%%  Spatial gradient axis initialization
%%
hAxGrad = axes('Position', [xGradStart yPlotStart xGradWidth yPlotWidth]);
thisGrad = reshape(grad(:, idxSample), nRows, nCols);
hArrwGrad = arrows2(thisGrad);
set(hAxGrad, 'YDir', 'Reverse');
set(hArrwGrad, 'EdgeColor', 'none');
axis([1 nCols 1 nRows]);
title('Spatial Gradient')

%%
%%  Spatial gradient axis colorbar
%%
hAxCBGrad = axes('Position', [xGradStart yCBStart xGradWidth yCBWidth]);
set(hAxCBGrad, 'CLim', [0 maxGrad]);
hCBGrad = colorbar(hAxCBGrad);

%%
%%  Single lead plot
%%
hTempFig = figure(2);
clf
set(hTempFig, 'Position', [4 40 875 250]);

if IDTempSource == 3,
    hTempData = plot(Data(idxElem, :), 'g');
    minLead = matmin(Data);
    maxLead = matmax(Data);
elseif IDTempSource == 1,
    hTempData = plot(df_dt(idxElem, :), 'g');
    minLead = matmin(df_dt);
    maxLead = matmax(df_dt);
end
hold on
axis([1 nSamples minLead maxLead]);
xlabel('Sample Index')
ylabel('Amplitude');
grid
hTempPointer = plot([idxSample idxSample], [minLead maxLead], 'r');
hold off
figure(1)

flgQuit = 0; flgRedraw = 0;
while flgQuit == 0,
    if flgRedraw,

        %%
        %%  Redraw the temporal derivative
        %%
        thisDfDt = reshape(df_dt(:, idxSample), nRows, nCols);
        set(hSurfTemp, 'ZData', thisDfDt);
        set(hSurfTemp, 'CData', thisDfDt);

        if ~flgCFixTemp,
            maxDfDt = matmax(thisDfDt);
            minDfDt = matmin(thisDfDt);
            set(hAxTemp, 'CLim', [minDfDt maxDfDt]);
            delete(hAxCBTemp);
            hAxCBTemp = axes('Position', ...
                [xTempStart yCBStart xTempWidth yCBWidth]);
            set(hAxCBTemp, 'CLim', [minDfDt maxDfDt]);
            hCBTemp = colorbar(hAxCBTemp);
        end

        %%
        %%  Redraw the spatial gradient
        %%
        delete(hArrwGrad);
        set(hDerivFig, 'CurrentAxes ', hAxGrad);   
        thisGrad = reshape(grad(:, idxSample), nRows, nCols);
        hArrwGrad = arrows2(thisGrad);
        set(hArrwGrad, 'EdgeColor', 'none');


        if ~flgCFixGrad
            delete(hAxCBGrad);
            hAxCBGrad = axes('Position', ...
                [xGradStart yCBStart xGradWidth yCBWidth]);
            set(hAxCBGrad, 'CLim', [0 matmax(abs(thisGrad))]);
            hCBGrad = colorbar(hAxCBGrad);
        end

        %%
        %%  update the pointer in the temporal figure
        %%
        figure(2)
        set(hTempPointer, 'XData', [idxSample idxSample]);

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
    fprintf('T\ttemporal color range\n');
    fprintf('G\tSpatial gradient color range\n');
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
            if IDTempSource == 1,
                set(hTempData, 'YData', df_dt(idxElem,:));
            elseif IDTempSource == 2,
                set(hTempData, 'YData', grad(idxElem,:));
            else
                set(hTempData, 'YData', Data(idxElem,:));    
            end
            set(hTempPointer, 'XData', [idxSample idxSample]);
            title(['Array Element : ' int2str(idxElem)]);

            figure(1)
        end
    end

    %%
    %%  Adjust the temporal color range
    %%
    if KeyIn == 't'
        vecIn = input( ...
            'Enter the min and max color ranges [CMin Cmax] or 0 for auto: ');
        if length(vecIn) > 1
            set(hAxTemp, 'Clim', vecIn);
            delete(hAxCBTemp);
            hAxCBTemp = axes('Position', ...
                [xTempStart yCBStart xTempWidth yCBWidth]);
            set(hAxCBTemp, 'CLim', vecIn);
            hCBTemp = colorbar(hAxCBTemp);
            
            flgCFixTemp = 1;
        else
            flgCFixTemp = 0;
        end
    end

    %%
    %%  Adjust the temporal color range
    %%
    if KeyIn == 'g'
        vecIn = input( ...
            'Enter the min and max color ranges [CMin Cmax] or 0 for auto: ');
        if length(vecIn) > 1
            set(hAxGrad, 'Clim', vecIn);
            delete(hAxCBGrad);
            hAxCBGrad = axes('Position', ...
                [xGradStart yCBStart xGradWidth yCBWidth]);
            set(hAxCBGrad, 'CLim', vecIn);
            hCBGrad = colorbar(hAxCBGrad);
            flgCFixGrad = 1;
        else
            flgCFixGrad = 0;
        end
    end

    if KeyIn == 'q',
        flgQuit = 1;
    end

    prevKey = KeyIn;
end