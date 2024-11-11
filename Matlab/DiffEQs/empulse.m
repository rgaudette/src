%EMPULSE

%%
%%  Fixed parameters
%%
eps_o = 8.854333E-12;
mu_o = 4 * pi * 1E-7;
C = 1 / sqrt(mu_o * eps_o);
dt = 1E-6
dz = 2 * dt * C
nZ = 1000;
nT = 2000;

%%
%%  Computational domain (position of E field eval).
%%
z = [0:nZ-1] * dz;

%%
%%  Media parameters as a function of space
%%
eps_z = [ones(1,nZ/2) 4 * ones(1, nZ/2)] * eps_o;

%%
%%  Initial E/H fields
%%
W = 60 * dz;
zo = 4 * W;

Ex = exp(-1 * ((z - zo) / W).^2);
Hy = sqrt(eps_o / mu_o) * exp(-1 * ((z - zo - C * dt/2) / W) .^ 2);

%%
%%  Setup the plotting display
%%
tTotal = nT * dt;
clf
h = plot(z, Ex);
set(h, 'Erasemode', 'xor');
hold on
plot([z(nZ/2) z(nZ/2)], [-1.25 1.25], '--r', 'LineWidth', 2);
% title(['t = ' num2str(i* dt * 1e6) 'uS of ' num2str(tTotal * 1E6) ' uS']);
axis([0 max(z) -1.25 1.25]);
drawnow;

%%
%%  E field subplot array
%%
figure(2);
clf
subplot(3,3,1)
orient landscape
plot(z, Ex);
hold on
grid on
plot([z(nZ/2) z(nZ/2)], [-1.25 1.25], '--r', 'LineWidth', 2);
axis([0 max(z) -1.25 1.25]);
title(['t = ' num2str(dt * 1e6) 'uS ']);

%%
%%  H field subplot array
%%
figure(3);
clf
subplot(3,3,1)
orient landscape
plot(z, Hy);
hold on
grid on
plot([z(nZ/2) z(nZ/2)], [-1.25/377 1.25/377], '--r', 'LineWidth', 2);
axis([0 max(z) -1.25/377 1.25/377]);
title(['t = ' num2str(dt * 1e6) 'uS ']);

jp = 2;
%%
%%  Loop over alternating E and H field computation
%%
for i = 1:nT
    %%
    %%  Compute the E field first ...
    %%
    Ex =  -1 * dt/dz * eps_z.^-1 .* [Hy(1) diff(Hy)] + Ex;
    if rem(i,10) == 0
        set(h, 'Ydata', Ex);
    end
    
    %%
    %% then compute the H field
    %%
    Hy = -1/mu_o * dt/dz * [diff(Ex) -1*Ex(nZ)] + Hy;
    if (rem(i, nT/10) == 0) & jp < 10
        %%
        %%  E field subplot array
        %%
        figure(2);
        subplot(3,3,jp)
        plot(z, Ex);
        hold on
        grid on
        plot([z(nZ/2) z(nZ/2)], [-1.25 1.25], '--r', 'LineWidth', 2);
        axis([0 max(z) -1.25 1.25]);
        title(['t = ' num2str(i* dt * 1e6) 'uS ']);

        %%
        %%	H field subplot array
        %%
        figure(3);
        subplot(3,3,jp)
        plot(z, Hy);
        hold on
        grid on
        plot([z(nZ/2) z(nZ/2)], [-1.25/377 1.25/377], '--r', 'LineWidth', 2);
        axis([0 max(z) -1.25/377 1.25/377]);
        title(['t = ' num2str(i* dt * 1e6) 'uS ']);
        
        jp = jp + 1;
    end

end

