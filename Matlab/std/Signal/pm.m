%PM              Phase modulator.
%
%    y = pm(m, k, fc)
%
%    y      The phase modulated signal.
%
%    m      The message signal to represent.
%
%    k      The phase modulation ratio (in radians/unit of m).
%
%    fc     The center frequency of the modulator.

function y = pm(m, k, fc)
n = [0:length(m)-1];
y = cos(2 * pi * fc * n + k * m);
