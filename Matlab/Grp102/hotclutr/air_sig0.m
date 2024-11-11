%AIR_SIG0	    Compute sigma 0 from aircraft ramge-doppler info.
%
%    air_sig0
%
%    Input variables:
%        bfrd_norm      Beamformed range-doppler map normalized in range s.t.
%                       the first range cell represents the direct path delay.
%                       [volts].
%
%        azxmit         The azimuth of each cpi [degrees].
%
%        airjam_lat     The lattitude of the aircraft [degrees]
%
%        airjam_lon     The longitude of the aircraft [degrees].
%
%        Freq           The center frequency of the transmitter signal [Hz].
%
%        TxPow          Transitter power [dBm].
%
%    Output vairables:
%        Sigma0         Sigma0 for each dRange cell [linear].
%
%        R1             Range from transmitter to dRange cell [meters].
%
%        R2             Range from dRange cell to RSTER [meters].
%
%        Beta           Angle from TX-Rx baseline to dRange cell with Tx
%                       as pivot point [radians].
%
%        Ab             Cell area for each dRange cell [meters^2].
%       
%    Calls: ll2cart, bi_range, bi_res2, lear_ant
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:28 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: air_sig0.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:28  rickg
%  Matlab Source
%
%  
%     Rev 1.3   27 Oct 1993 11:09:58   rjg
%  Added noise floor computation by estimating power in a shdaowed (hopefully) 
%  region
%  
%     Rev 1.2   01 Oct 1993 17:58:00   rjg
%  Corrected value of Signal Processing gain to match the fact that the routine
%  now extracts the maximum doppler value for a given range bin instead of
%  summing the power across all bins.
%  
%     Rev 1.1   30 Sep 1993 18:09:10   rjg
%  Incorrect formula for sigma0 derivation, forgot square on 2pi factor
%  
%     Rev 1.0   27 Sep 1993 21:00:40   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%
%%    Constants
%%
C = 299792458;
RxRowGain = 17.5;
AnalogSignalGain = 51.5;
ADC_BQS_Gain = 109.5;
NoiseRanges = [1200:1400];

%%
%%    Signal processing gain comes from the processing perfomed in hcproc
%%
%%    Amplitude & Phase Cal                   0.00 dB
%%    Beamforming (60 dB chebychev)           9.25 dB
%%    Doppler Processing (60 db cbebychev)   16.20
%%    Pulse Compression                     -42.08
%%    -------------------------------------------------
%%    Total                                 -16.63
SigProcGain = -16.63;
TotalGain = AnalogSignalGain + ADC_BQS_Gain + SigProcGain;

%%
%%    Compute mean noise power in a hopefully shadowed region.
%%
disp(['Using shadowed region : [' int2str(min(NoiseRanges)) ':' ...
    int2str(max(NoiseRanges)) ']' ]);
NoisePow = mean(max(v2p(bfrd_norm(NoiseRanges,:).')));

%%
%%    Calculate bistatic delta range [meters].
%%
[nRangeSa nDoppler ] = size(bfrd_norm);
dRange = ([0:nRangeSa-1] + 0.5) * 1e-6 * C;

%%
%%    Get aircraft position w.r.t RSTER [meters].
%%
[xTxPos yTxPos] = ll2cart(airjam_lat, airjam_lon);
TxPos = xTxPos + j * yTxPos;
fprintf('Transmitter position : %f km east,  %f km north\n', ...
    xTxPos / 1000, yTxPos / 1000);

%%
%%    Compute bistatic range and transmitter to patch angle
%%
RxAzimuth = mean(azxmit);
if std(azxmit) > 0.5,
    fprintf('WARNING: Appearent receiver azimuth error\n');
    azxmit
end
[R1 R2 Beta]= bi_range(dRange, RxAzimuth, TxPos);

%%
%%    Compute bistatic resolution cell area (for non-doppler resolved)
%%
Ab = bi_res2(TxPos, azxmit(1), R1, R2, 1/(13e-6), 6*(pi/180));

%%
%%    Compute transmitter antenna gain as a function of dRange cells
%%
TxAntGain = lear_ant(Beta).';

%%
%%    Compute effective apature of RSTER antenna [meters^2];
%%
AeRSTER = 10 .^ (RxRowGain / 10) * (C / Freq ).^2 / (4 * pi);

%%
%%   Compute received power density @ RSTER [mW / meter^2];
%%
%%        This selects the maximum of all doppler cells for a particular range.
%%
PdRSTER = max(v2p(bfrd_norm.')) / 10 .^ (TotalGain / 10) / AeRSTER;

NoisePdRSTER = NoisePow / 10 .^ (TotalGain / 10) / AeRSTER * ...
    ones(size(PdRSTER));
%%
%%   Comupute Simga0:
%%
%%
Sigma0 = ((4*pi).^2 * PdRSTER .* R1.^2 .* R2.^2) ./ ...
         (10.^(TxPow / 10) .* TxAntGain .* Ab);

NoiseFlr = ((4*pi).^2 * NoisePdRSTER .* R1.^2 .* R2.^2) ./ ...
         (10.^(TxPow / 10) .* TxAntGain .* Ab);

