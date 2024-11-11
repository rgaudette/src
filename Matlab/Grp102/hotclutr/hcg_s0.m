%HCG_S0         Process a ground Hot Clutter measurment sequence for
%               power, noise floor and sigma0.
%
%    Required variables:
%
%    fnCWTR     The filename of the CW transmission recording.
%
%    fnNoise    The filename of the receiver noise recording (Hot Clutter
%               data strucure).
%
%    fnData     The filenames of the data files to be processed, each row
%               should be a unique filename.
%
%    fnSave     The filename to save the processed data.
%
%    MFC        Frequency domain matched filter coeffcients.
%
%    strTitle   Text to be added to the title of each plot, automatically
%               added text includes the filename and azimuth of each plot.
%
%    strWfm     Text to be added to the title of each plot describing the
%               waveform employed.
%
%    TxPos      Transmitter position relative to RSTER [meters].
%
%    W          Elvation steering vector for channels 2:14, channel 1 is
%               expected to be a dipole.
%
%    apcal      [OPTIONAL] Amplitude and phase calibration coefficients,
%               if present the cal factors for channels 2:14 are applied
%               to the raw cpi data at the same time the beamformer
%               coefficients are applied.
%
%    Calls: hcg_proc, sigma0
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:30 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: hcg_s0.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:30  rickg
%  Matlab Source
%
%  
%     Rev 1.4   13 Sep 1993 17:21:24   rjg
%  Move transmitter phase offset computation to hcg_proc, save vector of
%  phase offsets and phase standard deviation.
%  
%     Rev 1.3   10 Sep 1993 15:48:50   rjg
%  Amplitude and phase calibration factors are now integrated into the beamformer
%  weights if they are present in the workspace (apcal).
%  
%  Saved matricies are preallocated before the for loop.
%  
%  Index is now the loop variable instead of fnData.
%  
%  The first CPI time of each data file is saved in matCPITime.
%  
%     Rev 1.2   08 Sep 1993 15:15:16   rjg
%  Added inputs for title and waveform.
%  Moved dRange to specify center of range gate (avoids divide by zero).
%  Changed occurances of *mfout* BeamformMF.
%  Corrected Noise power and std reporting.
%  "Tagged" plot and added CW : Dipole Direct Path Ratio Plot.
%  Cleaned up workspace clearing section.
%  
%     Rev 1.1   30 Aug 1993 17:38:08   rjg
%  Corrected filename in title, changed saving routine to after the end
%  of the main loop.
%  
%     Rev 1.0   30 Aug 1993 16:55:06   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%    System constants
%%    
C = 299792458;
dRange = ([0:1650]' + 0.5) * 1e-6 * C;

%%
%%    Processing of direct path CW signal.
%%
disp(['Loading direct path CW transmission file : ' fnCWTR]);
load(fnCWTR);

%%
%%    If amplitude and phase cal factors are present, apply their conjugate
%%    to the beamformer weights.
%%
if exist('apcal') == 1,
    disp('Applying A/P cal factors to beamformer weights');
    WOriginal = W;
    W = W .* conj(apcal(2:14));
end

%%
%%    Generate CPI sample time matrix.
%%
tCPIrp = gen_time(wrecord, 64);

%%
%%    Process CW signal to get direct path power
%%
hcg_proc

DirPath = mean(real(BeamformMF .* conj(BeamformMF)));
DirPathStd = std(real(BeamformMF .* conj(BeamformMF)));
disp(['Direct path mean power : ' num2str(DirPath)])
disp(['Direct path power standard deviation : ' num2str(DirPathStd)]);

%%
%%    Rename vars clean up un-necessary variables, repack workspace.
%%
CWTRDipoleMF = DipoleMF;
CWTRDipolePeak = DipolePeak;
CWTRDipolePeakIdx = DipolePeakIdx;
CWTRDeltaPhase = DeltaPhase;
CWTRdPhaseStd = dPhaseStd;
CWTRAzimuth = azxmit;
CWTRcpitime = cpitime;
CWTRcpitype = cpitype;
CWTRfxmit = fxmit;
CWTRBeamformMF = BeamformMF;

clear CPIrd_bf CPIrd_ci CPIrd_cw CPIrd_pc
clear DiCPIrd DiCPIrd_ci DiCPIrd_pc 
clear DipoleMF DipolePeak DipolePeakIdx azxmit cpiidx cpitime cpitype elxmit
clear fxmit BeamformMF BeamformMF_nonalign muxtype npulses pri scanidx
clear wrecord tCPIrd tpulse trecord

disp('Repacking workspace ...');
pack

%%
%%    Processing of Hot Clutter noise structure for noise floor generation.
%%
disp(['Loading reciever noise file : ' fnNoise]);
load(fnNoise);

%%
%%    Process receiver noise, get receiver noise power and standard dev.
%%
hcg_proc
NoisePow = mean(real(BeamformMF .* conj(BeamformMF)));
NoisePowStd = std(real(BeamformMF .* conj(BeamformMF)));
disp(['Noise mean power : ' num2str(NoisePow)])
disp(['Noise power standard deviation : ' num2str(NoisePowStd)]);

%%
%%    Rename vars clean up un-necessary variables, repack workspace.
%%
NoiseAzimuth = azxmit;
NoiseDipoleMF = DipoleMF;
NoiseDipolePeak = DipolePeak;
NoiseDipolePeakIdx = DipolePeakIdx;
NoiseDeltaPhase = DeltaPhase;
NoisedPhaseStd = dPhaseStd;
Noisecpitime = cpitime;
Noisecpitype = cpitype;
Noisefxmit = fxmit;
NoiseBeamformMF = BeamformMF;

clear CPIrd_bf CPIrd_ci CPIrd_cw CPIrd_pc
clear DiCPIrd DiCPIrd_ci DiCPIrd_pc 
clear DipoleMF DipolePeak DipolePeakIdx azxmit cpiidx cpitime cpitype elxmit
clear fxmit BeamformMF BeamformMF_nonalign muxtype npulses pri scanidx tpulse
clear wrecord tCPIrd trecord

disp('Repacking workspace ...');
pack

%%
%%    Preallocate necessary variables used in for loop.
%%
[nFiles junk] = size(fnData);
Azimuth = zeros(4, nFiles);
matCPITime = zeros(nFiles, 6);
vDPPeak = zeros(nFiles, 1);
vDPPeakIdx = zeros(nFiles, 1);
vBeamformMFPeak = zeros(nFiles, 1);
vDeltaPhase = zeros(nFiles, 1);
vdPhaseStd = zeros(nFiles, 1);
matBeamformMF = zeros(1651, nFiles) + j * eps * ones(1651, nFiles);
matDipoleMF = zeros(1651, nFiles) + j * eps * ones(1651, nFiles);
matSigma0 = zeros(1651, nFiles);
matRange = zeros(1651, nFiles);
matNoiseFlr = zeros(1651, nFiles);

%%
%%    Loop over each file.
%%
for index = 1:nFiles,

    %%
    %%    Load required raw data file.
    %%
    disp(['Loading : ' fnData(index,:)])
    load(fnData(index,:))

    %%
    %%    Save azimuth, cpitime
    %%
    Azimuth(:,index) = azxmit;
    matCPITime(index,:) = cpitime(1,:);

    %%
    %%    Perform beamforming, doppler correction, coherent integration,
    %%  matched filtering and aligning of direct path response to zero.
    %%
    disp('Processing...')
    hcg_proc

    %%
    %%    Extract peak information from processing, put in vector to plot
    %%  against file number.
    %%
    vDPPeak(index) = DipolePeak;
    vDPPeakIdx(index) = DipolePeakIdx;
    vBeamformMFPeak(index) = BeamformMF(1);
    vDeltaPhase(index) = DeltaPhase;
    vdPhaseStd(index) = dPhaseStd;

    %%
    %%    Create matricies of matched filter output for beamformer and dipole.
    %%
    matBeamformMF(:,index) = BeamformMF;
    matDipoleMF(:,index) = DipoleMF;
    %%
    %%    Compute sigma0, noise floor and range from RSTER
    %%
    [Sigma0 Range NoiseFlr] = sigma0(BeamformMF, dRange, ...
        mean(Azimuth(:,index)), TxPos, DirPath, NoisePow);
    matSigma0(:,index) = Sigma0;
    matRange(:,index) = Range;
    matNoiseFlr(:,index) = NoiseFlr;

    %%
    %%    Plot sigma0 and noise floor wrt range from RSTER.
    %%
    disp('Plotting...')
    clf
    plot(Range / 1000 , 10 * log10(abs(Sigma0)), ...
        Range / 1000 , 10 * log10(abs(NoiseFlr)), '--r');
    hold on
    axis([0 200 -100 -20])
    grid
    xlabel('Range (kilometers)')
    ylabel('Sigma0 (dB)')
    title([ fnData(index,:) '  ' strTitle ' ' strWfm ...
        '  Az = ' num2str(mean(Azimuth(:,index)))]);

    plot([138 144], [-26 -26], '-y');
    ht = text(147, -26, 's');
    set(ht, 'FontName', 'symbol');

    plot([138 144], [-32 -32], '--r');
    text(147, -32.5, 'Noise Floor');

    hold off
    drawnow

    %%
    %%    Tag plot and send to printer
    %%
    tag
    %print

end

%%
%%    Plot dipole peak relative to CW dipole
%%
plot(mean(Azimuth), vDPPeak - CWTRDipolePeak, 'o');
xlabel('Azimuth (degrees)')
ylabel('Amplitude (dB)')
title('Dipole Peak : CW Tx Dipole Ratio')

%%
%%    Clean up workspace
%%
clear CPIrd_bf CPIrd_ci CPIrd_cw CPIrd_pc
clear DiCPIrd DiCPIrd_ci DiCPIrd_pc 
clear DipoleMF DipolePeak DipolePeakIdx azxmit cpiidx cpitime cpitype elxmit
clear fxmit BeamformMF BeamformMF_nonalign muxtype npulses pri scanidx tpulse
clear wrecord tCPIrd NoiseFlr Range Sigma0 trecord ht
clear ans index junk

%%
%%    Save remaining workspace to disk.
%%
save(fnSave)