%I3DSURF        Interactive 3D surf(ace) plotting tool
%
%   [Movie idxMStart nMStep] = i3dsurf(Data, szData)
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
%   I3DSURF displays 3D data using the surf function in matlab.  Each image
%   represents a single time instant (column) of the matrix Data.  Movies
%   (sequences of images) can be generated, played and returned.
%
%
%   TODO:
%       Need to add movie recording
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:51 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: i3dsurf.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:51  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/23 01:06:06  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3dsurf(Data, szData)

%%
%%  Extract number of array elements and number of time samples present in data.
%%  Each time instant should be represented by column index, array element by
%%  row index.  Also extract data maxima and minima.
%%
nRows = szData(1);
nCols = szData(2);
[nElems nSamples] = size(Data);


xMin = 1;
xMax = nCols;
yMin = 1;
yMax = nRows;
zMax = matmax(Data);
zMin = matmin(Data);

%%
%%  Initial parameter values
%%
idxSample = 120;
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
%set(h3dFig, 'BackingStore', 'off');


figure(2)
clf
h2dFig = gcf;
set(h2dFig, 'Position', [4 55 600 225]);
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
set(h2dPointer, 'EraseMode', 'normal')
xlabel('Sample Index')
ylabel('Amplitude (mV)')
title(['Array Element : ' int2str(idxElem)]);
hold off

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

figure(1)
Array = reshape(Data(:, idxSample), nRows, nCols);
h3dData = surf(Array);
set(gca, 'YDir', 'Rev');
axis([xMin xMax yMin yMax zMin zMax])
shading faceted
set(h3dData, 'EraseMode', 'normal')
colormap(vibgyor(128))
xlabel('Column Index')
ylabel('Row Index')
zlabel('Amplitude')
colorbar

%%
%%  Marker for array element displayed in 2d plot
%%
hold on
idxCol = ceil(idxElem / nRows);
idxRow = idxElem - (idxCol - 1) * nRows;
h3dPoint = plot3(idxCol, idxRow, Array(idxElem), 'w+');
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
        drawnow;
        
        %%
        %%  Redraw the 3d graph
        %%
        figure(1)
        Array = reshape(Data(:, idxSample), nRows, nCols);
        set(h3dPoint, 'ZData', Array(idxElem));
        set(h3dData, 'ZData', Array);
        set(h3dData, 'CData', Array);

        
        %%
        %%  Check to see if z-axis is fixed
        %%
        if ~flgFixZAxis,
            axis([xMin xMax yMin yMax matmin(Array) matmax(Array)])
        end
        colorbar
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
    fprintf('S\tSelect a new array element using mouse in 3D view\n');
    fprintf('V\tmodify the viewpoint\n');
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
            set(h2dData, 'YData', Data(idxElem,:));
            set(h2dPointer, 'XData', [idxSample idxSample]);
            title(['Array Element : ' int2str(idxElem)]);

            %%
            %%  Update marker in 3D plot
            %%
            figure(1)
            idxCol = ceil(idxElem / nRows);
            idxRow = idxElem - (idxCol - 1) * nRows;
            set(h3dPoint, 'XData', idxCol);
            set(h3dPoint, 'YData', idxRow);
            set(h3dPoint, 'ZData', Array(idxElem));

        end
    end


    %%
    %%  Change the viewpoint for the 3d plot
    %%
    if KeyIn == 'v',
        figure(1)
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
