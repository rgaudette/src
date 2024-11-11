%I3DMESH        Interactive 3D mesh plotting tool
%
%  [Movie idxMStart nMStep flgFixColor] = i3dmesh(Data, szData, Data1, Data2)
%
%   Movie       The last movie computed.
%
%   idxMStart   The temporal index of the first image used for the movie.
%
%   nMStep      The number of temporal samples between each frome of the movie.
%
%   Data        The complex data to be plotted (nElems x nSamples).
%
%   szData      The number of rows & columns packed into the Data array.
%               [nRows nCols]
%
%
%  Calls: none.
%
%  Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:51 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: i3dmesh.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:51  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/18 19:31:24  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Movie, idxMStart, nMStep] = i3dmesh(Data, szData, Data1, Data2)

%%
%%  Extract number of array elements and number of time samples present in data.
%%  Each time instant should be represented by column index, array element by
%%  row index.  Also extract data maxima and minima.
%%
[nElems nSamples] = size(Data);
nRows = szData(1);
nCols = szData(2);

dataMin = matmin(Data);
dataMax = matmax(Data);

prevKey = 'f';

xMin = 1;
xMax = nCols;
yMin = 1;
yMax = nRows;
zMax = dataMax;
zMin = dataMin;

%%
%%  Initial parameter values
%%
idxSample = 1;
incrSample = 1;
idxElem = 1;
flgFixZAxis = 1;
flgQuit = 0;

%%
%%  Find the size of the current screen resolution
%%
vScreen = get(0, 'ScreenSize');
wBorder = 4;
wTitleBar = 14;
wToolBar = 30;
wFigs = 3/4 * vScreen(3);
ht2dFig = 225;
ht3dFig = vScreen(4) - 4 * wBorder - 2 * wTitleBar - wToolBar - ht2dFig;
VertOffset3d = wToolBar + 3 * wBorder + wTitleBar + ht2dFig;

%%
%%  Setup inital figures
%%
colordef none
h3dFig = figure;
set(h3dFig, 'color', [0 0 0]);
set(h3dFig, 'MenuBar', 'none');
set(h3dFig, 'Position', [wBorder VertOffset3d wFigs ht3dFig]);


h2dFig = figure;
set(h2dFig, 'color', [0 0 0]);
set(h2dFig, 'Position', [wBorder wToolBar wFigs ht2dFig]);
set(h2dFig, 'MenuBar', 'none');

%%
%%  Initial single element plot
%%
h2dData = plot(Data(idxElem,:), 'g');
hold on
if nargin > 2
    h2dData1 = plot(Data1(idxElem,:), 'b');
    if nargin > 3,
        h2dData2 = plot(Data2(idxElem,:), 'c');
    end
end

grid on
axis([1 nSamples zMin zMax]);
h2dPointer = plot([idxSample idxSample], [zMin zMax], 'r');
set(h2dPointer, 'EraseMode', 'normal')
xlabel('Sample Index')
ylabel('Amplitude (mV)')
if nargin == 2
    hLegend = legend(['Lead: ', int2str(idxElem)]);
elseif nargin == 3
    hLegend = legend(['Lead: ', int2str(idxElem), 'Data 1']);
else
    hLegend = legend(['Lead: ', int2str(idxElem)], 'Data 1', 'Data 2');
end

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
%%
%%  On the SGI:
%%      Normal -    
%%      Background - 
%%      XOR -       
%%      None -      

figure(h3dFig)
colormap(jet(256))
Array = reshape(Data(:, idxSample), nRows, nCols);
h3dData = mesh(Array);
set(gca, 'ydir', 'reverse')
axis([xMin xMax yMin yMax zMin zMax])
set(h3dData, 'EraseMode', 'normal')
xlabel('Column Index')
ylabel('Row Index')
zlabel('Amplitude (mV)')
title(['Index: ' int2str(idxSample)]);
view([-45 45])
grid on
hColorBar = colorbar;

%%
%%  Marker for array element displayed in 2d plot
%%
hold on
idxXElem = ceil(idxElem / nRows);
idxYElem = idxElem - (idxXElem - 1) * nRows;
h3dPoint = plot3(idxXElem, idxYElem, Array(idxYElem, idxXElem), 'w+');
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
        figure(h2dFig)
        set(h2dPointer, 'XData', [idxSample idxSample]);
        drawnow;
        
        %%
        %%  Redraw the 3d graph
        %%
        figure(h3dFig)
        Array = reshape(Data(:, idxSample), nRows, nCols);
        set(h3dPoint, 'ZData', Array(idxElem));
        set(h3dData, 'ZData', Array);
        set(h3dData, 'CData', Array);
        title(['Index: ' int2str(idxSample)]);

        
        %%
        %%  Check to see if z-axis is fixed
        %%
        if ~flgFixZAxis,
            axis([xMin xMax yMin yMax matmin(Array) matmax(Array)])
            colorbar(hColorBar);
        end
        
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
    fprintf('J\tJump to a selected sample index using mouse in 2D view\n');
    fprintf('P\tPlay a movie\n');
    fprintf('R\tRecord a movie\n');
    fprintf('S\tSelect a new array element using mouse in 3D view\n');
    fprintf('V\tmodify the viewpoint\n');
    fprintf('Z\tmodify z axis in 3D view\n');
    fprintf('Q\tQuit routine\n');
    
    KeyIn = input('Next command : ', 's');

    if isempty(KeyIn)
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
        figure(h2dFig);
        [xval yval] = ginput(1);
        xval = round(xval);
        if xval > 1 & xval < nSamples,
            idxSample = xval;
            flgRedraw = 1;
        end
        figure(h3dFig)
    end

    if KeyIn == 'S'
        %%
        %%  set the viewpoint to directly over the graph
        %%
        CurrentView = view;
        view([0 90])
        disp('Select the new leads to be displayed, press return when done')
        [idxCols idxRows] = ginput;

        nPlotLeads = length(idxCols);
        
        %%
        %%  Clip selection to within the extent of the array.
        %%
        idxRows = round(idxRows);
        idxCols = round(idxCols);
        
        idxBad = find(idxRows > nRows);
        idxRows(idxBad) = ones(size(idxBad)) * nRows;
        
        idxBad = find(idxCols > nCols);
        idxCols(idxBad) = ones(size(idxBad)) * nCols;

        idxElem = idxRows + (idxCols - 1) * nCols;

        %%
        %%  Redraw element time plot in2d figure and move marker
        %%
        figure(h2dFig)

        if nargin > 2,
            delete(h2dData1);
            if nargin > 3,
                delete(h2dData2);
            end
        end
        delete(h2dData)
        delete(hLegend);

        h2dData = plot(Data(idxElem,:), 'g');
        if nargin > 2
            h2dData1 = plot(Data1(idxElem,:), 'b');
            if nargin > 3
                h2dData2 = plot(Data2(idxElem,:), 'c');
            end
        end

        cmdLegend = 'hLegend = legend(';
        for i = 1:nPlotLeads-1,
            cmdLegend = [ cmdLegend ' ''Lead:' int2str(idxRows(i)) ',' ...
            int2str(idxCols(i)) ''','];
        end
        cmdLegend = [ cmdLegend ' ''Lead:' int2str(idxRows(nPlotLeads)) ',' ...
        int2str(idxCols(nPlotLeads)) ' '' '];
        cmdLegend = [cmdLegend ');'];
        eval(cmdLegend);


        %%
        %%  Update positional markers in 3D graph
        figure(h3dFig)
        hold on
        idxXElem = ceil(idxElem / nRows);
        idxYElem = idxElem - (idxXElem - 1) * nRows;
        delete(h3dPoint)

        h3dPoint = plot3(idxXElem, idxYElem, Array(idxElem), 'w+');
        set(h3dPoint, 'LineWidth', 3);
        hold off
        
        %%
        %%  Reset the viewpoint
        %%
        view(CurrentView);

    end
    
    %%
    %%  Select an element for the 2d plot
    %%
    if KeyIn == 's',
        newElem = input( ...
        'Enter a new row & column index as a vector: ');
        if newElem(1) < 1 | newElem(1) > nRows,
            disp('Row element out of range, hit any key to continue');
        end
        if newElem(2) < 1 | newElem(2) > nCols,
            disp('Column element out of range, hit any key to continue');
        end
        idxElem = newElem(1) + (newElem(2) - 1) * nCols;

        %%
        %%  Redraw element time plot in the 2D figure, move marker
        %%
        figure(h2dFig)
        set(h2dData, 'YData', Data(idxElem,:));
        title(['Array Element : ' int2str(idxElem)]);

        figure(h3dFig)
        idxXElem = ceil(idxElem / nRows);
        idxYElem = idxElem - (idxXElem - 1) * nRows;
        set(h3dPoint, 'XData', idxXElem);
        set(h3dPoint, 'YData', idxYElem);
        set(h3dPoint, 'ZData', Array(idxYElem, idxXElem));

    end

    %%
    %%  Change the viewpoint for the 3d plot
    %%
    if KeyIn == 'v',
        figure(h3dFig)
        [Azimuth Elevation] = view;
        disp('Current viewpoint');
        disp(['Azimuth :   ' num2str(Azimuth)]);
        disp(['Elevation : ' num2str(Elevation)]);
        vecin = input(...
            'Enter a new viewpoint [Az El]');
        if length(vecin) < 2,

        else
            view(vecin);
        end
    end
            
    if KeyIn == 'q',
        flgQuit = 1;
    end
    prevKey = KeyIn;

    %%
    %%  Z Axis control
    %%
    if KeyIn == 'z',
        figure(h3dFig)
        vecin = input(...
            'Enter a 2 element vector [zMin zMax] or 0 for default: ');
        if length(vecin) < 2,
            flgFixZAxis = 0;
            axis([1 nCols 1 nRows zMin zMax]);
        else
            flgFixZAxis = 1;
            axis([1 nCols 1 nRows vecin(1) vecin(2)])
            zMin = vecin(1);
            zMax = vecin(2);
            cMin = vecin(1);
            cMax = vecin(2);            
            caxis([cMin cMax]);
            colorbar(hColorBar);            
            figure(h2dFig)
            CurrAxis = axis;
            axis([CurrAxis(1) CurrAxis(2) zMin zMax]);
            figure(h3dFig)

        end
    end

    %%
    %%  Play a movie
    %%
    if KeyIn == 'p'
        nPlays = input(...
            'Enter the number of times to play the movie (default 1): ');
        if isempty(nPlays),
            nPlays = 1;
        end
        FrameRate = input(...
            'Enter the number of frames/second (default 5): ');
        if isempty(FrameRate),
            FrameRate = 5;
        end
        figure(h3dFig)
        movie(gcf, Movie, nPlays, FrameRate);
        flgRedraw = 1;
    end

    %%
    %%  Record a movie
    %%
    if KeyIn == 'r'
        nFrames = input('Enter the number of frames to record (0 to abort): ');
        if nFrames > 0,
            idxMStart = idxSample;
            nMStep = incrSample;
            figure(h3dFig)   
            Movie = moviein(nFrames, gcf);

            for i = 1:nFrames,
                Array = reshape(Data(:, idxSample), nRows, nCols);

                if ~flgFixColor,
                    zMax = matmax(Array);
                    zMin = matmin(Array);
                    caxis([ zMin zMax]);
                end
                set(h3dData, 'ZData', Array);
                set(h3dData, 'CData', Array);
                title(['Index: ' int2str(idxSample)]);
                
                Movie(:,i) = getframe(gcf);
                idxSample = idxSample + incrSample;
            end
        end
        flgRedraw = 1;
    end

    
    if KeyIn == 'q',
        flgQuit = 1;
    end

    prevKey = KeyIn;
end