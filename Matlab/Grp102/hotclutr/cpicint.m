%CPICINT        Coherently integrate a CPIrp.
%
%    IntOut = cpicint(CPIrp)
%
%    IntOut     The integrator output.
%
%    CPIrp      The coherent processing interval matrix to be integrated
%               in range-pulse format.
%
%        CPICINT performs a coherent integration of range-pulse CPI.  The
%    ouput is normalized by the number of pulses.
%
%    Calls: none
%
%    Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: cpicint.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%     Rev 1.1   30 Aug 1993 10:29:28   rjg
%  Input structure is now a CPIrp instead of a CPImc.
%  Made code more efficient.
%  
%     Rev 1.0   03 Aug 1993 23:37:38   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function IntOut = cpicint(CPIrp);

%%
%%    Get total number of samples and number of channels.
%%
[nSamples nPulses] = size(CPIrp);

%%
%%    Rotate CPIrp so that a range gate occupies a specific column, sum over
%%    pulses.  Transpose result so that output is a column vector.
%%
IntOut = sum(CPIrp.').' ;

%%
%%    Normalize to original signal level.
%%
IntOut = IntOut / nPulses;