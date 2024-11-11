%PNDOP	Doppler shift (and over sample) a PN sequence.
%
%    [DSSeq, DCSeq] = pndop(PNSeq, Vknts, Fcntr, tChip, time)
%
%    DSSeq	Doppler shifted pn sequence.
%
%    DCSeq	Non-shifted, over sampled pn sequence, provided for matched
%		filtering.
%
%    PNSeq	The pn sequence to be shifted (and over sampled)
%
%    Vknts	OPTIONAL: The object velocity (knots). default: 300.
%
%    Fcntr	OPTIONAL: The center frequency. default: 435.
%
%    tChip	OPTIONAL: The Chip period, in sample period units. default 13.
%
%    time	OPTIONAL: Specify a different sample set, (allows multiple
%		pusles & CPIs to be produced). deault: [0:1650]'.
%
%	    PNDOP simulates the velocity effect of a pn sequence transmitted
%    from a moving platform.  DSSeq represents the received sequence, DCSeq
%    is the over sampled but not doppler affected waveform for use in matched
%    filtering.
%
%    Calls: none

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:32 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: pndop.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.3   17 Mar 1993 16:10:08   rjg
%  Changed sign on complex exponential (doppler shift).
%  
%     Rev 1.2   17 Mar 1993 14:13:22   rjg
%  If time is supplied it is now forced into a column vector.  Fixed typo
%  in help header.
%  
%     Rev 1.1   10 Mar 1993 16:03:36   rjg
%  Changed doppler carrier to complex exponential.  This simulates the
%  quadrature demodualtion in the BQS section.
%  
%     Rev 1.0   10 Mar 1993 14:27:46   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [DSSeq, DCSeq] = pndop(PNSeq, Vknts, Fcntr, tChip, time)

%%  MHz, uSec
if nargin < 5,
    time = [0:1650]'; 
    if nargin < 4,
        tChip = 13;
        if nargin < 3,
 	    Fcntr = 435;
            if nargin < 2,
                Vknts = 300;
            end
	end
    end
else
    time = time(:);
end

C = 3e8;
Vel = Vknts * 1852 / 3600;   % Convert veloXcity into m/s
TimeCoef = 1 + Vel / C;      % Time dialation due to velocity

%%
%%    Compress (for closing) the PN sequence due delta range.  This also
%%  an appearent change in bandwidth or sequence period.
%%
PNIndex = TimeCoef * time / tChip;
PNIndex = rem(fix(PNIndex), length(PNSeq)) + 1;

    
%%
%%    Carrier time dialation (ie Doppler frequency shift).
%%
Doppler = exp(j * 2 * pi * Fcntr * (Vel / C) * time); 
DSSeq = PNSeq(PNIndex) .* Doppler;

%%
%%    Unshited sequence (for Matched filtering).
%%
PNIndex = time / tChip;
PNIndex = rem(fix(PNIndex), length(PNSeq)) + 1;
DCSeq = PNSeq(PNIndex);
