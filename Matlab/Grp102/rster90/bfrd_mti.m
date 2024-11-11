%BFRD_MTI           Generate a range-Doppler map from raw RSTER-90 data,
%                   applying beamforming and clutter cancellation.
%
%    rdmap = bfrd_mti(cpi, nPulses, AzXmit, AzArray, nCancel, hPC, ...
%                     dbDopWin, nDopFFT)
%
%    rdmap          The generated range-Doppler map.
%
%    cpi            The raw range/pulse-channel CPI.
%
%    nPulses        The number of pulses present in the CPI.
%
%    AzXmit         The transmit azimuth angle [degrees].
%
%    AzArray        The azimuth of the array [degrees].
%
%    nCancel        The number of pulses to use for the canceller.
%
%    hPC            The matched filter coefficients.
%
%    dBDopWin       The doppler window SLL [db].
%
%    nDopFFT        OPTIONAL: Specifies the size of the FFT to transfrom the
%                   pulse data into the Doppler domain.
%
%    Calls: svrst90, chebwgt, convmpmc.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:38 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: bfrd_mti.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:38  rickg
%  Matlab Source
%
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rdmap = bfrd_mti(cpi, nPulses, AzXmit, AzArray, nCancel, hPC, dbDopWin, nDopFFT)

%%
%%    Initialization.
%%
ChopTransient = 1;
FrqXmit = 435e6;

%%
%%    Get initial size of CPI
%%
[nSamp nChan] = size(cpi);

%%
%%    Beamform CPI and reshape to a range-pulse CPI
%%
disp(['Electronic azimuth offset: ' num2str(AzXmit - AzArray)])
W = svrst90(nChan, AzXmit - AzArray, FrqXmit / 450e6, 3, 30);
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
if nargin < 8,
    nDopFFT = nPulses;
end
cpi = fft(cpi .* (dop_win * ones(1,nSamp)), nDopFFT);

%%
%%    Matched filter pulse, transpose s.t. each row is a doppler bin and
%%    each column is a range gate.
%%
rdmap = convmpmc(cpi.', hPC, 1, ChopTransient);
rdmap = rdmap.';
