%BI_RES2        Compute bistatic resoution cell area given ranges to cell,
%               transmitter position, azimuth beamwidth and bandwidth.
%
%    Ab = bi_res2(TxPos, Azimuth, R1, R2, Bw, Beam)
%
%    Ab         Bistatic resolution cell area [meters^2].
%
%    TxPos      Transmitter position relative to Rx [meters].
%
%    Azimuth    Pointing direction of receiver relative to north [degrees].
%
%    R1         Range from Tx to patch [meters].
%
%    R2         Range from patch to Rx [meters].
%
%    Bw         Pulse bandwidth [Hertz].
%
%    Beam       Antenna beamwidth [Radians].
%
%      BI_RES2 returns the bistatic resolution cell in meters^2.  It uses a
%  closed form solution to compute the area, this requires that one of the
%  antenna omni-directional or have a wide aziumth beamwidth.
%
%    Calls: biarintf
%
%    Bugs:  Returns negative area for a SampPos that generates a theta close
%		to pi.
%
%    REF:	An Exact Expression For Resolution Cell Area In Special
%		Case Of Bistatic Radar Systems.
%		IEEE Trans. On Aerospace And Electronic Systems
%		Vol. 25, NO. 4 July 1989  pp 584-587

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: bi_res2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%     Rev 1.0   03 Aug 1993 23:30:20   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Ab = bi_res2(TxPos, Azimuth, R1, R2, Bw, Beam)

C = 3e8;

%%
%%    Convert Azimuth to rectangular cooridnate angle.
%%
theta = -pi / 180 * (Azimuth - 90) - angle(TxPos);

%%
%%    Range, eccentriciy calculation for each position.
%%
a1 = 0.5 * (R1 + R2);
a2 = a1 + C / (2 * Bw);
e1 = abs(TxPos) ./ (2 * a1);
e2 = abs(TxPos) ./ (2 * a2);

%%
%%    Compute closed form area function.
%%
theta1 = theta - Beam / 2;
theta2 = theta + Beam / 2;
k1 = a1 .* (1 - e1 .^ 2);
k2 = a2 .* (1 - e2 .^ 2);

Ab = k2 .^ 2 .* (biarintf(e2, theta2) - biarintf(e2, theta1)) - ...
     k1 .^ 2 .* (biarintf(e1, theta2) - biarintf(e1, theta1));

