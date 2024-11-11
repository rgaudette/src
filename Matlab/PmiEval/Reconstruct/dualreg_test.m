%DUALREG_TEST  Test the dual wavelength regularization alg.
%


%%
%%  Generate the forward matrix
%%

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
l1 = 10.0;
l2  = 100000.0;
cerror = 1.0;

[x1hat x2hat] = dualreg(A1, bn1, A2, bn2, cerror * c, l1, l2, L);

A1_cond = cond(A1);
A2_cond = cond(A2);


orient landscape
subplot(2,1,1);
plot(x1, 'b');
hold on
plot(x1hat, 'r--');
hold off
xlabel('X index')
ylabel('Amplitude')
title(['x_1 and it''s reconstruction, \kappa(A_1) = '  num2str(A1_cond) ...
        '  SNR = ' num2str(SNR) '  \lambda_1 = ' num2str(l1) ...
        '  \lambda_2 = ' num2str(l2) ]);

subplot(2,1,2);
plot(x2, 'b');
hold on
plot(x2hat, 'r--');
hold off
xlabel('X index')
ylabel('Amplitude')
title(['x_2 and it''s reconstruction,  \kappa(A_2) = '  num2str(A2_cond) ...
        '  c_{error} = ' num2str(cerror)]);