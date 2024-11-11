%BFRNGDOP       Generate the beamformed range-Doppler map for a CPI.
%
%    rdmap = bfrngdop(cpi, nPulses, W, hPC, dbDopWin)
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
%  $Log: bfrngdop.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:37  rickg
%  Matlab Source
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rdmap = bfrngdop(cpi, nPulses, W, hPC, dbDopWin)

ChopTransient = 1;

[nSamp, nChan] = size(cpi);

cpi_bf = cpi * conj(W);

cpi_rp = reshape(cpi_bf, nSamp / nPulses, nPulses);

cpi_pc = convmpmc(cpi_rp, hPC, 1, ChopTransient);

[nSamp nChan] = size(cpi_pc);

dop_win = chebwgt(nPulses, dbDopWin);

rdmap = fft(cpi_pc.' .* (dop_win * ones(1,nSamp)));
