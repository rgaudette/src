mu_a = 0.01;
mu_sp = 10;
nu = 3E10 / 1.37;
D = nu / (3 * (mu_sp + mu_a));
f = 0;
w = 2 * pi * f;
k_out = sqrt(-nu*mu_a/D + j*w/D)
x = [-2.55:.1:2.55]';
nDet = length(x);
rDet = [x zeros(size(x)) -2*ones(size(x))];
rSrc = [0 0 -2];

%%
%%  Calculate the incident field from the exponential expression
%%
exp_inc = zeros(nDet, 1);

for i = 1:nDet
    r_dist = norm(rSrc - rDet(i,:));
    exp_inc(i) = -1/(4*pi*r_dist) * exp(j*k_out*r_dist);
end


subplot(2,1,1)
plot(x, exp_inc);
title('Amplitude')

subplot(2,1,2)
plot(x, angle(exp_inc)* 180/pi)
title('Phase')