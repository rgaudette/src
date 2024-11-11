%MSCALE         Mallat decomposition scaling coefficients.
%
%   Coeff = mscale;
%
%   MSCALE returns the coefficients necessary to scale the detail sequences of
%   a Mallat decomposition such that a decomposed step sequence has the same
%   maxima in each detail seqeunce.  This assumes the following filters were
%   used,
%       Detail: 0, 2, -2, 0
%       Smooth: 1/8, 3/8, 3/8, 1/8

function Coeff = mscale

Coeff = [1 4/3 16/11 64/43 256/171 1024/683];

