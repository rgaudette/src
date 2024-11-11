%I3DARRW        Interactive 3D arrow plotting tool.
%
%   [Movie idxMStart nMStep] = i3darrw(Data, szData, Colors, Scalar)
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
%   Colors      [OPTIONAL] The color to use for each arrow.  This array
%               should be the same size as Data and real.  If it is not
%               present the magnitude of data is used to color the arrows.
%
%   Length      [OPTIONAL] The legnth of each arrow.   This array
%               should be the same size as Data and real.  If it is not
%               present all arrows are the same length.
%
%   NOT IMPLEMENTED
%   Scalar      [OPTIONAL] The data to show in the scalar plot.  This array
%               should be the same size as Data and real.  If it is not
%               present the array used to color the data will be displayed.
%   
%   Calls: arrows2, matmin, matmax
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
%  $Log: i3darrw.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:48  rickg
%  Matlab Source
%
%  Revision 1.5  1997/08/13 22:11:27  rjg
%  Added an optional length array to modify length of the arrows.
%
%  Revision 1.4  1997/07/30 20:40:09  rjg
%  Removed edge color statement, it is done in arrows2.
%
%  Revision 1.3  1997/07/14 17:32:45  rjg
%  Added code to correctly place windows on the screen.
%  Added previous key default to 'f'
%  Use colordef none mode for MATLAB 5.
%  Quicker to clear axis now as opposed to deleting the arrows objects.
%  Added keyboard input section (not menued).
%  Title identifying index of sequence was added.
%
%  Revision 1.2  1996/09/23 00:13:21  rjg
%  Set edgecolor to black on advice from Joe Hicklin from MATLAB (For speed).
%
%  Revision 1.1  1996/09/20 04:40:44  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Movie, idxMStart, nMStep] = i3darrw(Data, szData, Colors, Length, Scalar)

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

dataMin = matmin(abs(Data));
dataMax = matmax(abs(Data));

prevKey = 'f';

%%
%%  Initial parameter values
%%
idxSample = 25;
incrSample = 1;
idxElem = 1;
flgFixColor = 0;
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

figure(1)
h3dFig = gcf;
clf
set(h3dFig, 'color', [0 0 0]);
set(h3dFig, 'MenuBar', 'none');
set(h3dFig, 'Position', [wBorder VertOffset3d wFigs ht3dFig]);

figure(2)
h2dFig = gcf;
clf
set(h2dFig, 'color', [0 0 0]);
set(h2dFig, 'Position', [wBorder wToolBar wFigs ht2dFig]);
set(h2dFig, 'MenuBar', 'none');

%%
%%  Initial single element plot
%%
h2dData = plot(abs(Data(idxElem,:)), 'g');
set(h2dData, 'EraseMode', 'normal')
grid
hold on
axis([1 nSamples dataMin dataMax]);
h2dPointer = plot([idxSample idxSample], [dataMin dataMax], 'r');
set(h2dPointer, 'EraseMode', 'normal')
xlabel('Sample Index')
ylabel('Amplitude')
title(['Array Element : ' int2str(idxElem)]);
hold off

%%
%%  Initial array plot
%%
figure(1)
set(gca, 'DrawMode', 'Fast');
colormap(bgyor(128))
grid
axis([0 nCols+1 0 nRows+1]);
axis('image')
Array = reshape(Data(:, idxSample), nRows, nCols);
if nargin == 2,
    hArrows = arrows2(Array);
elseif nargin == 3
    Col = reshape(Colors(:, idxSample), nRows, nCols);
    hArrows = arrows2(Array, Col);
else
    Col = reshape(Colors(:, idxSample), nRows, nCols);
    ArrLength = reshape(Length(:, idxSample), nRows, nCols);
    hArrows = arrows2(Array, Col, ArrLength);
end
title(['Index: ' int2str(idxSample)]);
hColorBar = colorbar('vert');

flgRedraw = 0;
while flgQuit == 0,
    if flgRedraw,

        %%
        %%  Redraw the 3d graph
        %%
        figure(1)
        Array = reshape(Data(:, idxSample), nRows, nCols);
        cla
        if nargin == 2,
            hArrows = arrows2(Array);
        elseif nargin == 3
            Col = reshape(Colors(:, idxSample), nRows, nCols);
            hArrows = arrows2(Array, Col);
        else
            Col = reshape(Colors(:, idxSample), nRows, nCols);
            ArrLength = reshape(Length(:, idxSample), nRows, nCols);
            hArrows = arrows2(Array, Col, ArrLength);
        end

        title(['Index: ' int2str(idxSample)]);

        if ~flgFixColor,
            colorbar(hColorBar);
        end

        drawnow;
        
        %%
        %%  Redraw the 2d graph
        %%
        figure(2)
        set(h2dPointer, 'XData', [idxSample idxSample]);
        drawnow;
        
        flgRedraw = 0;
    end

    %%
    %%  Options menu
    %%
    fprintf('Current sample index\t%d\n', idxSample);
    fprintf('\n\n');
    fprintf('F\tforward one step\n');
    fprintf('B\tbackward one step\n');
    fprintf('I\tAdjust sample step size\n\n');
    fprintf('J\tJump to a selected sample index using mouse in 2D view\n');
    fprintf('M\tMeasure the range of section of data\n');
    fprintf('P\tPlay a movie\n');
    fprintf('R\tRecord a movie\n');
    fprintf('S\tSelect a new array element using mouse in 3D view\n');
    fprintf('Z\tmodify color axis view\n');
    fprintf('Q\tQuit routine\n');
    
    KeyIn = input('Next command : ', 's');

    if isempty(KeyIn)
        KeyIn = prevKey;
    end

    %%
    %%  Keyboard input
    %%
    if KeyIn == 'k'
        keyboard
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
    %%  Measure the range of a section of data
    %%
    if KeyIn == 'm',
        vRange = input( ...
            'Enter the sample range to measure the data [iMin iMax]: ');
        disp(['min : ' num2str(matmin(abs(Data(:, min(vRange):max(vRange))))) ]);
        disp(['max : ' num2str(matmax(abs(Data(:, min(vRange):max(vRange))))) ]);
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
        nFrames = input('Enter the number of frames to record (0 to abort): ');
        if nFrames > 0,
            idxMStart = idxSample;
            nMStep = incrSample;
            figure(1)   
            Movie = moviein(nFrames, gcf);

            for i = 1:nFrames,
                Array = reshape(Data(:, idxSample), nRows, nCols);
                cla
                if nargin == 2,
                    hArrows = arrows2(Array);
                elseif nargin == 3
                    Col = reshape(Colors(:, idxSample), nRows, nCols);
                    hArrows = arrows2(Array, Col);
                else
                    Col = reshape(Colors(:, idxSample), nRows, nCols);
                    ArrLength = reshape(Length(:, idxSample), nRows, nCols);
                    hArrows = arrows2(Array, Col, ArrLength);
                end
                title(['Index: ' int2str(idxSample)]);

                if ~flgFixColor,
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
        'Enter a new Y & X (Row & Column) element pair as a vector:');
        if newElem(1) < 1 | newElem(1) > nRows,
            disp('X element out of range, hit any key to continue');
        end
        if newElem(2) < 1 | newElem(2) > nCols,
            disp('Y element out of range, hit any key to continue');
        end
        idxElem = newElem(1) + (newElem(2) - 1) * nRows;

        %%
        %%  Redraw element time plot in figure(2) and move marker
        %%
        figure(2)
        set(h2dData, 'YData', abs(Data(idxElem,:)));
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
        CRange = get(gca, 'clim');
        disp(['Current Data Range : ' num2str(matmin(abs(Array))) ' ' ...
                num2str(matmax(abs(Array))) ]);
        disp(['Current Display Range : ' num2str(CRange(1)) ' ' ...
                num2str(CRange(2)) ]);

        vecin = input(...
            'Enter a 2 element vector [cMin cMax] or 0 for autoscaling: ');

        %%
        %%  Reset the color mapping to automatic
        %%
        if length(vecin) < 2,
            flgFixColor = 0;
            figure(2)
            axis('auto')
            figure(1)

        %%
        %%  Fix the color mapping in the arrow window and set the axis for the
        %%  single element plot
        %%
        else
            flgFixColor = 1;
            cMin = vecin(1);
            cMax = vecin(2);            
            caxis([cMin cMax]);
            colorbar(hColorBar);            
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
