%CHRDRESP           Compute the response of a given range-Doppler cell for
%                   each channel individually.
%
%    [Resp] = chrdresp(cpi, nPulses, tdcMF, idxRange, idxDoppler)
%
%    Resp           The amplitude and phase response of each channel for the
%                   specified cell.
%
%    cpi            A RSTER Time-Channel CPI.
%
%    nPulses        The number of pulses present in the CPI.
%
%    tdcMF          The matched filter time domain coefficients.
%
%    idxRange       The range index to observe.
%
%    idxDoppler     The doppler index to observe.
%
%
%        CHRDRESP generates a range-Doppler map for each and returns the
%    response for the specified range and doppler cell.
%
%    Calls: bfrngdop.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:26 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: chrdresp.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:26  rickg
%  Matlab Source
%
%  
%     Rev 1.0   21 Mar 1994 16:29:02   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Resp] = chrdresp(cpi, nPulses, tdcMF, idxRange, idxDoppler)

%%
%%    Initialization
%%
nChannels = 14;
DopplerWindB = 50;
Resp = zeros(1,nChannels);

%%
%%    For each channel generate a range-Doppler map and select the
%%    required range-Doppler cell.
%%
for idxCh = 1:nChannels,
    rdmap = bfrngdop(cpi(:,idxCh), nPulses, 1, tdcMF, DopplerWindB);
    Resp(idxCh) = rdmap(idxDoppler, idxRange);
end
