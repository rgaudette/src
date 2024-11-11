%BFMTIDOPRNG    Generate the range-Doppler map for a CPI applying a 2 pulse
%               MTI canceller.
%
%    rdmap = bfmtidoprng(cpi, nPulses, nCancel,  W, hPC, dbDopWin, nDopFFT)
%
%    rdmap      The generated range-Doppler map.
%
%    cpi        The raw range/pulse-channel CPI.
%
%    npulses    The number of pulses present in the CPI.
%
%    nCancel    The number of pulses to use for the canceller.
%
%    W          The beamformer coefficients.
%
%    hPC        The matched filter coefficients.
%
%    dBDopWin   The doppler window SLL [db].
%
%    nDopFFT    OPTIONAL: Specifies the size of the FFT to transfrom the
%               pulse data into the Doppler domain.
%
%	    BFMTIDOPRNG perfoms basic MTI signal processing for RSTER CPI.
%    First, the CPI is beamformed using the conjugate of the coeffiecients
%    provided in W.  Next, the data is run through a N pulse canceller.
%    The remaining pulse data is then Fourier Tranformed into the Doppler
%    domain and each bin is matched filtered using the coefficients provided
%    in hPC.  If nDopFFT is specified the number of Doppler cell will modified
%    accordingly.
%
%    Calls: chebwgt, convmpmc.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:37 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: bfmtidop.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:37  rickg
%  Matlab Source
%
%  
%     Rev 1.1   23 Feb 1994 14:52:50   rjg
%  Filled in description.
%  Now uses only a single variable to hold the different stages of processing.
%  This speeds up processing and minimizes memory usage.
%  
%     Rev 1.0   23 Feb 1994 14:02:20   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rdmap = bfmtidoprng(cpi, nPulses, nCancel, W, hPC, dbDopWin, nDopWin)

%%
%%    Initialization.
%%
ChopTransient = 1;

%%
%%    Get initial size of CPI
%%
[nSamp nChan] = size(cpi);

%%
%%    Beamform CPI and reshape to a range-pulse CPI
%%
cpi = cpi * conj(W);
cpi = reshape(cpi, nSamp / nPulses, nPulses);
[nSamp nFFT] = size(cpi);

%%
%%    Perfrom pulse cancellation using the specified number of pusles
%%    and Jim's cancellation code.
%%
cpi = npulsec(cpi.', nCancel);
[nPulses nSamp] = size(cpi);

%%
%%    Doppler processing
%%
dop_win = chebwgt(nPulses, dbDopWin);
if nargin < 7,
    nDopWin = nPulses;
end
cpi = fft(cpi .* (dop_win * ones(1,nSamp)), nDopWin);

%%
%%    Matched filter pulse, transpose s.t. each row is a doppler bin and
%%    each column is a range gate.
%%
rdmap = convmpmc(cpi.', hPC, 1, ChopTransient);
rdmap = rdmap.';
