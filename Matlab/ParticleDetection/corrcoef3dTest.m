vol2 = randn(30, 10, 10)* 0.1;
k2 = randn(5,4,3) * 1.0;
shift = [15 5 5];
vol2([0:4]+shift(1), [0:3]+shift(2), [0:2]+shift(3)) = k2;
ccFunc = corrcoef3d(vol2, k2, 'valid');
