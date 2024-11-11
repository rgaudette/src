%HCG_PROC       Signal processing for ground Hot Clutter measurments
%
%
%    Required variables
%
%    W		Beamformer coefficients
%    MFC	Matched filter coefficients
%    tCPIrp     The time of each sample of the CPIs.
%
%      This script performs the beamforming, phase correction, coherent
%  integration and matched filtering for the dipole and the 13 upper channels.
%
%    Calls: cpicint
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
%  $Log: hcg_proc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:30  rickg
%  Matlab Source
%
%  
%     Rev 1.4   13 Sep 1993 16:12:40   rjg
%  Use dipole as transmitter frequency alignment source, instead of CW 
%  transmission.
%  
%     Rev 1.3   01 Sep 1993 16:44:54   rjg
%  Changed CPIrd*'s to CPIrp*'s, that is what they are supposed to be.
%  
%     Rev 1.2   31 Aug 1993 23:39:34   rjg
%  Changed name of all output variables to be more descriptive.
%  Correctly reshape dipole structure before integration.
%  
%     Rev 1.1   30 Aug 1993 11:21:50   rjg
%  Reports what processing it is currently performing.
%  
%     Rev 1.0   29 Aug 1993 20:47:18   rjg
%  Initial revision.
%  
%     Rev 1.1   29 Aug 1993 20:43:18   rjg
%  Added more comments, VCS header.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%    Beamform all 4 cpis.
%%
disp('    Beamforming channels 2 through 14...');
CPIrp_bf = cpi1(:, 2:14) * conj(W);
CPIrp_bf = [ CPIrp_bf; cpi2(:, 2:14)*conj(W)];
CPIrp_bf = [ CPIrp_bf; cpi3(:, 2:14)*conj(W)];
CPIrp_bf = [ CPIrp_bf; cpi4(:, 2:14)*conj(W)];
CPIrp_bf = reshape(CPIrp_bf, wrecord, 64);

%%
%%    Extract dipole from CPIs.
%%
DiCPIrp = [cpi1(:,1); cpi2(:,1); cpi3(:,1); cpi4(:,1)];
DiCPIrp = reshape(DiCPIrp, wrecord, 64);

%%
%%    Remove raw cpis.
%%
clear cpi1 cpi2 cpi3 cpi4

%%
%%    Compute transmitter frequency offset from dipole
%%        - find peak of 1st pulse (corresponds to direct path).
%%        - get phase of 7 range gates following peak
%%        - compute conjugate sequence
disp('    Computing transmitter frequency offset...');
[Val DiPeakIdx] = max(v2p(DiCPIrp(:,1)));
[DeltaPhase dPhaseStd] = getphase(DiCPIrp, 3302e-6, [DiPeakIdx:DiPeakIdx+6]);
PhaseCorr = exp(-j * DeltaPhase * tCPIrp);

%%
%%    Correct doppler shift over pulses & cpis.
%%
disp('    Applying phase correction matrix...');
CPIrp_pc = CPIrp_bf .* PhaseCorr;
DiCPIrp_pc = DiCPIrp .* PhaseCorr;

%%
%%    Coherently Integrate all 64 pulses.
%%
disp('    Coherent integration...');
CPIrp_ci = cpicint(CPIrp_pc);
DiCPIrp_ci = cpicint(DiCPIrp_pc);

%%
%%    Matched filter integrated output.
%%
disp('    Matched filtering...');
BeamformMF = ifft(fft(CPIrp_ci(1:1651)) .* MFC);
BeamformMF_nonalign = BeamformMF;

DipoleMF = ifft(fft(DiCPIrp_ci(1:1651)) .* MFC);
[DipolePeak DipolePeakIdx] = max(20 * log10(abs(DipoleMF)));

%%
%%    Move direct path response to left of plot.
%%
disp('    Matched filter time alignment...');
BeamformMF = [BeamformMF(DipolePeakIdx:1651); BeamformMF(1:DipolePeakIdx-1)];
