cube1 = randn(65, 67, 69);
wavelet = 'sym8';
nScales = 3;
fprintf('Testing size: ');
fprintf('%d ', size(cube1))
fprintf('scales: %d ', nScales);

wtCoeffs = wavedec3(cube1, nScales, wavelet);
cube1est = waverec3(wtCoeffs, wavelet);

if all(size(cube1) == size(cube1est))
  maxDiff = max(abs(cube1(:) - cube1est(:)));

  if maxDiff < 1E-11
    fprintf('passed\n');
  else
    fprintf('failed\n');
  end
  maxDiff
else
  fprintf('cubes are different sizes\n');
  [nR nC nP] = size(cube1est)
  cube1est = cube1est(1:nR, 1:nC, 1:nP);
  maxDiff = max(abs(cube1(:) - cube1est(:)))
end
