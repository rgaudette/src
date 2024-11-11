%arrayminTest   Validation driver for arraymin
function arrayminTest
dims = [ 4 3 5 7 ];
z = rand(dims);

%  Test some of the corners of the array
idxMin = [1 1 1 1];
valMin = -1;
z(idxMin(1), idxMin(2), idxMin(3), idxMin(4)) = valMin;
test(z, valMin, idxMin);

idxMin = [dims(1) 1 1 1];
valMin = -2;
z(idxMin(1), idxMin(2), idxMin(3), idxMin(4)) = valMin;
test(z, valMin, idxMin);

idxMin = [1 dims(2) 1 1];
valMin = -3;
z(idxMin(1), idxMin(2), idxMin(3), idxMin(4)) = valMin;
test(z, valMin, idxMin);

idxMin = [dims(1) dims(2) 1 1];
valMin = -4;
z(idxMin(1), idxMin(2), idxMin(3), idxMin(4)) = valMin;
test(z, valMin, idxMin);

idxMin = [1 1 dims(3) 1];
valMin = -5;
z(idxMin(1), idxMin(2), idxMin(3), idxMin(4)) = valMin;
test(z, valMin, idxMin);

idxMin = [dims(1) dims(2) dims(3) 1];
valMin = -6;
z(idxMin(1), idxMin(2), idxMin(3), idxMin(4)) = valMin;
test(z, valMin, idxMin);

idxMin = [dims(1) 1 dims(3) 1];
valMin = -7;
z(idxMin(1), idxMin(2), idxMin(3), idxMin(4)) = valMin;
test(z, valMin, idxMin);

idxMin = [dims(1) dims(2) dims(3) dims(4)];
valMin = -8;
z(idxMin(1), idxMin(2), idxMin(3), idxMin(4)) = valMin;
test(z, valMin, idxMin);

idxMin = floor([dims(1) dims(2) dims(3) dims(4)] ./ 2);
valMin = -9;
z(idxMin(1), idxMin(2), idxMin(3), idxMin(4)) = valMin;
test(z, valMin, idxMin);

function test(array, valMin, idxMin)
[val indices] = arraymin(array);
if ~ all(indices == idxMin)
  disp(['index of true minimum: ' vec2str(idxMin)]);
  disp(['reported minimum index: ' vec2str(indices)]);
  warning('Incorrect index reported');
end
  
if val ~= valMin
  disp(['value of true minimum: ' num2str(valMin)]);
  disp(['reported minimum value: ' num2str(val)]);
  warning('Incorrect value reported');
end

return

