%%
%%  Test the derivative function for the spherical hankel function
%%
l = 1;
k = 1;
x = [0.01:0.01:20];
h = spbesselh(l, k, x);
d1_h = spbesselh_d1(l, k, x);
de_h = diff(h) ./ diff(x);
dx = x(1:end-1) + (x(2)-x(1))/2;
clf
subplot(2,1,1)
plot(x, real(h));
hold on
plot(x, real(d1_h), 'r')
plot(dx, real(de_h), 'c-.');


subplot(2,1,2)
plot(x, imag(h));
hold on
plot(x, imag(d1_h), 'r')
plot(dx, imag(de_h), 'c-.');
axis([2 max(x) -1 1])