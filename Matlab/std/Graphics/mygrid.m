%MYGRID         A windows meta file compatible grid function.
%
%

function hGridLines = mygrid
%%
%%
nSegments = 100;
OffOnRatio = 10;
%%
%%  Get the current tick mark positions, axis and hold state
%%
Xtick = get(gca, 'xtick');
Ytick = get(gca, 'ytick');
Axis = axis;
flgHold = ishold;
if ~flgHold
    hold on
end

%%
%%  Plot the vertical grid lines
%%
Ystep = (Axis(4) - Axis(3)) / (nSegments * OffOnRatio);
Ypts = [Axis(3):Ystep:Axis(4)];
Ypts = Ypts(1:OffOnRatio*floor(length(Ypts)/OffOnRatio));
Ypts = reshape(Ypts, OffOnRatio, length(Ypts)/OffOnRatio);
Ypts = Ypts([1 2], :);
[junk nLines] = size(Ypts);
hXGrid = zeros(nLines*length(Xtick),1);

idxStart = 1;
for iXtick = Xtick
    Xpts  = iXtick * ones(size(Ypts));
    hXGrid(idxStart:idxStart+nLines-1) = plot(Xpts, Ypts, '-k');
    idxStart = idxStart + nLines;
 end
set(hXGrid, 'LineWidth', 0.1);

Xstep = (Axis(2) - Axis(1)) / (nSegments * OffOnRatio);

Xpts = [Axis(1):Xstep:Axis(2)];
Xpts = Xpts(1:OffOnRatio*floor(length(Xpts)/OffOnRatio));
Xpts = reshape(Xpts, OffOnRatio, length(Xpts)/OffOnRatio);
Xpts = Xpts([1 2], :);
[junk nLines] = size(Xpts);
hYGrid = zeros(nLines*length(Ytick),1);

idxStart = 1;
for iYtick = Ytick
    Ypts  = iYtick * ones(size(Xpts));
    hYGrid(idxStart:idxStart+nLines-1) = plot(Xpts, Ypts, '-k');
    idxStart = idxStart + nLines;
end
set(hYGrid, 'LineWidth', 0.1);

%%
%%  Restore hold state
%%
if ~flgHold
    hold off
end

hGridLines = [hXGrid; hYGrid];
