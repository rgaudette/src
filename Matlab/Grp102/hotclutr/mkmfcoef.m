MFpcw13 = conj(fft(ones(13,1), 512));
MFpcw26 = conj(fft(ones(26,1), 512));
MFpcw52 = conj(fft(ones(52,1), 512));
MFpcw104 = conj(fft(ones(104,1), 512));
MFpcw208 = conj(fft(ones(208,1), 512));

pn = srpngen(127,7);
DCseq = pndop(pn,0);
MFpn001 = conj(fft(DCSeq(1:512)));
MFpn002 = conj(fft(DCSeq(513:1024)));
MFpn003 = conj(fft(DCSeq(1025:1563)));
MFpn004 = conj(fft(DCSeq(1040:1651)));

re = real(MFpcw13);
im = imag(MFpcw13);
cmplx = [ re im];
save HC_MFpcw13 cmplx -ascii
re = real(MFpcw26);
im = imag(MFpcw26);
cmplx = [ re im];
save HC_MFpcw26 cmplx -ascii
re = real(MFpcw52);
im = imag(MFpcw52);
cmplx = [ re im];
save HC_MFpcw52 cmplx -ascii
re = real(MFpcw104);
im = imag(MFpcw104);
cmplx = [ re im];
save HC_MFpcw104 cmplx -ascii
re = real(MFpcw208);
im = imag(MFpcw208);
cmplx = [ re im];
save HC_MFpcw208 cmplx -ascii
re = real(MFpn001);
im = imag(MFpn001);
cmplx = [ re im];
save HC_MFpn001 cmplx -ascii
re = real(MFpn002);
im = imag(MFpn002);
cmplx = [ re im];
save HC_MFpn002 cmplx -ascii
re = real(MFpn003);
im = imag(MFpn003);
cmplx = [ re im];
save HC_MFpn003 cmplx -ascii
re = real(MFpn004);
im = imag(MFpn004);
cmplx = [ re im];
save HC_MFpn004 cmplx -ascii
