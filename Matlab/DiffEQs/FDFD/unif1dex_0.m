%
%
ROI = [-3 3];
step = 0.01;
nBnd = 10;


order = 1;
[x J] = polybnd1(ROI, step, nBnd, order);
x = x(:);
%%
%% Print out the region boundaries
%%
%     fprintf('x min: %f\n', x(1));
%     fprintf('x max: %f\n', x(end));
%     fprintf('J(1): %d\n', J(1));
%     fprintf('x bnd1-: %f\n', x(J(1)-1)); 
%     fprintf('J(2): %d\n', J(2));
%     fprintf('x bnd2+: %f\n', x(J(2)+1)); 

%%
%%  Calculate k
%%
f = 0E6;
v = 3E10 / 1.37;
mu_sp = 10;
mu_a =  0.041;
D = v / (3 * (mu_sp + mu_a));
k = sqrt(-v * mu_a / D + j * 2 * pi * f / D)

kvec = k * ones(size(x));

%%
%%  Create a point source at the origin
%%
q = zeros(size(x));
[junk idxCtr] = min(abs(x));
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
set(1, 'DefaultAxesFontSize', 16)
x_reg = x(J(1):J(2));
phi_reg = phi(J(1):J(2));
green_reg = green(J(1):J(2));

%%
%%  Calculate the errors
%%
err = green_reg - phi_reg;
mse = mean(abs(err).^2);
peakerr = max(abs(err));
fprintf('Mean square error: %e\n', mse);
fprintf('Peak value error: %e\n\n\n', peakerr);

%%
%%  Plot the FDFD and Green's calculations
%%
h = plot(x_reg, real(phi_reg), 'r');
set(h, 'LineWidth', 3)
hold on
h = plot(x_reg, real(green_reg), 'g-.');
set(h, 'LineWidth', 3)

%axis([x(J(1)) x(J(2)) -.5 0]);
xlabel('Distance (cm)');
ylabel('Amplitude');
title(['Uniformly sampled domain  MSE: ' num2str(mse)  '  PAE: ' ...
        num2str(peakerr) ]);
hl = legend('FDFD', 'Green''s');


%%
%%  Plot the error as a function of space
%%
figure(2)
clf
set(2, 'DefaultAxesFontSize', 16)
h = plot(x_reg, real(err), 'r');
set(h, 'LineWidth', 3)
hold on
%axis([x(J(1)) x(J(2)) -5e-3 0])
ylabel('Error');
xlabel('Distance (cm)');
title('Error vs. Distance')
