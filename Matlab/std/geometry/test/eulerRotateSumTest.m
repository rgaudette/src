function vDiff = eulerRotateSumTest(r1, r2)
r1 = r1 * pi /180;
r2 = r2 * pi /180;


eulerTotal = eulerRotateSum(r1, r2);
eulerTotal * 180 / pi
x = [1 0 0]';
y = [0 1 0]';
z = [0 0 1]';

x1 = eulerRotate(x, r1(1), r1(2), r1(3));
x2 = eulerRotate(x1, r2(1), r2(2), r2(3));

y1 = eulerRotate(y, r1(1), r1(2), r1(3));
y2 = eulerRotate(y1, r2(1), r2(2), r2(3));

z1 = eulerRotate(z, r1(1), r1(2), r1(3));
z2 = eulerRotate(z1, r2(1), r2(2), r2(3));

xTest = eulerRotate(x, eulerTotal);
yTest = eulerRotate(y, eulerTotal);
zTest = eulerRotate(z, eulerTotal);

vDiff = [x2-xTest y2-yTest z2-zTest];

