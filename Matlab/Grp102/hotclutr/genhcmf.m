%%
%%    Pulses CW matched filter coefficients.
%%
MFC013 = conj(fft(ones(13,1), 1651));
MFC026 = conj(fft(ones(26,1), 1651));
MFC052 = conj(fft(ones(52,1), 1651));
MFC104 = conj(fft(ones(104,1), 1651));
MFC208 = conj(fft(ones(208,1), 1651));

%%
%%    PN Seqeunce matched filter coefficients.
%%
seq = srpngen(127,7, zeros(7,1), 1, 1) * 2 - 1;  %% Sequence must be +/- 1
DCSeq = pndop(seq, 0);
MFCPN = conj(fft(DCSeq));
MFCPN_mod = conj(fft(DCSeq - 1));
%clear seq DCSeq
