%LFRANK2	Basic function lfrank2.
%
%    Gain = lfrank2(Azimuth)
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
%  $Log: lfrank2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.0   04 Aug 1993 10:14:36   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Gain = lfrank2(Azimuth)

%%
%%    Create table of measured gain response (from Frank's plot).
%%
TableAz = [-180:20:180];
Table = [-54 -52.5 -49 -45 -41 -37 -32 -29 -27];
Table = [Table -26 fliplr(Table)];
Table = Table + 11.6 - max(Table);

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
