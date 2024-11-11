%VELCMP       Compare velocity signals

function velcmp(Signal1, Signal2, szArray, vLeadID)
idxLead = (vLeadID(2) - 1) * szArray(1) + vLeadID(1);
velSig1 = abs(Signal1(idxLead, :));
velSig2 = abs(Signal2(idxLead, :));

idxNZSig1 = find(velSig1 > 0);
idxNZSig2 = find(velSig2 > 0);

idxStart = min([idxNZSig1(:);idxNZSig2(:)]);
idxStop = max([idxNZSig1(:);idxNZSig2(:)]);


plot(velSig1, 'b');
hold on
plot(velSig2, 'r');
hold off

%%
%%  Zoom in axis
%%
vAxis = axis;
vAxis(1) = idxStart-1;
vAxis(2) = idxStop+1;
axis(vAxis);

grid
xlabel('Sample Index');
ylabel('Velocity');
title([int2str(vLeadID(1)) ',' int2str(vLeadID(2))]);

%%
%%  Compute some stats on the non-zero portion of each signal
%%
meanSig1 = mean(velSig1(idxNZSig1));
stdSig1 = std(velSig1(idxNZSig1));
nSig1 = length(idxNZSig1);

meanSig2 = mean(velSig2(idxNZSig2));
stdSig2 = std(velSig2(idxNZSig2));
nSig2 = length(idxNZSig2);

strSig1 = ['Mean: ' num2str(meanSig1) '  Std: ' num2str(stdSig1) '  N: ' int2str(nSig1)];
strSig2 = ['Mean: ' num2str(meanSig2) '  Std: ' num2str(stdSig2) '  N: ' int2str(nSig2)];

legend(strSig1, strSig2);
