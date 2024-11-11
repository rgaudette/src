function [reg_c,rho_c,eta_c] = l_corner(rho,eta,reg_param)
%L_CORNER Locate the "corner" of the L-curve.
%
% [reg_c,rho_c,eta_c, kappa] =
%        l_corner(rho,eta,reg_param)
%
% Locates the "corner" of the L-curve in log-log scale.
%
% It is assumed that corresponding values of || A x - b ||, || L x ||,
% and the regularization parameter are stored in the arrays rho, eta,
% and reg_param, respectively (such as the output from routine l_curve).
%
% If nargin = 3, then no particular method is assumed, and if
% nargin = 2 then it is issumed that reg_param = 1:length(rho).
%

% The following functions from the Spline Toolbox are needed if
% method differs from 'Tikh' or 'dsvd':
% fnder, ppbrk, ppmak, ppual, sp2pp, sorted, spbrk, spmak, sprpp.

% Per Christian Hansen, IMM, 04/16/98.

method = 'none';
% Set default parameters for treatment of discrete L-curve.
deg   = 2;  % Degree of local smooting polynomial.
q     = 20;  % Half-width of local smoothing interval.
order = 4;  % Order of fitting 2-D spline curve.

% Initialization.
if (length(rho) < order)
  error('Too few data points for L-curve analysis')
end


% The L-curve is discrete and may include unwanted fine-grained
% corners.  Use local smoothing, followed by fitting a 2-D spline
% curve to the smoothed discrete L-curve.

% Check if the Spline Toolbox exists, otherwise return.
if (exist('spdemos')~=2)
    error('The Spline Toolbox in not available so l_corner cannot be used')
end

% For TSVD, TGSVD, and MTSVD, restrict the analysis of the L-curve
% according to s_thr.
if (nargin > 3)
    index = find(s > s_thr);
    rho = rho(index);
    eta = eta(index);
    reg_param = reg_param(index);
    s = s(index);
    beta = beta(index);
    xi = xi(index);
end

% Convert to logarithms.
lr = length(rho);
%%
%%  rjg change removed log from next two lines
%%
lrho = log(rho);
leta = log(eta);
slrho = lrho;
sleta = leta;

% For all interior points k = q+1:length(rho)-q-1 on the discrete
% L-curve, perform local smoothing with a polynomial of degree deg
% to the points k-q:k+q.
v = [-q:q]';
A = zeros(2*q+1,deg+1);
A(:,1) = ones(length(v),1);
for j = 2:deg+1,
    A(:,j) = A(:,j-1).*v;
end
for k = q+1:lr-q-1
    cr = A\lrho(k+v);
    slrho(k) = cr(1);
    ce = A\leta(k+v);
    sleta(k) = ce(1);
end
  
% Fit a 2-D spline curve to the smoothed discrete L-curve.
sp = spmak([1:lr+order],[slrho';sleta']);
pp = ppbrk(sp2pp(sp),[4,lr+1]);
  
% Extract abscissa and ordinate splines and differentiate them.
% Compute as many function values as default in spleval.
P     = spleval(pp);
dpp   = fnder(pp);
D     = spleval(dpp);
ddpp  = fnder(pp,2);
DD    = spleval(ddpp);
ppx   = P(1,:);
ppy   = P(2,:);
dppx  = D(1,:);
dppy  = D(2,:);
ddppx = DD(1,:);
ddppy = DD(2,:);

% Compute the corner of the discretized .spline curve via max. curvature.
% No need to refine this corner, since the final regularization
% parameter is discrete anyway.
% Define curvature = 0 where both dppx and dppy are zero.
k1    = dppx.*ddppy - ddppx.*dppy;
k2    = (dppx.^2 + dppy.^2).^(1.5);
I_nz  = find(k2 ~= 0);
kappa = zeros(1,length(dppx));
kappa(I_nz) = -k1(I_nz)./k2(I_nz);
[kmax,ikmax] = max(kappa);
x_corner = ppx(ikmax);
y_corner = ppy(ikmax);

%%rjg
%%  Where d^2y/dx^2 = 1
%%
dydx_sq = ddppy ./ ddppx;
[junk ikmax] = max(dydx_sq + 1)
x_corner = ppx(ikmax)
y_corner = ppy(ikmax)

% Locate the point on the discrete L-curve which is closest to the
% corner of the spline curve.  Prefer a point below and to the
% left of the corner.  If the curvature is negative everywhere,
% then define the leftmost point of the L-curve as the corner.
if (kmax < 0)
    reg_c = reg_param(lr); rho_c = rho(lr); eta_c = eta(lr);
else
    index = find(lrho < x_corner & leta < y_corner);
    if (length(index) > 0)
        [dummy,rpi] = min((lrho(index)-x_corner).^2 + (leta(index)-y_corner).^2);
        rpi = index(rpi);
    else
        [dummy,rpi] = min((lrho-x_corner).^2 + (leta-y_corner).^2);
    end
    reg_c = reg_param(rpi); rho_c = rho(rpi); eta_c = eta(rpi);
end
figure(2)
clf
xrange = [-2 8];
subplot(2,1,1)
plot(log(rho), log(eta), 'b')
hold on
%  plot(slrho, sleta, 'r')
%  plot(P(1,:), P(2,:), 'g')

plot(lrho(rpi), leta(rpi), 'rx', 'linewidth', 2)
%  set(gca, 'xlim', xrange);
ylabel('||log(x_{est})||')

subplot(2,1,2)
plot(P(1,:), dydx_sq)
hold on
plot(P(1,ikmax), dydx_sq(ikmax), 'rx', 'linewidth', 2);
%  set(gca, 'xlim', xrange);
xlabel('log(||Ax_{est}-b||)')
ylabel('Curvature \kappa')

figure(3)
clf
subplot(2,1,1)
plot(P(1,:), kappa)
hold on
plot(P(1,ikmax), kappa(ikmax), 'rx', 'linewidth', 2);
set(gca, 'xlim', [0.5 1.5]);
set(gca, 'ylim', [-250 1000])
xlabel('log(||Ax_{est}-b||)')
ylabel('Curvature \kappa')

subplot(2,1,2)
plot(P(1,:), kappa)
hold on
plot(P(1,ikmax), kappa(ikmax), 'rx', 'linewidth', 2);
set(gca, 'xlim', [2 3]);
set(gca, 'ylim', [0 1000])
xlabel('log(||Ax_{est}-b||)')
ylabel('Curvature \kappa')
