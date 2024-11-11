%%
%%  Test the derivative function for the spherical Bessel function, 1st kind
%%

l = 3;
x = [0.01:0.01:20];
j = spbesselj(l, x);
d1_j = spbesselj_d1(l, x);
de_j = diff(j) ./ diff(x);
dx = x(1:end-1) + (x(2)-x(1))/2;
clf
plot(x, j);
hold on
plot(x, d1_j, 'r')
plot(dx, de_j, 'c-.');

