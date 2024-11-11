%GEN_TIME	Generate a time index for multiple pulses & CPI's.
%
%    time = gen_time(wrecord, nPulses, tCPI, tSamp)
%
%    time	Time index vector [seconds].
%
%    wrecord	Number of samples per pulse.
%
%    nPulses	The total number of pulses.
%
%    tCPI	[OPTIONAL] CPI period [seconds] (default: 3302e-6)
%
%    tSamp      [OPTIONAL] Range gate sampling period [seconds]
%               (default: 1e-6).
%
%    Calls: none

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: gen_time.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%     Rev 1.2   30 Aug 1993 11:14:16   rjg
%  Fixed help comments to note optional parameters.
%  
%     Rev 1.1   30 Aug 1993 09:36:18   rjg
%  All time parameters are know in units of seconds.
%  Sampling rate and CPI period are option parameters.
%  Comments added.
%  Time is now returned in a mtrix with the same structure as CPIrp.
%  
%     Rev 1.0   31 Mar 1993 15:18:18   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function time = gen_time(wrecord, nPulses, tCPI, tSamp)

%%
%%    Default values
%%
if nargin < 4,
    tSamp = 1e-6;
    if nargin < 3,
        tCPI = 3302e-6;
    end
end


%%
%%    Generate range gate time relative to beginning of pulse for each pulse
%%
tRangeGate = [0:wrecord-1]' * tSamp * ones(1, nPulses);

%%
%%    Generate matrix of start times for each pulse.  
%%
tPulseStart =  ones(wrecord,1) * [0:nPulses-1] * tCPI;

%%
%%    Add pulse start time and range gate offset time to get actaul range
%%    gate time relative to beggining of CPI.
%%
time = tPulseStart + tRangeGate;
