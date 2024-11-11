%MTSVD_TEST     Test the MTSVD algorithm.
%


%%
%%  Generate the forward matrix
%%

%%
%%  Gaussian blur
%%
%[X Y] = meshgrid(([1:100]-50)*2, [1:200]-100);
%var = 100;
%A = exp(-1*(X-Y).^2/var);
%%
%%  Generate the vector to be reconstructed
%%
x = [1:40  40*ones(1,20) 40:-0.5:20.5]';

%%
%%  Underdetermined Gaussian blur
%%
[X Y] = meshgrid([1:200]-100, ([1:100]-50)*2);
var = 100;
A = exp(-1*(X-Y).^2/var);
x = [zeros(1,20) 10*ones(1,40) zeros(1,20) 1:20 20*ones(1,50) 20:-0.5:-4.5]';

[U S V] =svd(A);
sigma = diag(S);
sigma(1)/sigma(length(sigma))

b = A * x;
SNR = 20;
PeakDataPwr = max(abs(b));
NoisePwr = PeakDataPwr * (10 ^ (-SNR / 20))
Noise = randn(size(b)) * NoisePwr;
bn = b + Noise;

[xlm50 xtsvd50] = fatmtsvd(A, bn, 50, lapl1d(length(x)), 1.0, U, S, V);
xls = (A'*A) \ A' * bn;