%DUALREG_PERF  Test the dual wavelength regularization alg.
%


%%
%%  ~1/10 scale gaussian blur 
%%
[X Y] = meshgrid(linspace(-10, 10, 200), linspace(-10, 10, 15));
var1 = 30;
A1 = exp(-1*(X-Y).^2/var1);
var2 = 35;
A2 = exp(-1*(X-Y).^2/var2);
c = 1.2;


%%
%%  Generate the vector to be reconstructed
%%
[m n] = size(A1);

x1 = zeros(n,1);
pulse = [(n/4):(3*n/4)]';
x1(pulse) = ones(size(pulse));
x2 = 1/c * x1;

%%
%%  Compute the measurements
%%
SNR = 20;
b1 = A1 * x1;
DetNoiseSTD1 = max(abs(b1)) * 10 ^ (-1 * SNR / 20);
Noise = randn(size(b1)) * DetNoiseSTD1;
bn1 = b1 + Noise;

b2 = A2 * x2;
DetNoiseSTD2 = max(abs(b2)) * 10 ^ (-1 * SNR / 20);
Noise = randn(size(b2)) * DetNoiseSTD2;
bn2 = b2 + Noise;

L = lapl1d(length(x1));

l1 = logspace(-2, 9, 60);
l2  = logspace(-2, 9, 61);
cerror = 1.0;
nL1 = length(l1);
nL2 = length(l2);
TrueErr = zeros(nL1, nL2);
MeanAbsErr = zeros(nL1, nL2);
PkAbsErr = zeros(nL1, nL2);
Xnorm = norm(x1);
Resid = zeros(nL1, nL2);
for iL1 = 1:nL1
    iL1
    for iL2 = 1:nL2

        [x1hat x2hat] = dualreg(A1, bn1, A2, bn2, cerror * c, ...
            l1(iL1), l2(iL2), L);
        Resid(iL1, iL2) = norm(A1 * x1hat - bn1);
        TrueErr(iL1, iL2) = norm(x1hat - x1) / Xnorm;
        MeanAbsErr(iL1, iL2) = mean(abs(x1hat - x1));
        PkAbsErr(iL1, iL2) = max(abs(x1hat - x1));
    end
end

%%
%%  report minimum's
%%
[val idx] = min(TrueErr);
[minTrueErr l2_mte] = min(val);
l1_mte = idx(l2_mte);
disp(['Minimum True Error: ', num2str(TrueErr(l1_mte, l2_mte)) '   l1: ' ...
        num2str(l1(l1_mte)) '   l2: ' num2str(l2(l2_mte))])

[val idx] = min(MeanAbsErr);
[minMeanAbsErr l2_mmae] = min(val);
l1_mmae = idx(l2_mmae);
disp(['Minimum MeanAbs Error: ', num2str(MeanAbsErr(l1_mmae, l2_mmae)) ...
        '   l1: 'num2str(l1(l1_mmae)) '   l2: ' num2str(l2(l2_mmae))])

[val idx] = min(PkAbsErr);
[minPkAbsErr l2_mpae] = min(val);
l1_mpae = idx(l2_mpae);
disp(['Minimum PkAbs Error: ', num2str(PkAbsErr(l1_mpae, l2_mpae)) ...
        '   l1: 'num2str(l1(l1_mpae)) '   l2: ' num2str(l2(l2_mpae))])

[val idx] = min(Resid);
[minResid l2_mresid] = min(val);
l1_mresid = idx(l2_mresid);
disp(['Minimum Resid Error: ', num2str(Resid(l1_mresid, l2_mresid)) ...
        '   l1: 'num2str(l1(l1_mresid)) '   l2: ' num2str(l2(l2_mresid))])

