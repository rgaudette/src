clf
threshold = 1
x = [-5:.01:5];
g_dist = gaussian(x, 0, 2.0);
plot(x, g_dist, 'linewidth', 2);
hold on

b_dist = gaussian(x, 3, 1.0);
plot(x, b_dist, 'r', 'linewidth', 2);
yrange = get(gca, 'ylim');
plot([threshold threshold], yrange, 'g--', 'linewidth', 2)
x_thresh_idx = find(x > threshold);
plot(x(x_thresh_idx), g_dist(x_thresh_idx), 'g', 'linewidth', 2);
legend('good joint distribution', 'defective joint distribution', 'threshold', 'false call region');
