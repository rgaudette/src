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


%%
%%    Load CW transmission file
%%
disp('Loading CW Direct Path transmission file ...');
load cwtr116v1

%%
%%    Get frequency offset of transmitter
%%
disp('    Computing frequency offset of the transmitter')
BigCPI7 = bigcpi(wrecord, 7, cpi1, cpi2, cpi3, cpi4);
PhaseCorr = phasecor(BigCPI7, tCPI);

%%
%%    Compute direct path power level
%%
disp('    Computing direct path power level')

proc13

DirPathdB = 10 * log10(mean(real(mfout .* conj(mfout))));

%%
%%    Repack workspace to save memory
%%
disp('Repacking workspace to conserve memory')
pack

%%
%%    Load file of interest
%%
disp('Loading data file ...');
load r2281227v1

%%
%%    Extract RSTER azimuth
%%
Azimuth = mean(azxmit);

%%
%%    Range process data
%%
fprintf('    Computing %f degree radial range response', Azimuth)

proc13

%%
%%    Compute sigma-0
%%
[Sigma0 NoiseFlr Range] = sigma0(mfout, tDelta, Azimuth, TxPos, DirPathdB, 46);
