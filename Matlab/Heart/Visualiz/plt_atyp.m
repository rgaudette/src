%PLT_ATYP       Plot the atypical leads in a data set.
%
%   hLines = plt_ari(Atyp, szArray, Title)
%
%   hLines      Handles to the lines plotted in the contour routine.
%
%   Atyp        The atypical lead indices
%
%   szArray     The size of the array.
%
%   Title       A title for the plot.
%

function hLines = plt_atyp(Atyp, szArray, Title)

nRows = szArray(1);
nCols = szArray(2);

clf
orient tall

%%
%%  Compute the row & column indices from the lead index
%%
idxCol = ceil(Atyp / 25);
idxRow = Atyp - (idxCol - 1) * nRows;

%%
%%  At each atypical lead plot a marker
%%
plot(idxCol, idxRow, 'k*');
set(gca, 'YDir', 'Reverse');
axis([1 nCols 1 nRows]);
grid off
hGrid = mygrid;
axis image

xlabel('Column Index')
ylabel('Row Index')

if nargin > 2,
    title(Title);
end

