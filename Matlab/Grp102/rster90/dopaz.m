%DOPAZ              Generate a Doppler-azimuth matrix for a specific range gate
%
function mDopAz = dopaz(cpi, nPulses, idxRG, dbDopWin, dbAzWin)

[nSamp nChan] = size(cpi);
nRG = nSamp / nPulses;

idxRange = [0:nPulses-1] * nRG + idxRG;

mPulseChan = cpi(idxRange,:);


%%
%%    FFT Down Pulse index to transform to Doppler domain.
%%
mDopWin =  diag(chebwgt(nPulses, dbDopWin));
mDopAz = fft(mDopWin * mPulseChan, 64);

%%
%%    Transpose and FFT down Channel to Azimuth domain
%%
mAzWin =  diag(chebwgt(nChan, dbAzWin));
mDopAz = fft(mAzWin * mDopAz.', 64);


