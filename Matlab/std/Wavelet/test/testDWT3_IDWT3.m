%  Test the dwt3 and idwt3 functions by decomposing and reconstructing
%  a number of 3D cubes
% function testDWT3_IDWT3
% fprintf('Testing all even dimensions: ');
% wavelet = 'Sym8';
% cube1 = randn(10, 20, 30);
% [approx details] = dwt3(cube1, wavelet);

% cube1est = idwt3(approx, details, wavelet);

% maxDiff = max(abs(cube1(:) - cube1est(:)));

% if maxDiff < 1E-11
%   fprintf('passed\n');
% else
%   fprintf('failed\n');
% end
% maxDiff

fprintf('Testing all odd dimensions: ');
wavelet = 'Sym8';
cube1 = randn(33, 34, 36);
[approx details] = dwt3(cube1, wavelet);

cube1est = idwt3(approx, details, wavelet);

if all(size(cube1) == size(cube1est))
  maxDiff = max(abs(cube1(:) - cube1est(:)));

  if maxDiff < 1E-11
    fprintf('passed\n');
  else
    fprintf('failed\n');
  end
  maxDiff
else
  fprintf('failed cubes are different sizes\n');
  [nR nC nP] = size(cube1);
  cube1est = cube1est(1:nR, 1:nC, 1:nP);
  maxDiff = max(abs(cube1(:) - cube1est(:)))
end
