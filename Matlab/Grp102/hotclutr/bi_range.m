%BI_RANGE       Compute bistatic range parameters R1, R2 and Tx angle from
%               delta range, and Tx position.
%
%    [R1 R2 Beta] = bi_range(Delta, Azimuth, TxPos)
%
%    R1         Range from Tx to patch.
%
%    R2         Range from patch to Rx.
%
%    Beta       Angle from Tx-Rx axis to patch [radians]
%
%    Delta      Delta range vector, the difference between the direct path
%               range and the patch bistatic range.
%
%    TxPos      Transmitter position relative to receiver.
%
%    Azimuth    Pointing direction of receiver relative to north [degrees].
%
%      BI_RANGE returns the ranges from the the transmitter to patch and patch
%  to receiver given the delta range Rx antenna azimuth and transmitter
%  position.  Also the angle from the baseline (rx-tx line of sight) to the
%  patch is given.  The units of R1 & R2 will be the same as that of Delta.
%
%    Calls: az2pol.
%
%    Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: bi_range.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%     Rev 1.1   08 Dec 1993 17:11:24   rjg
%  Uses az2pol to get polar angle of transmitter, computes Beta by law of cosines
%  
%     Rev 1.0   03 Aug 1993 23:29:54   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [R1, R2, Beta] = bi_range(Delta, Azimuth, TxPos)

%%
%%    Compute baseline range to transmitter and baseline receiver angle
%%
AzPolar = az2pol(Azimuth);
TxRange = abs(TxPos);
theta = AzPolar - angle(TxPos);

%%
%%    Compute R2 for all delta ranges.
%%
R2 = (Delta.^2 + 2 * Delta * TxRange) ./ ...
    (2 * (Delta + TxRange - TxRange * cos(theta)));

%%
%%    Compute R1, range from Tx to patch
%%
R1 = Delta + TxRange - R2;

%%
%%    Compute bistatic angle
%%
Beta = acos((R2.^2 + R1.^2 - TxRange.^2) ./ (2 .* R2 .* R1));
