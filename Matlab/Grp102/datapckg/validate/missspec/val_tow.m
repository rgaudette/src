Files = [ 'tow6v1 '
          'tow6v2 '
          'tow6v3 '
          'tow6v4 '
          'tow6v5 '
          'tow6v6 '
          'tow6v7 '
          'tow6v8 '
          'tow6v9 '
          'tow6v10'
          'tow7v1 '
          'tow7v2 ' 
          'tow7v3 '
          'tow8v1 '
          'tow8v2 '
          'tow8v3 '
          'tow9v1 '
          'tow9v2 '
          'tow9v3 '
          'tow10v1'
          'tow10v2'
          'tow10v3'
          'tow10v4'
          'tow10v5'];
TargAz = 195;
RD_DetLevel = 60;
%%
%%    Load in the physical constants file
%%
phys_con

%%
%%    Beamformer and filter coefficients
%%
W = svrster(14, 0, 435/450, 3, 30);
hPC = ifft(gethpc(1, 80e-6, 500e3, 92, 0));

[nFiles junk ] = size(Files);
for idxFile = 1:nFiles,

    %%
    %%    Load in the appropriate data file
    %%
    load(deblank(Files(idxFile,:)));

    %%
    %%    Find CPI azimuth closest to target azimuth
    %%
    [AzOffset idxCPI] = min(abs(azxmit - TargAz));

    CPI = eval(['cpi' int2str(idxCPI)]);

    %%
    %%    Plot sample raw channel plot of CPI
    %%
    rawchplt(CPI, npulses(idxCPI), 1, trecord, ...
        [Files(idxFile,:) ' CPI #' int2str(idxCPI) ' Azimuth:' ...
        num2str(azxmit(idxCPI)) ' ' ], 1);

    %%
    %%    Generate range-Doppler map using 3 pulse canceller
    %%
    rdmap_3p = bfmtidoprng(CPI, npulses(idxCPI), 3, W, hPC, 50, 16);

    %%
    %%    Contour plot of map
    %%
    clf
    rdmap_3p = db(v2p(rdmap_3p));
    Peak = max(max(rdmap_3p));
    [nDop nRanges] = size(rdmap_3p);
    Range = [trecord:trecord+nRanges-1] * 1e-6 / 2 * C * m2nmi;
    if (Peak - 3) > RD_DetLevel,
        clines = [RD_DetLevel:3:Peak];
    else
        clines = [RD_DetLevel RD_DetLevel+3];
    end
    contour(Range, [0:nDop-1], rdmap_3p, clines);
    axis([min(Range) max(Range) 0 nDop-1])
    grid
    xlabel('Range (NMi)')
    ylabel('Doppler Bin')
    title([Files(idxFile,:) ' CPI #' int2str(idxCPI) ', Azimuth:' ...
        num2str(azxmit(idxCPI))]);
    drawnow
    print
end