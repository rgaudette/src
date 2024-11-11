%
%
ROI = [-3 3];
step = 0.01;
nBnd = 10;


[x J] = polybnd1(ROI, step, nBnd, order);
y = x;

%%
%%  Calculate k
%%
f = 0E6;
v = 3E10 / 1.37;
mu_sp = 10;
mu_a =  0.041;
D = v / (3 * (mu_sp + mu_a));
k = sqrt(-v * mu_a / D + j * 2 * pi * f / D)

kvec = k * ones(length(y), length(x));

%%
%%  Perturbations to k
%%
%dk = zeros(size(k));
%dk(j1+50:j1+70) = 0.2 * k(1);
%k = k + dk;

%%
%%  Create a point source at the origin
%%
q = zeros(size(kvec));
xCtr = floor(length(x)/2);
yCtr = floor(length(y)/2);
q(yCtr, xCtr) = 1 / step^2;


%%
%%  Compute the FDFD solution
%%
[phi] = hlm2d_vh(x, y, kvec, q);

%%
%%  Compute the Green's function solution
%%
[mX mY] = meshgrid(x-x(xCtr), y-y(yCtr));
r = sqrt(mX.^2 + mY.^2);
green = -1./(2*r) .* (pi./2 * j .* (besselj(0, j.*kvec .* r)+j.*bessely(0,j.*kvec .* r)));

figure(1)
clf
subplot(2,2,1)
mesh(x(j1+1:j2), y(j1+1:j2), -1*real(phi(j1+1:j2,j1+1:j2)))

subplot(2,2,2)
mesh(x(j1+1:j2), y(j1+1:j2), -1*real(green(j1+1:j2,j1+1:j2)))

subplot(2,2,3)
mesh(x(j1+1:j2), y(j1+1:j2), imag(phi(j1+1:j2,j1+1:j2)))

subplot(2,2,4)
mesh(x(j1+1:j2), y(j1+1:j2), imag(green(j1+1:j2,j1+1:j2)))

% subplot(2,1,2)
% plot(x, imag(phi), 'r')
% hold on
% plot(x, imag(green), 'g-.');
% axis([x(j1+1) x(j2)  min(imag(green)) max(imag(green))])

% figure(2)
% ratio = abs(green(j1+1:j2) ./ phi(j1+1:j2));
% plot(x(j1+1:j2), abs(ratio))
% axis([x(j1+1) x(j2) min(ratio) max(ratio)]);
