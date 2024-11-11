%GETPHASE       Generate a phase correction vector for a Hot Clutter test.
%
%    [DeltaPhase PhaseStd] = getphase(CPIrp, tPulse, idxRanges, flgVerbose)
%
%    DeltaPhase     Phase rate [rads/sec].
%
%    PhaseStd       Standard deviation of the phase values.
%
%    CPIrp          CW Hot Clutter CPIrp.
%
%    tPulse         [OPTIONAL] the pulse period [seconds] (default: 3302e-6).
%
%    idxRanges      [OPTIONAL] the range gates to use for averaging the phase
%                   rate (default: 100-149).
%
%    flgVerbose     [OPTIONAL] flag to switch frequency and std dev. reporting
%                   on or off (default: 1).
%
%           GETPHASE computes the phase rate of a range-pulse CPI (CPIrp) for
%    several range gates and returns the average value.  
%
%    Calls: 
%
%    Bugs:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:30 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: getphase.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:30  rickg
%  Matlab Source
%
%  
%     Rev 1.5   15 Sep 1993 13:04:48   rjg
%  Changed frequency estimation algorithm to a least squares estiamte of phase
%  rate and intial offset phase.
%  
%     Rev 1.4   13 Sep 1993 14:32:28   rjg
%  Fixed typo: idxRange => idxRanges
%  
%     Rev 1.3   30 Aug 1993 12:13:10   rjg
%  Corrected standard deviation reporting.
%  
%     Rev 1.1   30 Aug 1993 09:46:56   rjg
%  Added default arguemnts.
%  Removed correction vector generation.
%  Report phase variance as well as offset frequency.
%  Added more comments.
%  
%     Rev 1.0   29 Aug 1993 21:01:40   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [DeltaPhase,PhaseStd] = getphase(CPIrp, tPulse, idxRanges, flgVerbose)

%%
%%    Default parameters
%%
if nargin < 4,
    flgVerbose = 1;
    if nargin < 3,
        idxRanges = [100:149];
        if nargin < 2,
            tPulse = 3302e-6;
        end        
    end
end

%%
%%    Get number of range samples and pulses
%%
[Nsamp Npulses]  = size(CPIrp);

%%
%%    Least Squares Estimate of frequency for each range gate.
%%
PhaseStep = unwrap(angle(CPIrp(idxRanges,:).'));
Time = [1:Npulses]' * tPulse;

vecLSEFreqPhase = [Time -1*ones(size(Time))] \ PhaseStep;
vecDeltaPhase = vecLSEFreqPhase(1,:); 

DeltaPhase = mean(vecDeltaPhase);
PhaseStd = std(vecDeltaPhase);

%%
%%    Let user know offset freqeuncy and standard deviation
%%
if flgVerbose,
    fprintf('    Offset frequency         : %f Hz\n', DeltaPhase / 2 / pi);
    fprintf('    Offset standard deviation : %f Hz\n', PhaseStd / 2 / pi);
end
