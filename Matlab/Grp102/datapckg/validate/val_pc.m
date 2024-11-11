%VAL_PC         Perform pulse compression on a range-pulse CPI
%
%    CPIrp = val_pc(CPIrp, tPulseWidth)
%
%    CPIrp      The pulse compressed CPI in range-pulse format.
%
%    tPulseWidth The pulse width of the transmitted pulse [seconds].
%
%
%        VAL_PC pulse compresses the input range-pulse CPI using a matched
%    filter.
%
%    Calls: gethpc, convmpmc.
%
%    Bugs: This function assumes that if the pulse width is less than 50
%          microseconds it is PCW, if it is greater or equal it is 
%          LFM.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:27 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: val_pc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:27  rickg
%  Matlab Source
%
%  
%     Rev 1.0   02 May 1994 20:20:28   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function CPIrp = val_pc(CPIrp, tPulseWidth)

%%
%%    Initialization and default parameters
%%
       FilterType = 1;
     LFMBandWidth = 500e3;
     BQSTransient = 6;
    flgSimulation = 0;
 flgChopTransient = 1;


%%
%%    Generate the time domain matched filter function
%%        - if the pulse width is 50 microseconds or longer assume its
%%          LFM otherwise it's PCW.
%%
if tPulseWidth < 50E-6,
    hPC = ones(tPulseWidth * 1e6, 1);
else
    nFIR = tPulseWidth / 1e-6 + 2 * BQSTransient;
    hPC = ifft(gethpc(FilterType, tPulseWidth, LFMBandWidth, nFIR, ...
                      flgSimulation));
end

%%
%%    Check to see if the matched filter will produce any steady state response
%%
nPC = length(hPC);
[nRanges nPulses] = size(CPIrp);

if nPC > nRanges,
    disp('WARNING: No steady state response from matched filter.');
    disp('\tNo matched filtering perfomed.');
    return
end
%%
%%    Convolve the range-pulse CPI and the pulse compression filter
%%
CPIrp = convmpmc(CPIrp, hPC, 1, flgChopTransient);