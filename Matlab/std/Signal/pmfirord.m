%PMFIRORD       Compute order estimates of a Parks-McClellan FIR filter.
%
%   [Kaiser Herrmann] = pmfirord(delta1, delta2, transw)
%
%   Kaiser      The Kaiser approximation.
%
%   Herrmann    The Herrmann approximation.
%
%   delta1      The passband error (total error 1+delta1 -> 1-delta1).
%
%   delta2      The stopband error.
%
%   transw      The transition width, normalized to unit frequency range.
%
%       PMFIRORD computes both the Kaiser and Herrmann order approximations
%   for a Parks-McClellan Equiripple FIR filter.  The Herrmann approximation
%   appears to be the more accurate of the pair.
%
%       If delta2 is a negative number both delta1 and delta2 are assumed to
%   be in dB.  Otherwise delta1 and delta2 are assumed to be in linear units.
%   The passband error is always supplied as 1+delta1 -> 1-delta1, which for
%   the dB case is an approximation since these numbers have different
%   magnitudes when specified in dB.
%
%   See also: REMEZ
%
%   Ref: Digital Signal Processing, Proakis and Manolakis 2nd Ed. pg 618.

function [Kaiser, Herrmann] = pmfirord(delta1, delta2, transw)

%%
%%  Check to see if the errors are given in dB or linear units
%%
if delta2 < 0,
    delta2 = 10^(delta2 / 20);
    delta1 = 10^(delta1 / 20) - 1;
end

Kaiser = (-20*log10(sqrt(delta1 * delta2)) - 13) / (14.6*transw) + 1;


dinf = (0.005309*log10(delta1)^2 + 0.07114*log10(delta1) - 0.4761) * ...
       log10(delta2) - ...
       (0.00266*log10(delta1)^2 + 0.5941*log10(delta1) + 0.4278);

fd1d2 = 11.012 + 0.51244*(log10(delta1) - log10(delta2));

Herrmann = (dinf - fd1d2 * transw^2) / transw + 1;

