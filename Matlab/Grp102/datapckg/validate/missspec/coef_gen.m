%%    Generate coefficients for validation

%%
%%    Beamformer coefficients
%%
W = svrster(14, 0, 435/450, 3, 30);

%%
%%    Matched filter coefficients
%%
%%    Gaussian filtered
%%    100 uSec, 500 KHz, Matched filter, 92 samples (includes BQS delay)
%%    using real data
hPC = ifft(gethpc(1, 100e-6, 500e3, 112, 0));


