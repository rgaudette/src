%val_cbs        Perform conventional beamspace processing.
%
%    val_cbs(CPImc, strcRSDS, ...
%        bfAngle, bfWindow, bfSLL, nFFT, fftWindow, fftSLL, ...
%        strTitle, FCntrArray, Config, PrintFile)
%
%    CPImc      
%
%    
%
%    PrintFile  OPTIONAL: 
%
%
%
%    Calls: val_bf, val_pc, vplt_one, vplt_cnt.
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
%  $Log: val_cbs.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:27  rickg
%  Matlab Source
%
%  
%     Rev 1.2   04 May 1994 16:06:44   rjg
%  Added flow status displays, changed val_pfft to wrfft.
%  
%     Rev 1.1   03 May 1994 11:16:44   rjg
%  EPS file output changed to color.
%  
%     Rev 1.0   02 May 1994 20:19:10   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function val_cbs(CPImc, strcRSDS, lstPulse, ...
    bfAngle, bfWindow, bfSLL, nFFT, fftWindow, fftSLL, ...
    strTitle, FCntrArray, Config, PrintFile)

%%
%%    Defaults
%%
if nargin < 13,
    flgPrintFile = 0;
elseif isstr('PrintFile '),
    flgPrintFile = 2;
else
    flgPrintFile = PrintFile;
end


%%
%%    Beamform the input CPI
%%
disp('    Beamforming raw CPI data ...');
nPulses = gnpulses(strcRSDS);
nPulses = nPulses(1);
FXmit = gfxmit(strcRSDS);
FXmit = FXmit(1);
CPIrp = val_bf(CPImc, nPulses, FXmit, FCntrArray, Config, bfAngle, bfWindow, bfSLL);


%%
%%    Plot the beamformer output.
%%
[wrecord junk] = size(CPIrp);
trecord = gtrecord(strcRSDS);
Range = [trecord:trecord+wrecord-1];
Axis = [min(Range) max(Range) -10 90];
XLabel = 'time (uSecs)';
YLabel = 'Amplitude (dB)';

%%
%%    Loop over each beamformer pulse to be plotted
%%
for idxPulse = lstPulse,
    clf
    Title = [strTitle ' Pulse #' int2str(idxPulse) ':  Beamformer output'];
    vplt_one(Range, db(v2p(CPIrp(:, idxPulse))), Axis, XLabel, YLabel, Title);

    %%
    %%    Send output to the appropriate device
    %% 
    if flgPrintFile == 2,
        print('-depsc', [PrintFile '_bf_' int2str(idxPulse)]);
    elseif flgPrintFile == 1,
        print
    else
        disp('Hit any key to plot the next page');
        pause
    end
end


%%
%%    Pulse compress the input CPI.
%%
disp('    Pulse compressing beamformed data ...');
tPulseWidth = gtpulse(strcRSDS);
tPulseWidth = tPulseWidth(1);
CPIrp = val_pc(CPIrp, tPulseWidth);


%%
%%    Plot the pulse compressor output.
%%
[wrecord junk] = size(CPIrp);
Range = [trecord:trecord+wrecord-1];
Axis = [min(Range) max(Range) -10 90];
XLabel = 'time (uSecs)';
YLabel = 'Amplitude (dB)';

%%
%%    Loop over each pulse to be plotted
%%
for idxPulse = lstPulse,
    clf
    Title = [strTitle ' Pulse #' int2str(idxPulse) ':  Pulse Compressor output'];
    vplt_one(Range, db(v2p(CPIrp(:, idxPulse))), Axis, XLabel, YLabel, Title);

    %%
    %%    Send output to the appropriate device
    %% 
    if flgPrintFile == 2,
        print('-depsc', [PrintFile '_pc_' int2str(idxPulse)]);
    elseif flgPrintFile == 1,
        print
    else
        disp('Hit any key to plot the next page');
        pause
    end
end



%%
%%    Doppler FFT the input data
%%
disp('    Pulse-Doppler transforming range-pulse CPI ...');
CPIrd = wrfft(CPIrp, nFFT, fftWindow, fftSLL);


%%
%%    Plot the range-Doppler output contour.
%%
cLines = [10:6:130];
Axis = [min(Range) max(Range) 0 nFFT-1];
XLabel = 'time (uSecs)';
YLabel = 'Doppler Bin';
Title = [strTitle ':  Range-Doppler map'];
clf;

vplt_cnt(Range, [0:nFFT-1], db(v2p(CPIrd)).', cLines, Axis, XLabel, YLabel, Title);


if flgPrintFile == 2,
    print('-depsc', [PrintFile '_rdmap' ]);
elseif flgPrintFile == 1,
    print;
else
    disp('Hit any key to plot the next page');
pause
end
