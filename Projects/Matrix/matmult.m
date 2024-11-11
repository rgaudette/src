%matmult        Calculate the matrix multiplication performance in Matlab/Octave
%
%  results = matmult(mMin, mMax)

function results = matmult(mMin, mMax,skip)

mSize = [mMin:skip:mMax];

for i=1:length(mSize)
  x = rand(mSize(i));
  y = rand(mSize(i));
  z = zeros(mSize(i));
%  flops(0);
  st = clock;
  z = x * y;
  x = z * y;
  y = z * x;
  z = x * y;
  x = z * y;
  en = clock;
%  MFLOPSB = flops/1e6;
  et = etime(en, st);
  MFLOPS = 5 * size(x, 1) * (size(x,2) + size(x,2 - 1)) * size(y,2) / 1E6;
%  MFLOPS/ MFLOPSB
  results(i,:) = [mSize(i) MFLOPS MFLOPS/et];
end

