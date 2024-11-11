
n_test = 10000;
n_samples = 10000;
w_var = 3;
threshold = w_var * 1.5;

for i_test = n_test:-1:1
  g_1 = randn(n_samples, 1);
  g_3 = w_var * randn(n_samples, 1);
  
  fc_1(i_test) = sum(g_1 > threshold);
  fc_3(i_test) = sum(g_3 > threshold);
end
fprintf('w_var %f   threshold %f\n', w_var, threshold);

fprintf('fc_1 mean %f stdev %f\n', mean(fc_1), std(fc_1));
fprintf('fc_3 mean %f stdev %f\n', mean(fc_3), std(fc_3));
