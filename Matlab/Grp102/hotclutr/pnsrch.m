

len = length(pn);
best_pksl = 0;
PN512 = fft(pn,512);
for start = 1:len,
    mfidx = start:start+mflen-1;
    mfidx = rem(mfidx, mflen);
    if any(mfidx == 0),
	mfidx(find(mfidx == 0 )) = mflen;
    end

    mfout = 20*log10(abs(ifft(PN512 .* conj(fft(pn(mfidx))))));
   [val pkidx] = peak_srch(mfout, 1);

    peak = max(val);

    val = val - peak;
    val = val(find(val < 0));
    pksl = max(val);
    disp(['Start: ' int2str(start) '   Sidelobe :' num2str(pksl)]);
    if pksl < best_pksl,
	best_pksl = pksl;
	best_start = start;
    end

end