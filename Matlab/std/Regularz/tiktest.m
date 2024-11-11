%%
%%  Initialization
%%
nX = 20;
nY = 100;

%%
%%  The Signal-to-noise ratio (in units of power, not dB)
%%
SNR = 100;

%%
%%  Generate an ill-conditioned operator
%%
a = illcond([nY nX], 1e4);
fprintf('Condition # of A: %f\n', cond(a));

%%
%%  Generate a random X and compute the result Ax
%%
x = randn(nX, 1);
y = a * x;


%%
%%  Perturb the output with some noise.
%%
ypow = (y' * y) ./ nY;
disturbance = randn(size(y)) * sqrt(ypow/SNR);
fprintf('True SNR: %f\n', ypow / ((disturbance' * disturbance) ./ nY));

yd = y + disturbance;

%%
%%	Generate an estimate of x over a range of regularizations
%%
Lambda = [10.^[-10:.2:1]];

XEst = zeros(nX, length(Lambda));

for i = 1:length(Lambda),
    XEst(:,i) = tikhonov(a, yd, Lambda(i));
end

figure(1)

%%
%%	Plot the error of the estimate of X
%%
Error = XEst - x * ones(1, length(Lambda));
N2Error = sqrt(sum(Error .* Error));
subplot(2,2,1)
loglog(Lambda, N2Error)
axis([min(Lambda) max(Lambda) min(N2Error) max(N2Error)])
xlabel('Regularization Parameter - Lambda')
ylabel('||Xest - X||');
grid

%%
%%    Plot the residual 2norm(A * Xest - yd)
%%
YEst = a * XEst;
Residual = YEst - yd * ones(1, length(Lambda));
N2Resid = sqrt(sum(Residual .* Residual));

subplot(2,2,2)
loglog(Lambda, N2Resid)
axis([min(Lambda) max(Lambda) min(N2Resid) max(N2Resid)])
xlabel('Regularization Parameter - Lambda')
ylabel('||A * Xest - yd||');
grid


%%
%%  Plot the 2-norm of X estimate
%%
subplot(2,2,3)
N2XEst = sqrt(sum(XEst .* XEst));
loglog(Lambda, N2XEst);
axis([min(Lambda) max(Lambda) min(N2XEst) max(N2XEst)])
xlabel('Regularization Parameter - Lambda')
ylabel('||Xest||');
grid

%%
%%  Plot the L-curve
%%
subplot(2,2,4)
loglog(N2Resid, N2XEst)
axis([min(N2Resid) max(N2Resid) min(N2XEst) max(N2XEst)])
xlabel('||A * Xest - yd||');
ylabel('||Xest||');
grid


figure(2)
plot3(log10(N2Resid), log10(N2XEst), log10(Lambda));
zlabel('log10(Lambda)')
xlabel('log10(||A * Xest - y||)');
ylabel('log10(||Xest||)');
grid

%%
%%	Plot the projection onto each axis
%%
hold on
Axis = axis;
iv = ones(length(Lambda));
plot3(log10(N2Resid), log10(N2XEst), Axis(5) * iv, 'b--');
plot3(log10(N2Resid), Axis(4) * iv, log10(Lambda)', 'r--');
plot3(Axis(2) * iv, log10(N2XEst), log10(Lambda)', 'g--');
hold off


