%%
%%  Test the derivative function for the spherical Bessel function, 2nd kind
%%

l = 1;
%%
%%  Too steep before x = 2 to see anything
%%
x = [2:0.01:20];
y = spbessely(l, x);
d1_y = spbessely_d1(l, x);
de_y = diff(y) ./ diff(x);
dx = x(1:end-1) + (x(2)-x(1))/2;
clf
plot(x, y);
hold on
plot(x, d1_y, 'r')
plot(dx, de_y, 'c-.');

