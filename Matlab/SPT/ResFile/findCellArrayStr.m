%idxStr = findCellArrayStr(cellArray, strTest)
function idxStr = findCellArrayStr(cellArray, strTest)
idxStr = 0;
nElem = length(cellArray);
i = 1;
while i <= nElem
  if strcmp(cellArray{i}, strTest)
    idxStr = i;
    break;
  end
  i = i + 1;
end
