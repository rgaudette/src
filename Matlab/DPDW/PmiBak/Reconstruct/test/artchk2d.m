%SIRTCHK2D      Validate the sirt algorithm for a 2D geometry

A = randn(2,2);
%A = [1 1; -1 1]
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
nIter = 20
xstart = [1 1]';
xnew = art(A, b, xstart, nIter, 1)
size(xnew)
plot([xstart(1) xnew(1,1)], [xstart(2) xnew(2,1)], 'go');
plot([xstart(1) xnew(1,1)], [xstart(2) xnew(2,1)], 'g:');
for iIter = 1:nIter-1,
    plot([xnew(1,iIter) xnew(1,iIter+1)], [xnew(2,iIter) xnew(2,iIter+1)], 'go');
    plot([xnew(1,iIter) xnew(1,iIter+1)], [xnew(2,iIter) xnew(2,iIter+1)], 'g:');
end
