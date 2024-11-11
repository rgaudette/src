%%
%%  Reconstruction techniques
%%
lambda = 1.0001;
cerror = 1;
[x1hat x2hat] = dualcmin(A1, bn1, A2, bn2, cerror*c, lambda);

r = 3;
[x1lm2 x1tsvd U S V] = fatmtsvd(A1, bn1, r, lapl1d(100));
[x1lm1] = fatmtsvd(A1, bn1, r, div1d(100), 1, U, S, V);
[x2lm2 x2tsvd U S V] = fatmtsvd(A2, bn2, r, lapl1d(100));
[x2lm1] = fatmtsvd(A2, bn2, r, div1d(100), 1, U, S, V);

%%
%%  Plot results for first system
%%
orient landscape
subplot(2,1,1);
plot(x1, 'b');
hold on
set(gca, 'ylim', [-0.1 0.2]);
plot(x1hat, 'r--');
plot(x1lm2, 'g-.');
plot(x1lm1, 'k:');
plot(x1tsvd, 'c.');
hold off
xlabel('X index')
ylabel('Amplitude')
title(['x_1 and it''s reconstruction, \kappa(A_1) = '  num2str(A1_cond) ...
        '  SNR = ' num2str(SNR) '  \lambda = ' num2str(lambda)]);
Str1 = ['TSVD r=' int2str(r)];
h1 = legend('Original Seqeunce', 'Two wavelength', 'MTSVD Laplacian', 'MTSVD 1st Deriv.', Str1);

%%
%%  Plot the results for the second system
%%
subplot(2,1,2);
plot(x2, 'b');
hold on
set(gca, 'ylim', [-0.1 0.2]);
plot(x2hat, 'r--');
plot(x2lm2, 'g-.');
plot(x2lm1, 'k:');
plot(x2tsvd, 'c.');
hold off
xlabel('X index')
ylabel('Amplitude')
title(['x_2 and it''s reconstruction,  \kappa(A_2) = '  num2str(A2_cond) ...
        '  c_{error} = ' num2str(cerror)]);
h2 = legend('Original Sequence', 'Two wavelength', 'MTSVD Laplacian', 'MTSVD 1st Deriv.', Str1);
