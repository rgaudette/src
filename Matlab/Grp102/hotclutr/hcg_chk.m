%HCG_CHK            Compare sigma0 values computed by two methods.
%
%    hcg_chk
%
%    Input variables:
%        BeamformMF     Beamformer output from hcg_proc for a single azimuth.
%
%        RxAzimuth        Azimuth angle of BeamformMF [degrees].
%
%        TxPos          Transmitter position [meters].
%
%    Calls: bi_range, bi_res2, lfrank2.
%
%    Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:30 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: hcg_chk.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:30  rickg
%  Matlab Source
%
%  
%     Rev 1.0   27 Oct 1993 11:02:24   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%    Constants
%%
C = 299792458;
RxRowGain = 17.5;
AnalogSignalGain = 51.5;
ADC_BQS_Gain = 109.5;

%%
%%    Signal processing gain comes from the processing perfomed in hcg_proc
%%
%%    Amplitude & Phase Cal                  -0.67 dB
%%    Beamforming (60 dB chebychev)           9.11 dB
%%    Coherent Integration                   ~0.00 dB
%%    Pulse Compression                      22.28 dB
%%    -------------------------------------------------
%%    Total                                  30.72 dB
SigProcGain = 30.72;
TotalGain = AnalogSignalGain + ADC_BQS_Gain + SigProcGain;

%%
%%    Calculate bistatic delta range [meters].
%%
nRangeSa = length(BeamformMF);
dRange = ([0:nRangeSa-1]' + 0.5) * 1e-6 * C;

[R1 R2 Beta]= bi_range(dRange, RxAzimuth, TxPos);

%%
%%    Compute bistatic resolution cell area (for non-doppler resolved)
%%
Ab = bi_res2(TxPos, RxAzimuth, R1, R2, 1/(13e-6), 6*(pi/180));

%%
%%    Compute transmitter antenna gain as a function of dRange cells
%%
TxAntGain = lfrank2(Beta);

%%
%%    Compute effective apature of RSTER antenna [meters^2];
%%
AeRSTER = 10 .^ (RxRowGain / 10) * (C / Freq ).^2 / (4 * pi);

%%
%%   Compute received power density @ RSTER [mW / meter^2];
%%
%%        This selects the maximum of all doppler cells for a particular range.
%%
PdRSTER = v2p(BeamformMF) / 10 .^ (TotalGain / 10) / AeRSTER;

%%
%%   Compute Simga0:
%%
%%
DCompSigma0 = ((4*pi).^2 * PdRSTER .* R1.^2 .* R2.^2) ./ ...
         (10.^(TxPow / 10) .* TxAntGain .* Ab);
