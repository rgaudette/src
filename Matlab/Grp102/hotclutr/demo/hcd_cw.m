%%
%%    Load necessary constants
%%
load cons_dat

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


save cw_data DirPathdB PhaseCorr
