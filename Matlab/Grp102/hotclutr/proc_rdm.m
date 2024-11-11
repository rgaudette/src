%%PROC_RDMAPS   Process range-doppler maps for aircraft run
%%

StartTime = clock
Base = 'r11914';
FileNum = [ 6:15 17:48];

elev = 0;
dop_win = chebwgt(64, 60);
%%
%%    Pulsed CW matched filter coefficients.
%%
MFC = conj(fft(ones(13,1), 1651));

index = 1;
for currfile = FileNum
    strFileNum = sprintf('%02.0f', currfile);
    filename = [Base strFileNum 'v1'];
    disp(['Loading : ' filename]);
    eval(['load ' filename]);

    disp('Processing...')
    st = clock;

    %%
    %%    Cojugate each cpi if the aircraft is inbound
    %%
    cpi1 = conj(cpi1);
    cpi2 = conj(cpi2);
    cpi3 = conj(cpi3);
    cpi4 = conj(cpi4);

    hcproc

    disp(['  ' num2str(etime(clock,st)) ' seconds']);

    clear cpi1 cpi2 cpi3 cpi4 dipole bfcpi

    save(['rdmap' int2str(azxmit(1))], 'MFC', 'PhaseCorr', 'W', 'azxmit', ...
        'bfrd', 'bfrd_norm', 'cpiidx', 'cpitime', 'cpitype', 'dipole_rd', ...
        'dop_win', 'elev', 'elxmit', 'fxmit', 'muxtype', 'npulses', 'pri', ...
        'scanidx', 'tpulse', 'trecord', 'wrecord');

    index = index + 1;
end

disp('Total processing time ');
etime(clock, StartTime)