

StartTime = clock

FileNum = [ 6:15 17:48];

Index = 1;

for currfile = FileNum
    Base = 'rdmap';
    strFileNum = sprintf('%02.0f', currfile);
    rdfile = [Base strFileNum ];
    disp(['Loading : ' rdfile]);
    eval(['load ' rdfile]);
    
    disp('Processing...')
    %%
    %%    Flip beamformed range-doppler matrix left-to-right to correct doppler
    %%
    bfrd_norm = fliplr(bfrd);

    %%
    %%    Find peak of dipole map
    %%
    map = 20*log10(abs(dipole_rd));
    [Peak(Index) DopplerIdx(Index)] = max(max(map));
    [junk RangeIdx(Index)] = max(max(map'));

    %%
    %%    Rotate range so that range cell 0 corresponds to direct path delay
    %%
    bfrd_norm = bfrd_norm([RangeIdx(Index):127 1:RangeIdx(Index)-1], :);

save(rdfile, 'Base', 'bfrd', 'elev', 'scanidx', 'cpiidx', 'elxmit', ...
    'MFC', 'cpitime', 'filename', 'PhaseCorr', 'cpitype', 'fxmit', ...
    'tpulse', 'muxtype', 'trecord', 'W', 'dipole_rd', 'npulses', ...
    'wrecord', 'azxmit', 'dop_win', 'pri', 'bfrd_norm');

    Index = Index + 1;
end

disp('Total processing time ');
etime(clock, StartTime)

