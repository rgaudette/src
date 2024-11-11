%DECREC1P       Perform a single level decomposition/reconstruction.
%
function [rec, a1, d1] = decrec1p(x, hApp, hDet)

M = length(hApp);


%%
%%  Mirror the trailing end of the signal
%%
N = length(x)
%x = [x rev(x(N-M+2:N))];


%%
%%  Convolve the sequence with the Approximation and Detail filters
%%
%%
a1 = filter(rev(hApp), 1, [x 0 0 0]);
d1 = filter(rev(hDet), 1, [x 0 0 0]);
a1 = a1(M:length(a1));
d1 = d1(M:length(d1));
size(a1)
size(d1)
%%
%%  Zero every other sample in a1 & d1, this is equivalent to decimating and
%%  expanding the sequence by two.
%%
A1 = zeros(size(a1));
D1 = zeros(size(d1));
A1(2:2:length(A1)) = a1(1:2:length(a1));
D1(2:2:length(D1)) = d1(1:2:length(d1));

%%
%%  Mirror the coefficents
%%
nInterp = length(A1);
%A1 = [A1 rev(A1(nInterp-M+2:nInterp))];
%D1 = [D1 rev(D1(nInterp-M+2:nInterp))];

%%
%%  Filter with the app/detl filters
%%
f1 = filter(hApp, 1, A1);
f2 = filter(hDet, 1, D1);

%%
%%  Remove beginning transients due to filter function
%%
f1 = f1([1:length(f1)]);
f2 = f2([1:length(f2)]);
rec = f1 + f2;

