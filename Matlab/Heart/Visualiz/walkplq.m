%WALKPLQ        Walk through the plaque data as well as other sequences.
%
%   walkplq(Data, szData, seq1, seq2, seq3, seq4, Seq5)

function walkplq(Data, szData, Seq1, Seq2, Seq3, Seq4, Seq5)

%%
%%  Initilaizations
%%
idxRow = 1;
idxCol = 1;
nRows = szData(1);
nCols = szData(2);
[nLeads nSamples] = size(Data);
maxData = matmax(Data);
minData = matmin(Data);

%%
%%  Default legend labels
%%
lblData = 'Raw Data';
lblSeq1 = 'dv/dt';
lblSeq2 = 'dv/dx';
lblSeq3 = 'dv/dy';
lblSeq4 = 'grad';
lblSeq5 = 'Velocity';

%%
%%  Initial figure setup
%%
clf
set(gca, 'ColorOrder', [1 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 1; 1 1 1]);
idxLead = idxRow + (idxCol - 1) * nRows;
LineWidth = 2;
hData = plot(Data(idxLead,:), 'r');
set(hData, 'LineWidth', LineWidth);
hold on
if nargin > 2,
    hSeq1 = plot(Seq1(idxLead,:), 'b');
    set(hSeq1, 'LineWidth', LineWidth);
    if nargin > 3
        hSeq2 = plot(Seq2(idxLead,:), 'g');
        set(hSeq2, 'LineWidth', LineWidth);
        if nargin > 4,
            hSeq3 = plot(Seq3(idxLead,:), 'c');
            set(hSeq3, 'LineWidth', LineWidth);
            if nargin > 5,
                hSeq4 = plot(Seq4(idxLead,:), 'm')
                set(hSeq4, 'LineWidth', LineWidth);
                if nargin > 6,
                    hSeq5 = plot(Seq5(idxLead,:), 'w')
                    set(hSeq5, 'LineWidth', LineWidth);
                end
            end
        end
    end
end
axis([0 nSamples minData maxData]);
grid
xlabel('Sample Index')
ylabel('Amplitude')
title(['Row: ' int2str(idxRow) '  Column: ' int2str(idxCol)]);
hLeg = legend(lblData, lblSeq1, lblSeq2, lblSeq3, lblSeq4, lblSeq5);

flgQuit = 0;
flgRedraw = 0;
flgFixAxis = 1;
KeyIn = 'f'

while ~flgQuit,
    if flgRedraw,

        %%
        %%  Redraw the graph
        %%
        set(hData, 'yData', Data(idxLead,:));
        if nargin > 2,
            set(hSeq1, 'yData', Seq1(idxLead,:));
            if nargin > 3
                set(hSeq2, 'yData', Seq2(idxLead,:));
                if nargin > 4,
                    set(hSeq3, 'yData', Seq3(idxLead,:));
                    if nargin > 5,
                        set(hSeq4, 'yData', Seq4(idxLead,:));
                        if nargin > 6,
                            set(hSeq5, 'yData', Seq5(idxLead,:));
                        end
                    end
                end
            end
        end
        title(['Row: ' int2str(idxRow) '  Column: ' int2str(idxCol)]);
        if ~flgFixAxis
            axis('auto');
        end

        flgRedraw = 0; 
   end

    %%
    %%  Options menu
    %%
    clc;
    fprintf('Current lead index: %d\tRow: %d\tColumn: %d\n', ...
        idxLead, idxRow, idxCol);
    fprintf('\n\n');
    fprintf('F\tforward one lead\n');
    fprintf('B\tbackward one lead\n');
    fprintf('J\tjump to a specific lead\n');
    fprintf('A\tmodify the axis\n')
    fprintf('K\tenter a keyboard command\n');
    fprintf('Q\tQuit routine\n');

    KeyIn = input('Next command : ', 's');

    if KeyIn == ''
        KeyIn = prevKey;
    end

    if KeyIn == 'f'
        idxLead = idxLead + 1;
        idxCol = ceil(idxLead / nRows);
        idxRow = idxLead - (idxCol - 1) * nRows;
        flgRedraw = 1;
    end

    if KeyIn == 'b'
        idxLead = idxLead - 1;
        idxCol = ceil(idxLead / nRows);
        idxRow = idxLead - (idxCol - 1) * nRows;
        flgRedraw = 1;
    end

    if KeyIn == 'a'
       vecin = input(...
       'Enter a axis vector [xMin xMax yMin yMax] or 0 for autoscaling: ');
        if length(vecin) < 2,
            flgFixColor = 0;
        else
            flgFixColor = 1;
            axis(vecin)
        end 
    end

    if KeyIn == 'j'
        vecin = input('Enter the lead index or [row column] pair to display: ');

        if length(vecin) == 1,
            if vecin > prod(szData) | vecin < 1,
                disp('Lead index out of range');
                disp('Hit return to continue');
                pause
            else
                idxLead = vecin;
                idxCol = ceil(idxLead / nRows);
                idxRow = idxLead - (idxCol - 1) * nRows;
                flgRedraw = 1;
            end
        else
            if vecin(1) < 1 | vecin(1) > nRows,
                disp('Number of rows out of range');
                disp('Hit return to continue');
                pause
            elseif vecin(2) < 1 | vecin(2) > nCols,
                disp('Number of columns out of range');
                disp('Hit return to continue');
                pause
            else
                idxRow = vecin(1);
                idxCol = vecin(2);
                idxLead = idxRow + (idxCol - 1) * nRows;
                flgRedraw = 1;
            end
        end
    end
                
    if KeyIn == 'k'
        keyboard
    end

    if KeyIn == 'p'
        print -dwinc
    end

    if KeyIn == 'q',
        flgQuit = 1;
    end

    prevKey = KeyIn;

end