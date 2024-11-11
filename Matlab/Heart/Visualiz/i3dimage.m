%I3DIMAGE       Interactive 3D image tool.
%
%   [Movie idxMStart nMStep] = i3dimage(Data, szData)
%
%   Movie       The last movie computed.
%
%   idxMStart   The temporal index of the first image used for the movie.
%
%   nMStep      The number of temporal samples between each frome of the
%                movie.
%
%   Data        The complex data to be plotted (nElems x nSamples).
%
%   szData      The number of rows & columns packed into the Data array.
%               [nRows nCols]
%
%   I3DIMAGE displays 3D data using the image function in matlab.  Each image
%   represents a single time instant (column) of the matrix Data.  Movies
%   (sequences of images) can be generated, played and returned.
%
%   Tme movie returned is recorded using the figure handle as the recording
%   region.  Thus when playing it back outside of the function use the
%   figure handle as an argument to the movie function.
%
%   Calls: matmax, matmin.
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
%  $Log: i3dimage.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:49  rickg
%  Matlab Source
%
%  Revision 1.3  1996/09/25 14:02:38  rjg
%  A number of cosmetic changes:
%    - added row & column labels
%    - added title to image plot
%    - deleted menus in windows (didn't work under win95)
%
%  Revision 1.2  1996/09/23 00:33:53  rjg
%  Fixed element selection code.
%  Updated help section.
%
%  Revision 1.1  1996/09/20 04:39:10  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Movie, idxMStart, nMStep] = i3dimage(Data, szData)

if nargin < 2,
    error('Not enough arguments, see help i3image');
end

%%
%%  Extract number of array elements and number of time samples present in 
%%  data.Each time instant should be represented by column index, array 
%%  element by row index.  Also extract data maxima and minima.
%%
[nElems nSamples] = size(Data);

%%
%%    Initializations
%%
nRows = szData(1);
nCols = szData(2);
dataMin = matmin(Data);
dataMax = matmax(Data);

%%
%%  Initial parameter values
%%
idxSample = 1;
incrSample = 1;
idxElem = 1;
idxCol = ceil(idxElem / nRows);
idxRow = idxElem - (idxCol - 1) * nRows;
flgFixColor = 0;
flgQuit = 0;

%%
%%  Setup inital figures
%%
h3dFig = figure(1);
clf
set(h3dFig, 'Position', [4 340 600 400]);
set(h3dFig, 'MenuBar', 'none');

h2dFig = figure(2);
clf
set(h2dFig, 'Position', [4 55 600 225]);
set(h3dFig, 'MenuBar', 'none');

%%
%%  Initial single element plot
%%
h2dData = plot(Data(idxElem,:), 'g');
hold on
axis([1 nSamples dataMin dataMax]);
h2dPointer = plot([idxSample idxSample], [dataMin dataMax], 'r');
grid
xlabel('Sample Index')
ylabel('Amplitude')
title(['Array Element: ' int2str(idxElem) '  Row: ' int2str(idxRow) ...
       '  Column: ' int2str(idxCol)]);
set(h2dPointer, 'EraseMode', 'normal')
hold off

%%
%%  Initial array plot
%%
%%  Setting erase mode:
%%  On the PC:
%%      Normal -    Appears to work the best
%%      Background - Does not redraw axis but it does draw the surface twice
%%                  This makes it slower than 'normal'
%%      XOR -       This also performs several redraws, does present a
%%                  faceted view, and the colormaping is distorted due to
%%                  the XOR operation.
%%      None -      Does not remove previous surface.  Causes an extra
%%                   redraw.
%%  On the SGI:
%%      Normal -    
%%      Background - 
%%      XOR -       
%%      None -      

figure(1)
Array = reshape(Data(:, idxSample), nRows, nCols);
h3dData = pcolor(Array);
set(gca, 'YDir', 'Reverse');
%shading interp
axis('image')
title(['Sample Index: ' int2str(idxSample)]);
hColorBar = colorbar('vert');
set(h3dData, 'EraseMode', 'normal')
colormap(bgyor(128))

flgRedraw = 0;
while flgQuit == 0,
    if flgRedraw,

        %%
        %%  Redraw the 3d graph
        %%
        figure(1)
        Array = reshape(Data(:, idxSample), nRows, nCols);

        set(h3dData, 'CData', Array);
        title(['Sample Index: ' int2str(idxSample)]);

        if ~flgFixColor,
            zMax = matmax(Array);
            zMin = matmin(Array);
            caxis([zMin zMax]);
            colorbar(hColorBar);
        end
       
        %%
        %%  Redraw the 2d graph
        %%
        figure(2)
        set(h2dPointer, 'XData', [idxSample idxSample]);
        
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
    fprintf('M\tMeasure the range of section of data\n');
    fprintf('P\tPlay a movie\n');
    fprintf('R\tRecord a movie\n');
    fprintf('S\tSelect a new array element\n');
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
        if xval >= 1 & xval <= nSamples,
            idxSample = xval;
            flgRedraw = 1;
        end
        figure(1)
    end

    %%
    %%  Measure the range of a section of data
    %%
    if KeyIn == 'm',
        vRange = input( ...
            'Enter the sample range to measure the data [iMin iMax]: ');
        if isempty(vRange),
        end
        disp(['min : ' num2str(matmin(Data(:, min(vRange):max(vRange)))) ]);
        disp(['max : ' num2str(matmax(Data(:, min(vRange):max(vRange)))) ]);
        pause
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
        figure(1)
        movie(gcf, Movie, nPlays, FrameRate);
        flgRedraw = 1;
    end

    %%
    %%  Record a movie
    %%
    if KeyIn == 'r'
        nFrames = input(...
            'Enter the number of frames to record (0 to abort): ');
        if nFrames > 0,
            idxMStart = idxSample;
            nMStep = incrSample;
            figure(1)   
            Movie = moviein(nFrames, gcf);

            for i = 1:nFrames,
                Array = reshape(Data(:, idxSample), nRows, nCols);
                %%
                %%  Update the image
                %%
                set(h3dData, 'CData', Array);
                title(['Sample Index: ' int2str(idxSample)]);

                if ~flgFixColor,
                    zMax = matmax(Array);
                    zMin = matmin(Array);
                    caxis([ zMin zMax]);
                    colorbar(hColorBar);
                end

                %%
                %%  Record the image
                %%
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
        'Enter the row & column indices for the lead as a vector: ');
        if newElem(1) < 1 | newElem(1) > nRows,
            disp('Row index out of range, hit any key to continue');
            pause
        elseif newElem(2) < 1 | newElem(2) > nCols,
            disp('Column index out of range, hit any key to continue');
            pause
        else
            idxRow = newElem(1);
            idxCol = newElem(2);
            idxElem = idxRow + (idxCol - 1) * nRows;

            %%
            %%  Redraw element time plot in figure(2) and move marker
            %%
            figure(2)
            set(h2dData, 'YData', Data(idxElem,:));
            set(h2dPointer, 'XData', [idxSample idxSample]);
            title(['Array Element: ' int2str(idxElem) ...
                   '  Row: ' int2str(idxRow) ...
                   '  Column: ' int2str(idxCol)]);

            figure(1)
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
        if length(vecin) == 2,
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
        CRange = get(gca, 'clim');
        disp(['Current Data Range : ' num2str(matmin(Array)) ' ' ...
                num2str(matmax(Array)) ]);
        disp(['Current Display Range : ' num2str(CRange(1)) ' ' ...
                num2str(CRange(2)) ]);

        vecin = input(...
            'Enter a 2 element vector [cMin cMax] or 0 for autoscaling: ');
        if length(vecin) < 2,
            flgFixColor = 0;
            figure(2)
            axis('auto')
            figure(1)
        else
            flgFixColor = 1;
            cMin = vecin(1);
            cMax = vecin(2);            
            set(gca, 'clim', [cMin cMax]);
            figure(2)
            CurrAxis = axis;
            axis([CurrAxis(1) CurrAxis(2) cMin cMax]);
            figure(1)
        end
    end
            
    if KeyIn == 'q',
        flgQuit = 1;
    end
    prevKey = KeyIn;
end
