%ARTCHK2D      Validate the sirt algorithm for a 2D geometry

A = randn(2,2);
A = [1 1; -1 -1.001];
x = randn(2,1);
b = A * x;
xmin = x(1) - 10;
xmax = x(1) + 10;
ymin = x(2) - 10;
ymax = x(2) + 10;
x1 = [xmin:xmax];

y1 = -1*A(1,1)/A(1,2) * x1 + b(1)/A(1,2);
y2 = -1*A(2,1)/A(2,2) * x1 + b(2)/A(2,2);
clf
plot(x1, y1, 'r');
hold on
plot(x1, y2, 'b');
nIter = [1:10];
xstart = [0 0]';
xnew = art(A, b, xstart, nIter, 1);
plot([xstart(1) xnew(1,1)], [xstart(2) xnew(2,1)], 'mo');
plot([xstart(1) xnew(1,1)], [xstart(2) xnew(2,1)], 'm:');
for iIter = 1:length(nIter)-1
    plot([xnew(1,iIter) xnew(1,iIter+1)], [xnew(2,iIter) xnew(2,iIter+1)], 'mo');
    plot([xnew(1,iIter) xnew(1,iIter+1)], [xnew(2,iIter) xnew(2,iIter+1)], 'm:');
end
axis('square')