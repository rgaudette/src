% domain
i = [0:256];
nI = length(i);

% test sequences
step = zeros(size(i)) ;
step(i>nI/2) = 1;

pulse2 = zeros(size(i));

idxPulse = [floor(nI/2):floor(nI/2)+1];
pulse2(idxPulse) = 1;

% additive noise
stdDev = 0.1;
noise = stdDev * randn(size(i));

testStep = xMembrane3';
i = 0:length(testStep)-1;

nDecomp = 3;
wavelet = 'sym8';

[decomp, idxDecomp] = wavedec(testStep, nDecomp, wavelet);

figure(1)
clf
subplot(2,1,1)
plot((abs(decomp)))
hold on
scaleBoundaries = cumsum(idxDecomp(1:end-1));
idxStart=1;
for iSc = 1:length(scaleBoundaries)
  std(decomp(idxStart:scaleBoundaries(iSc)))
  idxStart = scaleBoundaries(iSc) + 1;
end
yRange = get(gca, 'ylim');
yRange = repmat(yRange', 1, length(scaleBoundaries));
size(yRange)

size([scaleBoundaries; scaleBoundaries])
plot([scaleBoundaries; scaleBoundaries], yRange, 'k');
grid on

threshFunction = 'sqtwolog';
weight = 5;
th = thselect(decomp, threshFunction) * weight

threshold = std(decomp(scaleBoundaries(end-1)+1:end)) * weight

plot(get(gca,'xlim'), [threshold threshold], 'r')
select = abs(decomp) > threshold;

tDecomp = select .* decomp;

den = waverec(tDecomp, idxDecomp, wavelet);
subplot(2,1,2);
plot(i, testStep);
hold on
plot(i, den, 'r');

% Filter the fourier coeffiecients to smooth the discontinuities

fselect = conv([0.2 0.6 0.2], select);
fselect = fselect([2:end-1]);
ftDecomp = fselect .* decomp;

fden = waverec(ftDecomp, idxDecomp, wavelet);

%figure(2)
%clf
%subplot(2,1,1)
%plot(i, testStep);
%hold on
plot(i, fden, 'g');
