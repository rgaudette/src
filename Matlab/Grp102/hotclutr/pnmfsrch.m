%PNMFSRCH

Offset = [-.1:.001:0];
SLL = zeros(size(Offset));
MFCBase = CPIrp_ci(1:1651) / mean(abs(CPIrp_ci(1:1651)));
for idxOffset = 1:length(Offset),
    disp(['Offset value : ' num2str(Offset(idxOffset))]);

    MFC = conj(fft(DCSeq + Offset(idxOffset)));
    MFOut = ifft(fft(CPIrp_ra) .* MFC);
%    MFC = conj(fft(MFCBase + Offset(idxOffset)));
%    MFOut = ifft(fft(CPIrp_ci([1:1651])) .* MFC);

    MFOutPow = v2p(MFOut);

    SLL(idxOffset) = MFOutPow(1) / mean(MFOutPow(700:900));
    disp(['SLL : ' num2str(db(SLL(idxOffset)))]);

end


