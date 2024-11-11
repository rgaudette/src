%DECREC1        Perform a single level decomposition/reconstruction.

function [rec, a1, d1] = decrec1(x, hApp, hDet)

%%
%%  Convolve the sequence with the Approximation and Detail filters
%%
%%
a1 = conv(x, hApp);
d1 = conv(x, hDet);

%%
%%  Subsample each of the coefficient sequences by two
%%
a1 = a1([2:2:length(a1)]);
d1 = d1([2:2:length(d1)]);

%%
%%  Interpolate with zeros the coefficient sequences
%%
A1 = zeros(1,length(a1)*2);
D1 = zeros(1,length(d1)*2);
A1(1:2:length(A1)) = a1;
D1(1:2:length(D1)) = d1;

%%
%%  Filter with the app/detl filters
%%
f1 = conv(rev(hApp), A1);
f2 = conv(rev(hDet), D1);

%%
%%  Remove beginning transients due to filter function
%%
%f1 = f1([length(hApp)-1:length(f1)]);
%f2 = f2([length(hDet)-1:length(f2)]);
rec = f1 + f2;

