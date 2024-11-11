%runall         ????
function meas = runall(padStruct)
nPad = length(padStruct);

for iPad = 1:nPad
  meas(iPad) = totalGradSum(padStruct(iPad));
end
meas = reshape(meas,2,nPad/2)';