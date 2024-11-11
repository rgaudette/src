%SIGMA0DP    Derive sigma-0 for matched filter output and direct path power
%          level.
%
%    [Sigma0 Range NoiseFlr] = ...
%        sigma0dp(mfout, dRange, Azimuth, TxPos, DirPath, NoisePow)
%
%    Sigma0    sigma-naught
%
%    Range     Radial range to cell [meters].
%
%    NoiseFlr  The sigma0 noise floor.
%
%    mfout     Matched filter output [volts].
%
%    dRange    Delta range corresponding to matched filter output [meters].
%
%    Azimuth   Rx antenna azimuth relative to north [degrees].
%
%    TxPos     Transmitter position relative to receiver [meters].
%
%    DirPath   Direct path power level relative to mfout.
%
%    NoisePow  [OPTIONAL] The receiver noise power relative to mfout
%              (default: 0).
%
%        SIGMA0DP derives the value of Sigma0 from the matched filter output
%    (range aligned, s.t. the direct path response is at index zero), the
%    collection geometry and the direct path power.  It also computes the
%    the appearant Sigma0 due to noise vs. range if NoisePow is supplied.
%
%    Calls: v2p, bi_range, bi_res2, lfrank2
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:32 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: sigma0dp.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.0   01 Nov 1993 10:27:34   rjg
%  Initial revision.
%  
%     Rev 1.4   30 Sep 1993 18:16:04   rjg
%  Added forgotten 4 pi factor in formulas for sigma0 and apearent noise floor
%  
%     Rev 1.3   30 Aug 1993 14:01:16   rjg
%  Corrected help comments for varible names.
%  
%     Rev 1.2   30 Aug 1993 10:50:26   rjg
%  NoisePow is now optional, defaults to zero.
%  Both direct path power and noise power are now linear.
%  Output structure changed so that NoiseFlr is the the last output parameter.
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Sigma0, R2, NoiseFloor]  = sigma0dp(mfout, dRange, ...
    Azimuth, TxPos, DirPath, NoisePow)

%%
%%    Default input values.
%%
if nargin < 6,
    NoisePow = 0;
end

%%
%%    Convert matched filter output signal to power and scale by direct path
%%  power.  Also perform for the noise power.
%%
mfout = v2p(mfout) / DirPath;
NoisePow = NoisePow / DirPath;

%%
%%    Get ranges and angles for this azimuth and Tx position.
%%
[R1 R2 Beta] = bi_range(dRange, Azimuth, TxPos);

%%
%%    Get Tx antenna loss over look angle.
%%
TxRelLoss = lfrank2(0) ./ lfrank2(Beta);
TxRelLoss = TxRelLoss(:);

%%
%%    Compute bistatic range cell size for look angle.
%%
Ab = bi_res2(TxPos, Azimuth, R1, R2, 1/(13e-6), 6 * pi / 180);

%%
%%    Compute sigma0 for look angle.
%%
Sigma0 = 4 * pi * mfout .* TxRelLoss .* R1.^2 .* R2.^2 ./ ...
    (Ab .* abs(TxPos).^2);

NoiseFloor = 4 * pi * NoisePow .* TxRelLoss .* R1.^2 .* R2.^2 ./ ...
    (Ab .* abs(TxPos).^2);
