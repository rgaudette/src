%RAWCHPLT           Plot the SNR of all 14 channels unprocessed.
%
%    rawchplt(cpi, nPulses, iPulse, trecord, MissDesc, flgPrintFile)
%
%    cpi            The RSTER CPI to look at.
%
%    nPulses        The number of pulses in the CPI.
%
%    iPulse         The pulse to plot.
%
%    trecord        The start of the record window.
%
%    MissDesc       A description of the data being plotted, becomes part of
%                   the plot title.
%
%    flgPrintFile   Send plot to printer or Encapsulated PostScript file.
%
%        RAWCHPLT plots the amplitude relative to an assumed noise level of
%    the raw CPI data.  Each page has 4 plots thus for a standard RSTER CPI
%    the plots are displayed on 4 and a half pages.  The X axis is given in
%    range gate index.  MissDesc is included into the title of each page.  The
%    peak SNR for each channel and the range gate at which this occurs is given
%    in the title of each plot.  If flgPrintFile is 0 the plots are only
%    displayed on the screen.  If flgPrintFile is 1 the plot is sent to the
%    default printer.  If flgPrintFile is a string the plots are sent to a
%    set of EPS files.  The names of these files are given by the string along
%    with a '_raw' and a single digit.
%
%    Calls: mchplt.
%
%    Bugs: none.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:26 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rawchplt.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:26  rickg
%  Matlab Source
%
%  
%     Rev 1.3   02 May 1994 14:58:42   rjg
%  Moved plotting functions to a seperate function. This will
%  be used by other routines also.
%  
%  
%     Rev 1.2   21 Mar 1994 16:37:26   rjg
%  Simple help description fixes.
%  
%     Rev 1.1   18 Mar 1994 15:54:56   rjg
%  Title is now on a seperate line, file printing is correctly
%  handled.
%  
%     Rev 1.0   18 Mar 1994 15:08:36   rjg
%  Initial revision.
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rawchplt(cpi, nPulses, iPulse, trecord, MissDesc, flgPrintFile);

%%
%%    Default values
%%
flgPeak = 1;

if nargin < 6,
    flgPrintFile = 0;
end

if isstr(flgPrintFile),
    flgPrintFile = [flgPrintFile '_raw'];
end

%%
%%    Extract structure sizes
%%
[nSamp nCh] = size(cpi);
wrecord = nSamp / nPulses;
idxRange = [((iPulse - 1) * wrecord + 1) : (iPulse * wrecord)];
RangeGates = [trecord:trecord+wrecord-1];

%%
%%    Extract the required data from the CPI.
%%
SNR = db(v2p(cpi(idxRange,:)));

%%
%%    Plot labels
%%
XLabel = 'Range Gate';
YLabel = 'Amplitude (dB)';
Title = [MissDesc ' Pulse #' int2str(iPulse) ':  Raw channel SNR'];

%%
%%    Call the plotting function
%%
mchplt(SNR, RangeGates, [trecord trecord+wrecord-1 -10 90], Title, XLabel, YLabel, ...
    flgPrintFile, flgPeak);
