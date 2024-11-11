%RHO           Compute the reflection coefficient of a bistatic scattering
%              signal.
%
%    [Rho Range] = rho(mfout, dRange, Azimuth, TxPos, TxPow)
%
%    Rho       The aggregate reflection coefficient for each sample of mfout.
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
%
%    Calls: bi_range2, lfrank2.
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
%  $Log: rho.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Rho, R2] = rho(mfout, dRange, Azimuth, TxPos, TxPow)

%%
%%    Convert Tx power into watts
%%
TxPow = 10^(TxPow / 10) / 1000;
%%
%%    Compute ranges and bistatic resolution cell area.
%%
[R1 R2 Beta] = bi_range(dRange, Azimuth, TxPos);

%%
%%    Compute Tx antenna gain.
%%
Gt = lfrank2(Beta);

%%
%%    Compute relative E field value at Tx antenna in direction of patch.
%%
E_Tx = sqrt(TxPow * Gt);
%%
%%    Compute reflection coefficient for each cell
%%
Rho = mfout .* (4*pi).^2 .* R1 .* R2 ./ E_Tx;
    
