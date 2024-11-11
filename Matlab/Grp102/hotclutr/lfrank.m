%LFRANK         Little frank azimuth pattern model.
%
%    Gain = lfrank(Azimuth)
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
%  $Log: lfrank.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.2   04 Aug 1993 10:06:38   rjg
%  Changed cosine back to cosine squared.
%  
%     Rev 1.1   04 Aug 1993 10:04:50   rjg
%  Added comments and correct help section to read radians instead of degrees
%  for input azimuth.
%  
%     Rev 1.0   03 Aug 1993 23:42:42   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Gain = lfrank(Azimuth)

%%
%%    Compress azimuth for cosine squared argument
%%
k = Azimuth * 45 / 38.5;

%%
%%    Find where k is > pi /2, only need one cycle for azimuth pattern
%%  other cycle is considered backlobe.  Replace these values with pi /2.
%%
[az_index ] = find(abs(k) > pi/2);
k(az_index) = pi / 2 * ones(size(az_index));

%%
%%    Cosine squared model for mainlobe.
%%
Gain = cos(k).^2;

%%
%%    Scale gain up to neccessary value.
%%
Gain = Gain * 10 .^ (11.6 / 10);

%%
%%    Model backlobe (and sidelobes) as a constant value.
%%
GainMin = 10 .^ (-28 / 10);
sl_index = find(Gain < GainMin);
Gain(sl_index) = GainMin * ones(size(sl_index));
