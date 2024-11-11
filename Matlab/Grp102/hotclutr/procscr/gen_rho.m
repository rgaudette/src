az = '200';
azidx = 6;
freq = [4348 4350 4352 4354];
pol = ['H' 'V'];
for ifrq = 1:4,
    for ipol = 1:2,
        eval(['rho' int2str(freq(ifrq)) pol(ipol) az '=rho(mMFOut' ...
        int2str(freq(ifrq)) pol(ipol) '(:,azidx), dRange, 200, TxPos, TxPow); ']);
    end
end
