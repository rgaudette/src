%SIGMA0PT       Compute sigmao using the measured transmitter power.
%
%    [Sigma0 Range NoiseFlr] = sigma0pt(mfout, dRange, Azimuth, TxPos, TxPow,
%        Gsig, Gadc, Grx, Gc, Bandwidth, Beamwidth, Gr)
%
%    Sigma0    sigma-naught
%
%    mfout     Matched filter output [volts].
%
%    dRange    Delta range corresponding to matched filter output [meters].
%
%    Azimuth   Rx antenna azimuth relative to north [degrees].
%
%    TxPos     Transmitter position relative to receiver [meters].
%
%    TxPow     Effective transmitter power @ antenna (ERP - Gt) [dBm].
%
%    NoisePow  OPTIONAL: The receiver noise power level relative to mfout.
%              (default: 0).
%
%    Gsig      OPTIONAL: Signal processing gain (beamforming, integration,
%              pulse compression) [dB] (default: 30.72).
%
%    Gadc      OPTIONAL: ADC/BQS gain [dB] (default: 109.5).
%
%    Grx       OPTIONAL: Receiver gain [dB] (default: 53).
%
%    Gc        OPTIONAL: Antenna cable gain [dB] (default: -1.5).
%
%    Bandwidth OPTIONAL: Pulse bandwidth [Hz] (default: 76923.1).
%
%    Beamwidth OPTIONAL: Antenna beamwidth [degrees] (default: 6).
%
%    Gr        OPTIONAL: Receiver antenna gain [dB] (default: 17.5).
%
%    Calls: v2p, bi_range2, bi_res2, lfrank2.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:33 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: sigma0pt.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:33  rickg
%  Matlab Source
%
%  
%     Rev 1.0   01 Nov 1993 14:02:36   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Sigma0, R2, NoiseFlr] = sigma0pt(mfout, dRange, Azimuth, TxPos, ...
    TxPow, NoisePow, Gsig, Gadc, Grx, Gc, Bandwidth, Beamwidth, Gr)

%%
%%    Default values
%%
if nargin < 13,
    Gr = 17.5;
    if nargin < 12,
        Beamwidth = 6;
        if nargin < 11,
            Bandwidth = 1 / 13e-6;
            if nargin < 10,
                Gc = -1.5;
                if nargin < 9,
                    Grx = 53;
                    if nargin < 8,
                        Gadc = 109.5;
                        if nargin < 7,
                            Gsig = 30.72;
                            if nargin < 6,
                                NoisePow = 0;
                            end
                        end
                    end
                end
            end
        end
    end
end

%%
%%    Unit conversions
%%
TxPow = 10 .^ (TxPow / 10);
Beamwidth = Beamwidth * pi / 180;
Gc = 10 .^ (Gc / 10);
Gr = 10 .^ (Gr / 10);
Grx = 10 .^ (Grx / 10);
Gadc = 10 .^ (Gadc / 10);
Gsig = 10 .^ (Gsig / 10);

lambda = 299792458 / 435e6;

%%
%%    Convert matched filter output to power
%%
mfout = v2p(mfout);

%%
%%    Compute ranges and bistatic resolution cell area.
%%
[R1 R2 Beta] = bi_range(dRange, Azimuth, TxPos);
Ab = bi_res2(TxPos, Azimuth, R1, R2, Bandwidth, Beamwidth);

%%
%%    Compute Tx antenna gain.
%%
Gt = lfrank2(Beta);

%%
%%    Compute sigma0 for each cell.
%%
Sigma0 = mfout .* (4*pi).^3 .* R1.^2 .* R2.^2 ./ ...
    (TxPow .* Gt .* Ab .* Gr .* lambda.^2 .* Gc .* Grx .* Gadc .* Gsig);


NoiseFlr = NoisePow .* (4*pi).^3 .* R1.^2 .* R2.^2 ./ ...
    (TxPow .* Gt .* Ab .* Gr .* lambda.^2 .* Gc .* Grx .* Gadc .* Gsig);
