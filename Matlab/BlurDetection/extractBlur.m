%extractBlur    Cepstral blur extraction

function blur = extractBlur(ref, blured)

% compute the cepstrum of both the reference and the blured image
REF = real(ifft2(log(abs(fft2(ref)))));
BLURED = real(ifft2(log(abs(fft2(blured)))));

blur = BLURED - REF;
