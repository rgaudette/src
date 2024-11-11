%TESTHLM
%
%  Notes: units are cm
N = 300;
step = 0.05;

%%
%%  Tapered boundary
%%
split = 3;
order = 3;
i = [-N/2:N/2];
% j1 = floor(N / split);
% j2 = floor((split-1) * N / split);
% x = [1/((step * i(j1)).^(order-1)) * ((step * i(1:j1)).^order) ...
%         step*i(j1+1:j2) ...
%         1/((step * i(j2+1)).^(order-1)) * (step*i(j2+1:N)).^order]';

%%
%%  Symmetric tapered boundary
%%
sN = floor(N / 2);
i = [1:sN];
sj2 = floor((split-1) / split * N - sN);
x = [step*i(1:sj2) ...
        1/((step * i(sj2+1)).^(order-1)) * (step * i(sj2+1:end)).^order]';
x = [rev(-x); 0; x];
j1 = sN - sj2;
j2 = sN + sj2 + 1;
%%
%% Print out the region boundaries
%%
fprintf('x min: %f\n', x(1));
fprintf('x max: %f\n', x(end));
fprintf('j1: %d\n', j1);
fprintf('x bnd1-: %f\n', x(j1)); 
fprintf('j2: %d\n', j2);
fprintf('x bnd2+: %f\n', x(j2+1)); 

%%
%%  Calculate k
%%
f = 200E6;
v = 3E10 / 1.37;
mu_sp = 10;
mu_a =  0.041;
D = v / (3 * (mu_sp + mu_a));
k = sqrt(-v * mu_a / D + j * 2 * pi * f / D)
kvec = k * ones(size(x));

%%
%%  Perturb the value of k
%%
%dk = zeros(size(k));
%dk(j1+50:j1+70) = 0.2 * k(1);
%k = k + dk;

%%
%%  Create a point source at the origin
%%
q = zeros(size(x));
idxCtr = floor(floor(length(x)/2) + 1);
q(idxCtr) = 1 / step;

%%
%%  Compute the FDFD solution
%%
phi = hlm1d_vha(x, kvec, q);

%%
%%  Compute the Green's function solution
%%
green = -j./(2*kvec) .* exp(j*kvec .* abs(x-x(idxCtr)));

figure(1)
clf
x_reg = x(j1+1:j2);
phi_reg = phi(j1+1:j2);
green_reg = green(j1+1:j2);

if isreal(kvec)
    plot(x_reg, real(phi_reg), 'r')
    hold on
    plot(x_reg, real(green_reg), 'g-.');
    axis([x(j1+1) x(j2)  min(min(real(green_reg)),min(real(phi_reg))) ...
            max(max(real(green_reg)), max(real(phi_reg)))])
else
    subplot(2,1,1)
    plot(x_reg, real(phi_reg), 'r')
    hold on
    plot(x_reg, real(green_reg), 'g-.');
    axis([x(j1+1) x(j2)  min(min(real(green_reg)),min(real(phi_reg))) ...
            max(max(real(green_reg)), max(real(phi_reg)))])
    subplot(2,1,2);
    plot(x_reg, imag(phi_reg), 'r')
    hold on
    plot(x_reg, imag(green_reg), 'g-.');
    axis([x(j1+1) x(j2)  min(min(imag(green_reg)),min(imag(phi_reg))) ...
            max(max(imag(green_reg)), max(imag(phi_reg)))])

end


if ~isreal(kvec)
    subplot(2,1,2)
    plot(x_reg, imag(phi_reg), 'r')
    hold on
    plot(x_reg, imag(green_reg), 'g-.');
    axis([x(j1+1) x(j2)  min(min(imag(green_reg)),min(imag(phi_reg))) ...
            max(max(imag(green_reg)), max(imag(phi_reg)))])
end

figure(2)
ratio = abs(green_reg ./ phi_reg);
plot(x_reg, abs(ratio))
axis([x(j1+1) x(j2) min(ratio) max(ratio)]);


figure(3)

clf
subplot(2,1,1)
plot(x, real(phi), 'r')
hold on
plot(x, real(green), 'g-.');
axis([min(x) max(x)  min(min(real(green)),min(real(phi))) ...
        max(max(real(green)), max(real(phi)))])

if ~isreal(kvec)
    subplot(2,1,2)
    plot(x, imag(phi), 'r')
    hold on
    plot(x, imag(green), 'g-.');
    axis([min(x) max(x)  min(min(imag(green)),min(imag(phi))) ...
            max(max(imag(green)), max(imag(phi)))])
end