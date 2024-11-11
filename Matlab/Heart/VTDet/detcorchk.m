%DETCORCHK      Check the correlation between detail sequences
%
ECG  = barnvt;
nWindow = 64;
iScale = 1;
[hApp hDet] = wfc_d4;

%%
%%  Find the r waves in the beat use this as an alignment index
%%
idxR = rwavedet(mkegstrct(ECG));
if idxR(1) < nWindow / 2
    idxR = idxR(2:length(idxR));
end
if(length(ECG) - idxR(length(idxR))) < nWindow / 2
    idxR = idxR(1:length(idxR)-1);
end

matSeq = zeros(length(idxR), nWindow / (2^iScale));

for iRwave = 1:length(idxR)
    idxWindow = [idxR(iRwave)-nWindow/2:idxR(iRwave)+nWindow/2-1];
    [w scmap] = dwtz(ECG(idxWindow), hApp, hDet, iScale);
    matSeq(iRwave, :) = GetDetIdx(scmap, iScale, w)';
end
