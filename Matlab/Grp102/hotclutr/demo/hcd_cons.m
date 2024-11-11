%%
%%    Initializing global variables
%%
disp('Initializing system constants...')

%%
%%    Time constants
%%
tDelta = [0:1650]' * 1e-6;
tCPI = gen_time(1701, 64, 3302) * 1e-6;

%%
%%    Transmitter location
%%
TxPos = -57330+j*34040;

%%
%%    60 dB chebychev for elevation beamforming
%%
disp('    Computing elevation steering vector')
W = svrster(13, 0, 435/450, 3, 60);

%%
%%    Matched filter frequency domain 
%%
disp('    Computing matched filter coefficients')
MFC013 = conj(fft(ones(13,1), 1651));

save cons_dat
