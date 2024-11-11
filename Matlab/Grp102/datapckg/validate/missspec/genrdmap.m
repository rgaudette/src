%GENRDMAPS    Generate range-doppler maps

%%
%%    Parameters
%%
AzArray = 260;
nCancel = 3;
dBDopWin = 50;
nDopFFT = 32;
nCPI = length(npulses);


for icpi = 1:nCPI
    strICPI = int2str(icpi);
    eval(['rd' strICPI '_' int2str(dBDopWin) '= bfrd_mti(cpi' strICPI ',npulses(' ...
    strICPI '), azxmit(' strICPI '), AzArray, nCancel, hPC, dBDopWin, nDopFFT);']);
end