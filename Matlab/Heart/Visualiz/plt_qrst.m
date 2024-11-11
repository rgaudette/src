%PLT_QRST       Plot QRST integral maps.
%
%   [hLines] = plt_qrst(QRSTint, szArray, Title, flgLabel)

function [hLines] = plt_qrst(QRSTint, szArray, Title, flgLabel)

%%
%%  Initialization
%%
if nargin < 4
    flgLabel = 0;
end
orient tall

IntMin = min(QRSTint);
IntMax = max(QRSTint);

IsoLines = reshape(QRSTint, szArray(1), szArray(2));
pLines = [0:.1:IntMax];
nLines = [-.05:-.1:IntMin];
Lines = [fliplr(nLines) pLines];
hLines = contour(IsoLines, Lines, 'k');
set(gca, 'YDir', 'Reverse');
axis image
mygrid;
xlabel('Column Index')
ylabel('Row Index')
if nargin >3,
    title(Title);
end
set(gca, 'ColorOrder', [1 1 1]);
if flgLabel ~= 0,
    clabel(hLines, 'manual');
end


