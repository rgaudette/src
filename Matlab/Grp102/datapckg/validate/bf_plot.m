%BF_PLOT            Plot the output of the beamformer.
%
%    bf_plot(cpi, nPulses, iPulse, trecord, muxtype, FXmit, ...
%            MissDesc, Angle, Config, Window, SLL, flgPrintFile) 
%
%    cpi            The RSTER CPI to look at.
%
%    nPulses        The number of pulses in the CPI.
%
%    iPulse         The pulse to plot.
%
%    trecord        The start of the record window.
%
%    muxtype        The type of data in CPI, this is used to appropriately
%                   scale the data for a SNR plot. [1=ADC, 2=BQS, 3=EQU].
%
%    FXmit          The transmitter frequency [Hertz].
%
%    MissDesc       A description of the data being plotted, becomes part of
%                   the plot title.
%    
%    Angle          The squint angle of the beamformer [degrees].
%
%    Config         The RSTER configuration ['rster' | 'rster-90', | 'e2c']
%                   this is not case sensitive, trailing blanks will be removed.
%
%    Window         The data window to use for the beamformer;
%                       0 - Uniform
%                       1 - Hamming
%                       2 - Hanning
%                       3 - Chebyshev
%                       4 - Kaiser-Bessl
%
%    SLL            The data window sidelobe level, some value needed even if
%                   the window does not take a parameter.
%
%    flgPrintFile   Send plot to printer or Encapsulated PostScript file.
%
%        BF_PLOT  plots the beamformer output for a single pulse of the
%    given CPI.
%         If flgPrintFile is 0 the plots are only displayed on the screen.  If
%    flgPrintFile is 1 the plot is sent to the default printer.  If flgPrintFile
%    is a string the plots are sent to a set of EPS files.  The names of these
%    files are given by the string along with a '_bfout' and a single digit.
%
%
%    Calls: svrster, svrst90.
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
%  $Log: bf_plot.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:26  rickg
%  Matlab Source
%
%  
%     Rev 1.2   03 May 1994 11:07:46   rjg
%  EPS file changed to color.
%  
%     Rev 1.1   25 Mar 1994 10:27:12   rjg
%  Removed trailing blanks from config string and changed rster90
%  to rster-90 to match John's AMDF stuff.
%  
%     Rev 1.0   18 Mar 1994 18:04:08   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bf_plot(cpi, nPulses, iPulse, trecord, muxtype, FXmit, ...
                 MissDesc, Angle, Config, Window, SLL, flgPrintFile)

%%
%%    Default values
%%
if muxtype == 2,
    AmplitudeOffset = 47.4;
else
    AmplitudeOffset = 0;
end

if nargin < 12
    flgPrintFile = 0;
end
if isstr(flgPrintFile),
    PrintFile = flgPrintFile;
    flgPrintFile = 2;
end

FCntrArray = 435E6;

%%
%%    Extract structure sizes
%%
[nSamp nCh] = size(cpi);
wrecord = nSamp / nPulses;
idxRange = [((iPulse - 1) * wrecord + 1) : (iPulse * wrecord)];
RangeGates = [trecord:trecord+wrecord-1];

%%
%%    Generate beamformer coefficients
%%
if strcmp(lower(deblank(Config)), 'rster'),
    W = svrster(nCh, Angle, FXmit / FCntrArray, Window, SLL);
end
if strcmp(deblank(lower(Config)), 'rster-90'),
    W = svrst90(nCh, Angle, FXmit / FCntrArray, Window, SLL);
end

%%
%%    Compute output of beamformer in terms of SNR and find peak.
%%
if muxtype > 1,
    BFOut = db(v2p(cpi(idxRange,:) * conj(W))) - AmplitudeOffset;
else
    BFOut = db(v2p(dbqs(cpi(idxRange,:)) * conj(W))) - AmplitudeOffset;
end

[Peak idxPeak] = max(BFOut);
idxPeak = rem(idxPeak+1, wrecord) + trecord -1 ;

%%
%%    Plot beamformer output
%%
clf
plot(RangeGates, BFOut)
if Peak > 50,
    axis([trecord trecord+wrecord-1 -10 100])
else
    axis([trecord trecord+wrecord-1 -10 50])
end
grid

%%
%%    Set size for three ring binder and label plot
%%
set(gca, 'Position', [0.13 0.11 0.775 0.73]);

xlabel('Range Gate');

ylabel('Amplitude (dB)')

strWindow = ['Uniform      '
             'Hamming      '
             'Hanning      '
             'Chebyshev    '
             'Kaiser-Bessel'];

title([MissDesc ' Pulse #' int2str(iPulse) ...
    '  Squint Angle:' num2str(Angle) ...
    '  ' num2str(SLL) ' dB ' strWindow(Window+1,:) ...
    '  Peak=' num2str(Peak) ' dB @ RG ' int2str(idxPeak)]);

%%
%%    Create axes for top title
%%
hAxes = axes('Position', [0.13 0.11 0.775 0.78]);
set(hAxes, 'Visible', 'off');

if muxtype == 2,
    title('Beamformer Output SNR');
else
    title('Beamformer Output');
end

if flgPrintFile == 2,
    print('-depsc', [PrintFile '_bfout'])
elseif flgPrintFile == 1,
    print
end
