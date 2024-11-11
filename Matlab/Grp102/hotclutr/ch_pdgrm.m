%CH_PDGRM       Perform a periodogram for each channel.
%
%    ch_pdgrm(strFileName, wrecord, CPI_mc1, CPI_mc2, CPI_mc3, CPI_mc4,
%         flgPrint);
%
%    strFileName    A string containing the filename, used in the title.
%
%    wrecord        The number of range gates per pulse.
%
%    CPI_mc1-4      The raw BQS or EQU channel data.
%
%    flgPrint       [OPTIONAL] If set the plots will be sent to the printer
%                   (default: 1).
%
%	  CH_PDGRM performs a periodogram over all range gates present.  It
%    requires 4 CPIS (designed for the Hot Clutter recording).  The FFT's
%    are performed for each range gate over all of the pulses.  The mean
%    is then taken for each doppler bin (power) over all range gates.
%
%    NOTE: The FFT scale factor is,
%
%        1 / (sqrt(mean(v2p(hamming(nPulses)))) * sqrt(nPulses))
%
%    (this the rms value of the window) this make the energy in the spectrum
%    equal to the energy in the signal.
%
%    Calls: v2p, db.
%
%    Bugs: Axis scaling for plot is not constant.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: ch_pdgrm.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%     Rev 1.1   27 Oct 1993 11:14:12   rjg
%  Added appropriate scaling for signal energy estimation and optional printing.
%  
%     Rev 1.0   01 Sep 1993 17:26:38   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ch_pdgrm(strFileName, wrecord, CPI_mc1, CPI_mc2, CPI_mc3, CPI_mc4, ...
                  flgPrint);

%%
%%    Default values
%%
if nargin < 7,
    flgPrint = 1;
end

%%
%%    Create Hamming weight matrix.
%%
[nSamps nChannels] = size(CPI_mc1);
nPCPI = nSamps / wrecord;
nPulses = 4 * nPCPI;
matHam = hamming(nPulses) * ones(1, wrecord);
FFTScale = 1 / (sqrt(mean(v2p(hamming(nPulses)))) * sqrt(nPulses));

%%
%%    Loop over each channel
%%
for idxCH = 1:nChannels,

    %%
    %%    Create a range-pulse CPI for the current channel
    %%
    CPIrp = bigcpi(wrecord, idxCH, CPI_mc1, CPI_mc2, CPI_mc3,CPI_mc4);

    %%
    %%    Compute the periodogram for the Hamming weighted range-pulse
    %%    CPI.  The FFT's are performed over pulse.
    %%
    Period = mean(v2p((fft(CPIrp.' .* matHam).') * FFTScale));
    disp(['ch: ' int2str(idxCH) '   ' num2str(db(mean(Period))) 'dB'])
    disp(' ')
    %%
    %%    Send the result to the printer
    %%
    clf
    plot(db(Period));
    axis([0 64 45 50])
    xlabel('Doppler Bin')
    ylabel('Amplitude (dB)')
    title([strFileName ': Channel ' int2str(idxCH) ...
        ' Periodogram, Hamming Weighted, ' int2str(wrecord) ' Range Gates']);
    grid
    tag
    drawnow

    if flgPrint,
        print
    end

end
