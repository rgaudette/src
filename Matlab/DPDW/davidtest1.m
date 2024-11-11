%DAVIDTEST1
%  6x6 cm array with detectors uniformly spaced throughout the array and
%  sources placed at the center of each rectangle create by the sources
%

%%
%%  Sampling volume
%%
dr = 5e-3 * [1 1 1];
R = [0 6 0 6 -5 0] * 1e-2;

%%
%%  Medium parameters
%%
nu = 3E8 / 1.37;
mu_sp = 1000;
mu_a = 5.0;
SourceOffset = 10 * 1/mu_sp;


%%
%%  Source modulation frequency and source & detector positions
%%
f = 200E6;
xpos = ([1:2:5]) * 1e-2 + dr(1)/5;
ypos = ([1:2:5]) * 1e-2 + dr(2)/5;
[Xp Yp] = meshgrid(xpos, ypos);
nSrc = prod(size(Xp));
pSrc = [Xp(:) Yp(:) -1*SourceOffset*ones(nSrc,1)];


xpos = ([0:2:6]) * 1e-2 + dr(1)/5;
ypos = ([0:2:6]) * 1e-2 + dr(2)/5;
[Xp Yp] = meshgrid(xpos, ypos);
nDet = prod(size(Xp));
pDet = [Xp(:) Yp(:) zeros(nDet,1)];

clear xpos ypos Xp Yp

%%
%%  Generate the forward matrix
%%
[A Psi_Det] = dpdwfddazb(dr, R, mu_sp, mu_a, nu, f, pSrc, pDet);
Psi_Det = reshape(Psi_Det, nDet, nSrc);
A = [real(A); imag(A)];
