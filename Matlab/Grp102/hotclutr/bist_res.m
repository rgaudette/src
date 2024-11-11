%BIST_RES	Compute the bistatic resolution cell area.
%
%    Ab = bist_res(Bw, Beam, TxPos, SampPos)
%
%    Ab		Bistatic area matrix, same form as SampPos [M^2].
%
%    Bw		Pulse bandwidth [Hertz].
%
%    Beam	Antenna beamwidth [Radians].
%
%    TxPos	Tx position relative to Rx [Meters].
%
%    SampPos	Patches to be measured [Meters].
%
%	    BIST_RES computes the bistatic resolution cell area for the
%    special case one of the antennas has a broad azimuth beamwidth or is
%    omnidirectional.  This case results is a pair of concentric ellipses
%    bounding the range limit and the beamwidth of the narrow beam antenna
%    bounding the angle extent.
%	    The parameter SampPos provides defined in complex coordinates with
%    the real opart reprenting the x direction and the imaginary part
%    representing the y direction, this format should also be used in
%    specifying the Tx position.  The size of Ab matches the size of SampPos
%    with each element of Ae representing the resolution cell area of the
%    corresponding coordinate within SampPos.
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
%  $Log: bist_res.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%     Rev 1.1   03 Aug 1993 23:33:28   rjg
%  No major changes ?
%  
%     Rev 1.0   26 Mar 1993 11:00:40   rjg
%  Initial revision.
%  
%     Rev 1.0   19 Mar 1993 15:04:44   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Ab = bist_res(Bw, Beam, TxPos, SampPos)

C = 3e8;

%%
%%    Compute the radial coordinates from Rx to target, theta is with
%%  respect to transmit position.
%%
R2 = abs(SampPos);
theta = angle(TxPos) - angle(SampPos) ;

%%
%%    Compute Tx distance to target matrix.
%%
R1 = abs(SampPos - TxPos);

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

