%DIFFMOV        Generate a movie sequence using central difference approx.
%
%
function Mov = diffmov(Data, idxSample, incrSample)

%%
%%  Extract number of array elements and number of time samples present in data.
%%  Each time instant should be represented by column index, array element by
%%  row index.  Also extract data maxima and minima.
%%
nRows = 16;
Data = Data ./ 1E3;
[nElems nSamples] = size(Data);
nCols = nElems / nRows;

zMax = matmax(Data);
zMin = matmin(Data);

%%
%%  Initial parameter values
%%
%idxSample = 250;
%incrSample = 2;
idxElem = 1;

flgQuit = 0;

%%
%%  Setup inital figures
%%
figure(1)
clf
h3dFig = gcf;
set(h3dFig, 'Position', [4 330 600 400]);
%set(h3dFig, 'BackingStore', 'off');


figure(2)
clf
h2dFig = gcf;
set(h2dFig, 'Position', [4 4 600 275]);
%set(h2dFig, 'BackingStore', 'off');

%%
%%  Initial plots
%%
h2dData = plot(Data(idxElem,:), 'g');
set(h2dData, 'EraseMode', 'xor')
grid
hold on
axis([1 nSamples zMin zMax]);
h2dPointer = plot([idxSample idxSample], [zMin zMax], 'r');
set(h2dPointer, 'EraseMode', 'xor')
xlabel('Sample Index')
ylabel('Amplitude (mV)')
title(['Array Element : ' int2str(idxElem)]);

figure(1)
Array = flipud(reshape(Data(:, idxSample), nRows, nCols));
CDiff = cdgrad(Array);
h3dData = pcolor(flipud(abs(CDiff)));
shading  interp
colormap(vibgyor(128))
xlabel('South')
ylabel('West')

%idxXElem = rem(idxElem, nRows);
%idxYElem = ceil(idxElem / nRows);
%h3dPoint = plot(idxXElem, idxYElem, 'w+');
%set(h3dPoint, 'LineWidth', 3);
drawnow

nMovie = 75;

Mov = moviein(nMovie);
i = 1;
flgRedraw = 0;
while flgQuit == 0,
    if flgRedraw,

        figure(2)
        set(h2dPointer, 'XData', [idxSample idxSample]);

        figure(1)
        Array = flipud(reshape(Data(:, idxSample), nRows, nCols));
        CDiff = cdgrad(Array);
        set(h3dData, 'cdata', flipud(abs(CDiff)));
        drawnow
        if i <= nMovie;

            Mov(:, i) = getframe;
            i = i+1;
        else
            return
        end


        flgRedraw = 0;
    end
    
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

    KeyIn = 'f'    
%    KeyIn = input('Next command : ', 's');

    if KeyIn == ''
        KeyIn = prevKey;
    end
    
    if KeyIn == 'b'
        idxSample = idxSample - incrSample;
        flgRedraw = 1;
    end

    if KeyIn == 'f'
        idxSample = idxSample + incrSample;
        flgRedraw = 1;
    end

    if KeyIn == 'i'
        incrSample = input('Enter a new sample increment value: ');
    end

    if KeyIn == 'j',
        figure(2);
        [xval yval] = ginput(1);
        xval = round(xval);
        if xval > 1 & xval < nSamples,
            idxSample = xval;
            flgRedraw = 1;
        end
    end

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
%        set(h3dPoint, 'XData', newElem(1));
%        set(h3dPoint, 'YData', newElem(2));
%        set(h3dPoint, 'ZData', Array(idxElem));
    end

    if KeyIn == 'z',
        figure(1)
        vecin = input(...
            'Enter a 2 element vector [zMin zMax] or 0 for default: ');
        if length(vecin) < 2,
            axis([1 nCols 1 nRows zMin zMax]);
        else
            axis([1 nCols 1 nRows vecin(1) vecin(2)])
        end
    end
            
    if KeyIn == 'q',
        flgQuit = 1;
    end
    prevKey = KeyIn;
end
