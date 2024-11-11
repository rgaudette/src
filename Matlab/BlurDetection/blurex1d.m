%  Create a simple random sign

z = rand(137,1);

nBlur = 10;
hBlur = ones(nBlur,1) / nBlur;

zBlur = conv(hBlur, z);
zBlur = zBlur(nBlur:end-nBlur+1);
z = z(1:length(z)-nBlur+1);

ZC = real(ifft(log(abs(fft(z)))));
ZBlurC = real(ifft(log(abs(fft(zBlur)))));


blurC = ZBlurC - ZC;


blurEst = ifft(exp(real(fft(blurC))));


