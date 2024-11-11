%HCRNGDOP	Compute range-doppler matrix from raw Hot Clutter  pulse data.
%
%    RD = hcrngdop(PulseData, MatchedFilter, DopplerWindow, flgUnDop, ...
%         CPILength, nDopFFT)
%
%    RD			Range doppler matrix (NRanges x NDopplers).
%
%    PulseData		Raw, equalized pulse data (NRanges x NPulses)
%
%    MatchedFilter	Freq. domain matched filter coefficients (NRanges x 1).
%
%    DopplerWindow	Pulse-Doppler transform data window (NPulses x 1).
%
%    flgUnDop		OPTIONAL: If non-zero the doppler shift for each
%			will be multiplied out by exp(-j2pi (mn/K)), the
%			negative of the frequency of the doppler bin.
%			Default: 0.
%
%    CPILength		OPTIONAL: The length of a CPI for removing the doppler
%			modulation of each doppler bin, in units of the range
%			sampling interval.  Default: 3302.
%
%    nDopFFT		OPTIONAL: The size of the Doppler FFT to use. 
%			Default: number of columns in PulseData.
%
%	    HCRNGDOP first computes the circular cross correlation function of
%    each column with the matched filter coefficients provided.  The length of
%    the matched filter must equal the number of range gates in PulseData. Next
%    each row is windowed with DopplerWindow and Fourier transformed to produce
%    Doppler information.  The length of DopplerWindow must equal nDopFFT.  If
%    flgUnDop is true each doppler bin is multiplied by its conjugate phase
%    along each range vector, this removes the phase progression over range
%    cells.
%
%    Calls: fft

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:32 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: hcrngdop.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.0   03 Aug 1993 23:41:58   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function RD = hcrngdop(PulseData, MatchedFilter, DopplerWindow, flgUnDop, ...
	CPILength, nDopFFT)

%%
%%    Vector size error checking
%%
[nRanges nPulses] = size(PulseData);
if nRanges ~= length(MatchedFilter),
    error('Matched filter length incorrect');
end
if nPulses ~= length(DopplerWindow),
    error('Doppler data window length incorrect');
end

if nargin < 6,
    nDopFFT = nPulses;
    if nargin < 5,
        CPILength = 3302;
        if nargin < 4,
	    flgUnDop = 0;
        end
    end
end

%%
%%    Correct size of MatchedFilter coef & DopplerWindow
%%
MF = MatchedFilter / length(MatchedFilter);
DopplerWindow = DopplerWindow(:);

%%
%%    Replicate doppler window for each range gate (now columns).
%%
DW_mat = DopplerWindow * ones(1,nRanges);

%%
%%    Transpose PulseData so that the pulse index corresponds to rows for FFT.
%%    Transform from pulse domain to doppler.
%%
RD = fft(PulseData.' .* DW_mat, nDopFFT);

%%
%%    If un-doppler processing is requested.
%%
if flgUnDop,
    idxDopBin = [0:nDopFFT-1]';
    idxRngBin = [0:nRanges-1];
    matUnDop = exp((j * 2 * pi / CPILength / nDopFFT) *...
	idxDopBin * idxRngBin);
    RD = RD .* matUnDop;
end

%%
%%    Transpose RD back to range index corresponds to rows.
%%    Transform pulse data columns (individual doppler bins) for XCF
%%
RD = fft(RD.');

%%
%%    Replicate MF coefficients for each RD pulse
%%
MF_mat = MF * ones(1, nDopFFT);

%%
%%    Matched filter each column (FREQ domain), convert back to time domain.
%%
RD = ifft(RD .* MF_mat);
