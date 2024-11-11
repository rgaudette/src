%DECREC1P       Perform a single level periodized decomposition/reconstruction.
%
%   THIS WORKS !!!!!
function [rec, a1, d1] = decrec1p(x, hApp, hDet)

M = length(hApp);
N = length(x);

%%
%%  Periodize X
%%
x = [x x(1:M-1)];


%%
%%  Convolve the sequence with the Approximation and Detail filters
%%
%%
a1 = filter(rev(hApp), 1, x);
d1 = filter(rev(hDet), 1, x);

%%
%%  Subsample each of the coefficient sequences by two
%%
a1 = a1([M:2:length(a1)]);
d1 = d1([M:2:length(d1)]);

%%
%%  Interpolate with zeros the coefficient sequences
%%
A1 = zeros(1, length(a1)*2);
D1 = zeros(1, length(d1)*2);
A1(1:2:N-1) = a1;
D1(1:2:N-1) = d1;

%%
%%  PERIODIZE the coefficents
%%
nInterp = length(A1);
A1 = [A1(nInterp-M+2:nInterp) A1];
D1 = [D1(nInterp-M+2:nInterp) D1];

%%
%%  Filter with the app/detl filters
%%
f1 = filter(hApp, 1, A1);
f2 = filter(hDet, 1, D1);

%%
%%  Remove beginning transients due to filter function
%%
f1 = f1([M:length(f1)]);
f2 = f2([M:length(f2)]);
rec = f1 + f2;

