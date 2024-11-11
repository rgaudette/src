N = 50;
step = 0.005;
i = [-N/2:N/2];
j1 = floor(1*N/3);
j2 = floor(2*N/3);

%%
%%  Normal boundary
%%
x = step*i';
y = step*i';

hx = diff(x);
hy = diff(y);
%hx = [hx(1); hx];
%hy = [hy(1); hy];
k = 0.1 * ones(length(y), length(x));

q = zeros(size(k));
xCtr = floor(length(x)/2);
yCtr = floor(length(y)/2);
q(yCtr, xCtr) = 1 / step^2;

[phi] = hlm2d_vh(hx, hy, k, q);
% green = -1./(2*k) .* exp(-k .* abs(x-x(idxCtr)));

% figure(1)
% clf
% subplot(2,1,1)
% plot(x, real(phi), 'r')
% hold on
% plot(x, real(green), 'g-.');
% axis([x(j1+1) x(j2)  min(real(green)) max(real(green))])

% subplot(2,1,2)
% plot(x, imag(phi), 'r')
% hold on
% plot(x, imag(green), 'g-.');
% axis([x(j1+1) x(j2)  min(imag(green)) max(imag(green))])

% figure(2)
% ratio = abs(green(j1+1:j2) ./ phi(j1+1:j2));
% plot(x(j1+1:j2), abs(ratio))
% axis([x(j1+1) x(j2) min(ratio) max(ratio)]);
