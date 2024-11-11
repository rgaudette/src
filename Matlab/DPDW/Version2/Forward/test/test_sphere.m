
pObj = [0 0 0];
pSrc = [0 0 -2];
x = [-5.05:0.1:5.05]';
nDet = length(x);
pDet = [x zeros(nDet, 1), -2 * ones(nDet, 1)];

f = 0E6;
w = 2 * pi * f; 
nu = 3E10 / 1.37;
mu_sp = 10;
mu_a = 0.05;
delta_mu_a = 0.05;
opBack.mu_sp = mu_sp;
opBack.mu_a = mu_a;
opSphere.mu_sp = mu_sp;
opSphere.mu_a = mu_a + delta_mu_a;

radius = 0.5;

l = 2;


%%
%%  My version of the spherical harmonic code
%%
phi_scat = dpdw_sphere_nb(pSrc, pDet, w, nu, opBack, opSphere, radius, l);


%%
%%  Tom's version of the spherical harmonic code
%%
r_src = struct('x', pSrc(1), 'y', pSrc(2), 'z', pSrc(3));
r_det = struct('x', pDet(1,1), 'y', pDet(1,2), 'z', pDet(1,3));
r_obj = struct('x', pObj(1), 'y', pObj(2), 'z', pObj(3), 'radius', radius);
back = struct('mu_a', mu_a, 'mu_s', mu_sp,'w', w, 'v', nu, 'S_AC',1);
obj = struct('mu_a', mu_a + delta_mu_a, 'mu_s', mu_sp, 'w', w, 'v', nu);

analytic_scat = zeros(length(x), 1);
for c = 1:nDet
    r_det.x = pDet(c,1);
    tom_scat(c) = aforward2(r_src, r_det, r_obj, back, obj, l, l);
end


%%
%%  Computational volume for born approximation, just needed around object
%%
CompVol.XStep = radius/10;
CompVol.YStep = CompVol.XStep;
CompVol.ZStep = CompVol.XStep;
CompVol.X = [pObj(1)-radius:CompVol.XStep:pObj(1)+radius];
CompVol.Y = [pObj(2)-radius:CompVol.YStep:pObj(2)+radius];
CompVol.Z = [pObj(3)-radius:CompVol.ZStep:pObj(3)+radius];
CompVol.Type = 'uniform';

%%
%%  Generate Born-1 matrix
%%
[A born_inc] = dpdwfdda(CompVol, mu_sp, mu_a, nu, f, pSrc, pDet);

%%
%%  Generate object function
%%
objfct = gensphere1(CompVol, pObj, radius, delta_mu_a);

born_scat = A * objfct(:);

%%
%%  Load the PMI results
%%
load sphcntr200.dat

pmi_tot = sphcntr200(:,7) .* exp(j*sphcntr200(:,8)*pi/180);
pmi_inc = sphcntr200(:,9) .* exp(j*sphcntr200(:,10)*pi/180);

pmi_scat = pmi_tot - pmi_inc;

figure(1)
clf
subplot(2,1,1)
semilogy(x, abs(phi_scat));
hold on
semilogy(x, abs(tom_scat), 'c')
semilogy(x, abs(born_scat), 'r')
semilogy(sphcntr200(:,4), abs(pmi_scat), 'g')
xlabel('X position (cm)')
ylabel('Amplitude')
title('Scattered Field Amplitude Comparison')
legend('My spherical code', 'Tom''s spherical code', 'Born', 'PMI')

subplot(2,1,2)
plot(x, angle(phi_scat)*180/pi)
hold on
plot(x, angle(tom_scat)*180/pi, 'c')
plot(x, angle(born_scat)*180/pi, 'r')
plot(sphcntr200(:,4), angle(pmi_scat)*180/pi, 'g')
xlabel('X position (cm)')
ylabel('Phase (degrees)')
title('Scattered Field Amplitude Comparison')
legend('My spherical code', 'Tom''s spherical code', 'Born', 'PMI')

figure(2)
clf
subplot(2,1,1)
plot(abs(phi_scat) ./ abs(born_scat));
title('Amplitude Ratio')

subplot(2,1,2)
plot((angle(phi_scat) - angle(born_scat)) * 180 ./ pi);

figure(3)
clf
subplot(2,1,1)
plot(abs(tom_scat') ./ abs(born_scat));
title('Amplitude Ratio')

subplot(2,1,2)
plot((angle(tom_scat') - angle(born_scat)) * 180 ./ pi);
