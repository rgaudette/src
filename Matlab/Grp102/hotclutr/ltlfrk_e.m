%LTLFRK_EL	Little frank elvation pattern
%
%    Gain = lear_el(Elevation)
%
%    Gain       The gain of the antenna corresponding to the Elevation vector
%               [linear].
%
%    Azmiuth    The elevations at which to compute the gain [radians]
%
%    Calls: none
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
%  $Log: ltlfrk_e.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.0   27 Oct 1993 11:05:48   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Gain = lear_el(Elevation)

%%
%%    Create table of measured gain response.
%%
TableAz = [-38 -35 -30 -24.5 -20 -14 -9 -4.5 1 6 9 20 29];
Table = [-60 -43 -36 -32 -29.2 -27.6 -26.6 -26.4 -26.7 -27.9 -29.2 -40 -55];

Table = Table - max(Table) + 11.6;

%%
%%    Convert TableAz into radians for interpolation.
%%
TableAz = TableAz * pi / 180;

%%
%%    Perform cubic spline interpolation of data table.
%%
Gain = interp1(TableAz, Table, Elevation, 'spline');

%%
%%    Convert gain to linear to be compatible with lfrank.m
%%
Gain = 10 .^ (Gain / 10);

