function showpair(good, bad, idx1, idx2)
lw = 2;
clf
plot(good(:, idx1), good(:, idx2), 'og', 'linewidth', lw);
hold on
plot(bad(:, idx1), bad(:, idx2), 'xr', 'linewidth', lw);
plot([-0.45 -0.45], [-1 0.5], 'k--', 'linewidth', lw);
plot([-1 0.5], [-0.6 -0.6], 'k--', 'linewidth', lw);
axis([-1 0.5 -1 0.5])
grid on
xlabel('Feature 1')
ylabel('Feature 2')
