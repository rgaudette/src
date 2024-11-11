%LEAR_ANT	Basic function lear_ant.
%
%    Gain = lear_ant(Azimuth)
%
%    Gain       The gain of the antenna corresponding to the Azimuth vector
%               [linear].
%
%    Azmiuth    The azimuths at which to compute the gain [radians]
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
%  $Log: lear_ant.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.0   27 Sep 1993 21:01:14   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Gain = lear_ant(Azimuth)

%%
%%    Create table of measured gain response (from Frank's plot).
%%
TableAz = [-180:15:180];
Table = [-10 -10 -10 -10 -5 -2.5 -2.0 0 1.5 3.5 6.0 6.0 6.5 ...
         6.0 5.5 4.5 2.5 0 -3 -7.5 -9.0 -10 -10 -10 -10 ];

%%
%%    Convert TableAz into radians for interpolation.
%%
TableAz = TableAz * pi / 180;

%%
%%    Perform cubic spline interpolation of data table.
%%
Gain = interp1(TableAz, Table, Azimuth, 'spline');

%%
%%    Convert gain to linear to be compatible with lfrank.m
%%
Gain = 10 .^ (Gain / 10);

