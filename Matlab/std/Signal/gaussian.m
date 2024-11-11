%gaussian       Generate a gaussian pulse
%  y = gaussian(x, mu, sigma)

function y = gaussian(x, mu, sigma)

y = exp(- ((x - mu) / sigma).^2);
