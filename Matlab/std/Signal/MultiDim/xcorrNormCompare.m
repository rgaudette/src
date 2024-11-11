%  TODO need to check for non square/cubic FFTs
disp('1 D Acf scaling')
nSamples = 64;
nFFT = nSamples;
x = randn(nSamples,1) + 1;
X = fft(x, nFFT);
Xpower = sum(X .* conj(X)) / nFFT
sum(x.^2)
xacf = real(ifft(X .* conj(X)));
xacf(1) ./ Xpower 

disp(' ')
disp('2 D Acf scaling')
x2 = randn(nSamples) + 2;
X2 = fft2(x2);
X2power = sum(X2(:) .* conj(X2(:))) ./ nFFT^2
sum(x2(:).^2)
x2acf = real(ifft2(X2 .* conj(X2)));
x2acf(1,1) ./ X2power


x2 = randn(nSamples) + 2;
X2 = fftn(x2);
X2power = sum(X2(:) .* conj(X2(:))) ./ nFFT^2
sum(x2(:).^2)
x2acf = real(ifftn(X2 .* conj(X2)));
x2acf(1,1) ./ X2power

disp(' ')
disp('3 D Acf scaling')
x3 = randn(nSamples, nSamples, nSamples) + 3;
X3 = fftn(x3);
X3power = sum(X3(:) .* conj(X3(:))) ./ nFFT^3
sum(x3(:).^2)
x3acf = real(ifftn(X3 .* conj(X3)));
x3acf(1,1) ./ X3power
