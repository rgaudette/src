lambda = 1;
ant_scale = 0.5;
l = ant_scale * lambda;
a_scale = 1e-2;
a = a_scale * lambda;
k = 2 * pi / lambda;
nElems = 21;
z = linspace(-l/2, l/2, nElems);
I = mom1d_imn(k, a, l, nElems);
V = zeros(nElems,1);
V(ceil(nElems/2)) = 1;
Iz = I \ V;

subplot(2,1,1)
plot(z, abs(Iz))
set(gca, 'xlim', [min(z) max(z)])
grid
xlabel('Z axis')
ylabel('Current Magnitude (Amps / meter)');
title([num2str(ant_scale) ' \lambda Antenna,  a = ' num2str(a_scale) '\lambda,   nPoints = ' int2str(nElems) ])
subplot(2,1,2)
plot(z, phase(Iz))
grid
axis([min(z) max(z) -pi pi])
xlabel('Z axis')
ylabel('Current Phase (radians)');
