%WTCOMP         Compare wavelet transforms of a signal
%
%   wtcomp(signal, idxsignal, Edge)

function wtcomp(signal, idxsignal, Edge)

if nargin < 3,
    Edge = 'zero';

    if nargin < 2,
        idxsignal = [1:length(signal)];
    end
end

clf
subplot(2,2,1)
plot(idxsignal,signal, 'c')
axis([min(idxsignal) max(idxsignal) min(signal) max(signal)])
grid
xlabel('Time')
ylabel('Amplitude')

subplot(2,2,2)
[hqspl gqspl] = wfc_qspl;
wt_cmap(signal, hqspl*sqrt(2), gqspl*sqrt(2), Edge, 0)
xlabel('Time')
ylabel('Scale')
title('Quadratic Spline Wavelet Representation')
grid

subplot(2,2,3)
[hd4 gd4] = wfc_d4;
wt_cmap(signal, hd4, gd4, Edge, 0)
grid
xlabel('Time')
ylabel('Scale')
title('D4 Wavelet Representation')

subplot(2,2,4)
[hd8 gd8] = daubechi(4);
wt_cmap(signal, hd8, gd8, Edge, 0)
grid
xlabel('Time')
ylabel('Scale')
title('D8 Wavelet Representation')

subplot(2,2,1);
