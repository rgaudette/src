%SIRTCHK2D      Validate the sirt algorithm for a 2D geometry

A = randn(2,2);
x = randn(2,1);
b = A * x;
xmin = x(1) - 10;
xmax = x(1) + 10;
ymin = x(2) - 10;
ymax = x(2) + 10;
x1 = [xmin:xmax];

y1 = -1*A(1,1)/A(1,2) * x1 + b(1)/A(1,2);
y2 = -1*A(2,1)/A(2,2) * x1 + b(2)/A(2,2);
plot(x1, y1, 'r');
hold on
plot(x1, y2, 'b');
xold = A' * b;
for iIter = 1:20,
    xnew = sirt(A, b, xold, 1);
    plot([xold(1) xnew(1)], [xold(2) xnew(2)], 'go');
    plot([xold(1) xnew(1)], [xold(2) xnew(2)], 'g:');
    xold = xnew;
end
cond(A)
xerror = x - xnew