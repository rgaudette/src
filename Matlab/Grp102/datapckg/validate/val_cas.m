%val_cas        Perform conventional azimuth space processing for validation.
%
%    val_cas(CPImc, strcRSDS, lstPulse, lstRG, ...
%        az_nFFT, azWindow, azSLL, ...
%        nFFT, fftWindow, fftSLL, ...
%        strTitle, PrintFile)
%
%    CPImc      
%
%    
%
%    PrintFile  OPTIONAL: 
%
%
%
%    Calls: val_pc, 
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:27 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: val_cas.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:27  rickg
%  Matlab Source
%
%  
%     Rev 1.0   03 May 1994 16:55:32   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function val_cas(CPImc, strcRSDS, lstPulse, lstRG, az_nFFT, azWindow, azSLL, ...
         nFFT, fftWindow, fftSLL, strTitle, PrintFile)

%%
%%    Defaults
%%
if nargin < 12,
    flgPrintFile = 0;
elseif isstr('PrintFile '),
    flgPrintFile = 2;
else
    flgPrintFile = PrintFile;
end


%%
%%    If valid pulse compress the raw channel data
%%        the pulse compression routine needs the data in range-pulse format
%%        thus we need to make each pulse a seperate column
%%
disp('    Pulse compressing raw channel data ...');
[nRGTotal nCh] = size(CPImc);
nPulses = gnpulses(strcRSDS);
nPulses = nPulses(1);
wrecord = nRGTotal / nPulses;

CPImc = reshape(CPImc, wrecord, nPulses * nCh);

tPulseWidth = gtpulse(strcRSDS);
tPulseWidth = tPulseWidth(1);
CPImc = val_pc(CPImc, tPulseWidth);
[wrecord junk ] = size(CPImc);


%%
%%    Reshape the CPI back into a multi-channel CPI
%%
CPImc = reshape(CPImc, wrecord * nPulses, nCh);
trecord = gtrecord(strcRSDS);


%%
%%    Loop over each pulse compressor pulse to be plotted
%%
idxRG = [trecord:trecord+wrecord-1];
Axis = [min(idxRG) max(idxRG) -10 110];
XLabel = 'Range Gate';
YLabel = 'Amplitude (dB)';
flgPeak = 1;

for idxPulse = lstPulse,

    %%
    %%    Extract the required pulse from the CPImc
    %%
    idxSel = [1:wrecord] + (idxPulse - 1) * wrecord;
    matMCH = db(v2p(CPImc(idxSel, :)));
    Title = [strTitle ' Pulse #' int2str(idxPulse) ':  Channel pulse compressor output'];
    mchplt(matMCH, idxRG, Axis, Title, XLabel, YLabel, ...
        [PrintFile '_chpc_' int2str(idxPulse)], flgPeak);
end


%%
%%    Transform the range-channel CPI to a range-azimuth CPI swapping the columns so
%%    that boersight is in the center of the plot.
%%
disp('    Channel-Azimuth transforming pulse compressed channels ...');
CPIra = wrfft(CPImc, az_nFFT, azWindow, azSLL);
CPIra = (fftswap(CPIra.')).';

%%
%%    Plot the range-azimuth output contour for each pulse requested.
%%
cLines = [10:6:130];
AzBins = [0:az_nFFT-1] - az_nFFT / 2;
Axis = [min(AzBins) max(AzBins) min(idxRG) max(idxRG)];
YLabel = 'Range Gate';
XLabel = 'Azimuth Bin';

for idxPulse = lstPulse,

    %%
    %%    Extract the required pulse from the CPIra
    %%
    idxSel = [1:wrecord] + (idxPulse - 1) * wrecord;
    matRA = db(v2p(CPIra(idxSel, :)));
    [Peak iPkAz] = max(max(matRA));
    iPkAz = AzBins(iPkAz);
    [Peak iPkRG] = max(max(matRA.'));
    iPkRG = idxRG(iPkRG);


    Title = [strTitle ' Pulse #' int2str(idxPulse) ':  Range-Azimuth map  ' ...
        'Peak: ' num2str(Peak) ' @ Az: ' num2str(iPkAz) '  RG: ' num2str(iPkRG)];
    clf;
    vplt_cnt(AzBins, idxRG, matRA, cLines, Axis, XLabel, YLabel, Title);

    if flgPrintFile == 2,
        print('-depsc', [PrintFile '_ramap_' int2str(idxPulse) ]);
    elseif flgPrintFile == 1,
        print;
    else
        disp('Hit any key to plot the next page');
        pause
    end

end


%%
%%    For each value in the range-gate list produce a Azimuth-Doppler map
%%
disp('    Pulse-Doppler transforming range-Azimuth CPI ...');
cLines = [10:6:130];
DopBins = [0:nFFT-1] - nFFT / 2;
Axis = [min(AzBins) max(AzBins) min(DopBins) max(DopBins)];
YLabel = 'Doppler Bin';
XLabel = 'Azimuth Bin';

for idxRG = lstRG,

    %%
    %%    Extract the specified range gate from each pulse, rotate to match
    %%
    idxCell = ([1:nPulses] - 1) * wrecord + (idxRG - trecord + 1);

    %%
    %%    Transform along pulse to get a Doppler-Azimuth CPI swapping Doppler s.t.
    %%    the center 
    %%
    CPIda = db(v2p(wcfft(CPIra(idxCell, :), nFFT, fftWindow, fftSLL)));
    CPIda = fftswap(CPIda);

    [Peak iPkAz] = max(max(CPIda));
    iPkAz = AzBins(iPkAz);
    [Peak iPkDop] = max(max(CPIda.'));
    iPkDop = DopBins(iPkDop);

    %%
    %%    Display the Doppler-Azimuth contour map
    %%
    Title = [strTitle ' Range Gate #' int2str(idxRG) ':  Doppler-Azimuth map  ' ...
        'Peak: ' num2str(Peak) ' @ Az: ' num2str(iPkAz) '  Dop: ' num2str(iPkDop)];
    clf;
    vplt_cnt(AzBins, DopBins, CPIda, cLines, Axis, XLabel, YLabel, Title);

    if flgPrintFile == 2,
        print('-depsc', [PrintFile '_damap_' int2str(idxRG) ]);
    elseif flgPrintFile == 1,
        print;
    else
        disp('Hit any key to plot the next page');
        pause
    end
end