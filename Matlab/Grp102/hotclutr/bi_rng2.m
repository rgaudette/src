%BI_RNG2        Compute the bistatic range and angle parameters given the
%               radial range from the receiver, the receiver azimuth and the
%               transmitter position.
%
%    [Delta, R1, Beta, Phi] = bi_rng2(R2, Azimuth, TxPos);
%
%    Delta      The bistatic delta range.
%
%    R1         The range from the transmitter to the cell.
%
%    Beta       The bistatic angle [radians].
%
%    Phi        The angle from the transmitter-receiver line-of-site to the
%               transmitter patch line-of-site [radians].
%
%    R2         The radial range from the receiver.
%
%    Azimuth    The receiver azimuth angle w.r.t. north [degrees].
%
%    TxPos      The transmitter position in x-y coordinates, complex format.
%
%	    BI_RNG2 computes the remaining parameters of the triangle given
%    the radial range from the receiver, the receiver azimuth, and the
%    transmitter position.  R2 and TxPos should be the same units,  R1 and
%    Delta will also be in those units.  If R2 is a vector the triangle
%    paramters will be computed for each element of R2.  The law of cosines is
%    used to compute the angle Beta.
%
%    Calls: az2pol
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: bi_rng2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%     Rev 1.1   08 Dec 1993 17:10:04   rjg
%  Completed all computation of all output variables.
%  
%     Rev 1.0   08 Dec 1993 15:38:54   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Delta, R1, Beta, Phi] = bi_rng2(R2, Azimuth, TxPos);

%%
%%    Convert the receiver azimuth angle to a polar angle.
%%
AzPolar = az2pol(Azimuth);

%%
%%    Compute the X and Y coordinates for each cell.
%%
CellPos = R2 * cos(AzPolar) + j * R2 * sin(AzPolar);
R1 = abs(TxPos - CellPos);
Rd = abs(TxPos);

%%
%%    Compute bistatic delta range
%%
Delta = R1 + R2;

%%
%%    Compute bistatic angle
%%
Beta = acos((R2.^2 + R1.^2 - Rd.^2) ./ (2 .* R2 .* R1));

%%
%%    Compute transmiter to cell angle
%%
Phi = rem(pi - AzPolar + angle(TxPos) - Beta, 2*pi);