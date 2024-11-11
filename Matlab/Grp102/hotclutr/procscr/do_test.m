load hcpn205v1
seq = srpngen(127,7);
seq = seq * 2 -1;
[DSSeq DCSeq] = pndop(seq, 0);
DopWin = chebwgt(64,40);
BigCPI = [cpi1(:,1); cpi2(:,1); cpi3(:,1); cpi4(:,1)];
BigCPI = reshape(BigCPI, wrecord, 64);
RD1 = hcrngdop(BigCPI, DCSeq, DopWin);
RD1db = 20 *log10(abs(RD1));
max(max(RD1db))

