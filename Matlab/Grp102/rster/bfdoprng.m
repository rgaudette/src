%BFDOPRNG       Generate the beamformed range-Doppler map for a CPI by first
%               perfming Doppler filtering before range compression.
%
%    rdmap = bfdoprng(cpi, nPulses, W, hPC, dbDopWin)
%
%    rdmap      The generated range-Doppler map.
%
%    cpi
%
%	    Describe function, it's methods and results.
%
%    Calls: none.
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
%  $Log: bfdoprng.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:37  rickg
%  Matlab Source
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rdmap = bfdoprng(cpi, nPulses, W, hPC, dbDopWin)

ChopTransient = 1;
dop_win = chebwgt(nPulses, dbDopWin);

[nSamp, nChan] = size(cpi);

cpi_bf = cpi * conj(W);

cpi_rp = reshape(cpi_bf, nSamp / nPulses, nPulses);

[nSamp nFFT] = size(cpi_rp);

cpi_rp = fft(cpi_rp.' .* (dop_win * ones(1,nSamp)));

rdmap = convmpmc(cpi_rp.', hPC, 1, ChopTransient);

rdmap = rdmap.';


