%DUALCMIN_TEST  Test the dual wavelength constant ratio alg.
%


%%
%%  Generate the forward matrix
%%

%%
%%  Gaussian blur
%%
[X Y] = meshgrid(([1:100]-50), [1:10:100]-50);
var1 = 1600;
A1 = exp(-1*(X-Y).^2/var1);
var2 = 1500;
A2 = exp(-1*(X-Y).^2/var2);
c = 1.2;
SNR = 20;

%%
%%  Generate the vector to be reconstructed
%%
x1 = zeros(100,1);
x1(21:40) = 0.1;
x1(41:45) = 0.15;
x1(60:62)= 0.12;
ramp = linspace(0.01,0.11,5)';
x1(76:80) = ramp;
x1(81:85) = flipud(ramp);
x2 = 1/c * x1;

b1 = A1 * x1;
Pwr = sqrt((b1' * b1) / 100);
NoisePwr = Pwr / (10 ^ (SNR / 10))
Noise = randn(size(b1)) * NoisePwr;
bn1 = b1 + Noise;

b2 = A2 * x2;
Pwr = sqrt((b2' * b2) / 100);
NoisePwr = Pwr / (10 ^ (10 / 10))
Noise = randn(size(b2)) * NoisePwr;
bn2 = b2 + Noise;

lambda = 0;
cerror = 1.0;
[x1hat x2hat] = dualcmin(A1, bn1, A2, bn2, cerror * c, lambda);
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
        '  SNR = ' num2str(SNR) '  \lambda = ' num2str(lambda)]);

subplot(2,1,2);
plot(x2, 'b');
hold on
plot(x2hat, 'r--');
hold off
xlabel('X index')
ylabel('Amplitude')
title(['x_2 and it''s reconstruction,  \kappa(A_2) = '  num2str(A2_cond) ...
        '  c_{error} = ' num2str(cerror)]);