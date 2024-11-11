%SUBEXT         Extract a sub array from a plaque array.
%
%   sub = subext(Data, szData, idxRows, idxCols)

function sub = subext(Data, szData, idxRows, idxCols)

%%
%%  Reshape the data into the plaque array dimensions
%%
sub = reshape(Data, szData(1), szData(2));

%%
%%  Extract the specified rows and columns
%%
sub = sub(idxRows, idxCols);

sub = sub(:);
