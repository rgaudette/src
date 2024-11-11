%%
%%  Medium and measurement parameters.
%%
mu_sp = 10;
mu_a = 0.05;
nu = 3e10/1.3;
f = 200E6;
w = 2 * pi * f;

%%
%%  Object position and size
%%
pObj = [0 0 0];
radObj = 0.5;
delta_mu_a = 0.01;

%%
%%  Source position
%%
pSrc = [0 0 -2];

%%
%% "Detector" positions
%%
x = [-5.25:.5:5.25]';
y = zeros(size(x));
z = -2*ones(size(x));
pDet = [x y z];

%%
%%  Setup structure for Tom's Analytic solution
%%
r_src = struct('x', pSrc(1), 'y', pSrc(2), 'z', pSrc(3));
r_det = struct('x', pDet(1,1), 'y', pDet(1,2), 'z', pDet(1,3));
r_obj = struct('x', pObj(1), 'y', pObj(2), 'z', pObj(3), 'radius', radObj);
back = struct('mu_a', mu_a, 'mu_s', mu_sp,'w', w, 'v', nu, 'S_AC',1);
obj = struct('mu_a', mu_a + delta_mu_a, 'mu_s', mu_sp, 'w', w, 'v', nu);

analytic_scat = zeros(length(x), 1);
analytic_inc = zeros(length(x), 1);
for c = 1:length(x)
    r_det.x = pDet(c,1);
    [analytic_scat(c) analytic_inc(c)] = aforward2(r_src, r_det, r_obj, back, obj, 2, 2);
end

%%
%%  Computational volume for born approximation, just needed around object
%%
CompVol.XStep = 0.05;
CompVol.YStep = CompVol.XStep;
CompVol.ZStep = CompVol.XStep;
CompVol.X = [pObj(1)-radObj:CompVol.XStep:pObj(1)+radObj];
CompVol.Y = [pObj(2)-radObj:CompVol.YStep:pObj(2)+radObj];
CompVol.Z = [pObj(3)-radObj:CompVol.ZStep:pObj(3)+radObj];
CompVol.Type = 'uniform';

%%
%%  Generate Born-1 matrix
%%
[A born_inc] = dpdwfdda(CompVol, mu_sp, mu_a, nu, f, pSrc, pDet);

%%
%%  Generate object function
%%
objfct = gensphere1(CompVol, pObj, radObj, delta_mu_a);

born_scat = A * objfct(:);

clf
subplot(2,1,1)
plot(x, abs(analytic_scat), 'b');
hold on
plot(x, abs(born_scat), 'r');
xlabel('distance (cm)')
ylabel('Amplitude')
title('Amplitude')

subplot(2,1,2)
plot(x, angle(analytic_scat) * 180/pi);
hold on
plot(x, angle(born_scat) * 180/pi, 'r');
xlabel('distance (cm)')
ylabel('Phase (degrees)')
title('Phase')

figure(2)
plot(x, abs(analytic_inc))
hold on
plot(x, abs(born_inc), 'r')