%I3DMALL        Interactive 3D Mallat difference tool.
%
%    [Movie idxMStart nMStep flgFixColor] = i3dmall(Data, szArray)
%
%   TODO:   Fix element selection routine
%           replace flipud with reversed y dir
%           Update movie capabilities
%           Add szData to command line

function [Movie, idxMStart, nMStep, flgFixColor] = i3dmall(Data, szArray)

%%
%%  Extract number of array elements and number of time samples present in 
%%  data.Each time instant should be represented by column index, array 
%%  element by row index.  Also extract data maxima and minima.
%%
[nElems nSamples] = size(Data);

%%
%%    Assume image is square
%%
if nargin < 2,
    nRows = sqrt(nElems);
    nCols = nElems / nRows;
else
    nRows = szArray(1);
    nCols = szArray(2);
end

nRows = sqrt(nElems);
nCols = nElems / nRows;

dataMin = matmin(Data);
dataMax = matmax(Data);

%%
%%  Initial parameter values
%%
idxSample = 1;
incrSample = 1;
idxElem = 1;
flgFixColor = 0;
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
axis([1 nSamples dataMin dataMax]);
h2dPointer = plot([idxSample idxSample], [dataMin dataMax], 'r');
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
Array = flipud(reshape(Data(:, idxSample), nRows, nCols));
[A D1 D2 D3] = m_grad(Array);
colormap(vibgyor(128))

h3dAx1 = subplot(2,2,1);
h3dData1 = pcolor(abs(D1));
shading interp
set(h3dData1, 'EraseMode', 'background')
title('D1')

h3dAx2 = subplot(2,2,2);
h3dData2 = pcolor(abs(D2));
shading interp
set(h3dData2, 'EraseMode', 'background')
title('D2')

h3dAx3 = subplot(2,2,3);
h3dData3 = pcolor(abs(D3));
shading interp
set(h3dData3, 'EraseMode', 'background')
title('D3')

h3dAx4 = subplot(2,2,4);
h3dData4 = pcolor(abs(A));
shading interp
set(h3dData4, 'EraseMode', 'background')
title('A')

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
        [A D1 D2 D3] = m_grad(Array);

        subplot(2,2,1)
        set(h3dData1, 'CData', abs(D1));
        if ~flgFixColor,
            zMax = matmax(abs(D1));
            zMin = matmin(abs(D1));
            caxis([ zMin zMax]);
        end
        
        subplot(2,2,2)
        set(h3dData2, 'CData', abs(D2));
        if ~flgFixColor,
            zMax = matmax(abs(D2));
            zMin = matmin(abs(D2));
            caxis([ zMin zMax]);
        end

        subplot(2,2,3)
        set(h3dData3, 'CData', abs(D3));
        if ~flgFixColor,
            zMax = matmax(abs(D3));
            zMin = matmin(abs(D3));
            caxis([ zMin zMax]);
        end

        subplot(2,2,4)
        set(h3dData4, 'CData', abs(A));
        if ~flgFixColor,
            zMax = matmax(abs(A));
            zMin = matmin(abs(A));
            caxis([ zMin zMax]);
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
    fprintf('P\tPlay a movie\n');
    fprintf('R\tRecord a movie\n');
    fprintf('S\tSelect a new array element using mouse in 3D view\n');
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
    %%  Play a movie
    %%
    if KeyIn == 'p'
        nPlays = input(...
            'Enter the number of times to play the movie (default 1): ');
        if isempty(nPlays),
            nPlays = 1;
        end
        figure(1)
        movie(gcf, Movie, nPlays, 5);
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
   
            Movie = moviein(nFrames, gcf);

            figure(1)
            for i = 1:nFrames,
                Array = flipud(reshape(Data(:, idxSample), nRows, nCols));
                [A D1 D2 D3] = m_grad(Array);

                subplot(2,2,1)
                set(h3dData1, 'CData', abs(D1));
                if ~flgFixColor,
                    zMax = matmax(abs(D1));
                    zMin = matmin(abs(D1));
                    caxis([ zMin zMax]);
                end

                subplot(2,2,2)
                set(h3dData2, 'CData', abs(D2));
                if ~flgFixColor,
                    zMax = matmax(abs(D2));
                    zMin = matmin(abs(D2));
                    caxis([ zMin zMax]);
                end

                subplot(2,2,3)
                set(h3dData3, 'CData', abs(D3));
                if ~flgFixColor,
                    zMax = matmax(abs(D3));
                    zMin = matmin(abs(D3));
                    caxis([ zMin zMax]);
                end

                subplot(2,2,4)
                set(h3dData4, 'CData', abs(A));
                if ~flgFixColor,
                    zMax = matmax(abs(A));
                    zMin = matmin(abs(A));
                    caxis([ zMin zMax]);
                end
                Movie(:,i) = getframe(gcf);
                idxSample = idxSample + incrSample;
            end
        end
        flgRedraw = 1;
    end
        
    %%
    %%  Select an element for the 2d plot
    %%
    if KeyIn == 's',
        newElem = input( ...
        'Enter a new X & Y (South & West) element pair as a vector:');
        if newElem(1) < 1 | newElem(1) > nRows,
            disp('X element out of range, hit any key to continue');
        end
        if newElem(2) < 1 | newElem(2) > nCols,
            disp('Y element out of range, hit any key to continue');
            pause
        end
        idxElem = (nRows + 1 - newElem(2)) + (newElem(1) - 1) * nCols;

        %%
        %%  Redraw element time plot in figure(2) and move marker
        %%
        figure(2)
        set(h2dData, 'YData', Data(idxElem,:));
        set(h2dPointer, 'XData', [idxSample idxSample]);
        title(['Array Element : ' int2str(idxElem)]);
        figure(1)
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

    %%
    %%  Color axis control
    %%
    if KeyIn == 'z',
        figure(1)
        vecin = input(...
            'Enter a 2 element vector [cMin cMax] or 0 for autoscaling: ');
        if length(vecin) < 2,
            flgFixColor = 0;
        else
            flgFixColor = 1;
            cMin = vecin(1);
            cMax = vecin(2);            
            set(h3dAx1, 'clim', [cMin cMax]);
            set(h3dAx2, 'clim', [cMin cMax]);
            set(h3dAx3, 'clim', [cMin cMax]);
            set(h3dAx4, 'clim', [cMin cMax]);
        end
    end
            
    if KeyIn == 'q',
        flgQuit = 1;
    end
    prevKey = KeyIn;
end
