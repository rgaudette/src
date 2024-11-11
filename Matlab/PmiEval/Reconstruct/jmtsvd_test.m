m = 50;
n = 400;

rmin = 35;
rmax = 45;
r = rmin:rmax;
nr = length(r);

A = randn(m, n, 2);
x1 = randn(n,1);
c = 0.9;
x2 = 1/c * x1;

b(:,1) = A(:,:,1) * x1;
b(:,2) = A(:,:,2) * x2;

[xlm, xtsvd] = jmtsvd(A, b, r, c);

[xlme, xtsvde] = jmtsvde(A, b, r, c);

xdiff = max(xlm - xlme);