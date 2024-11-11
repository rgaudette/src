%LFM             LFM signal generator.
%
%    y = lfm(n, k, fc)
%
%    y      The phase modulated signal.
%
%    n      The sample index.
%
%    k      The product of the modulation ratio & LFM rate / 2.
%
%    fc     The center frequency of the modulator.

function y = lfm(n, k, fc)
y = cos(2 * pi * fc * n + k * n.^2);
