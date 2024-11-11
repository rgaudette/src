
clf
a1arg = [1:0.1:2];

y1 = (2 - abs(a1arg)).^3 ./ 6;
plot(a1arg, y1, 'r');
hold on
a2arg = a1arg - 1;
y2 = (abs(a2arg).^3 ./ 2 - a2arg.^2 + 2/3);
plot(a2arg, y2, 'g');

a3arg = a2arg - 1;
y3 = (abs(a3arg).^3 ./ 2 - a3arg.^2 + 2/3);
plot(a3arg, y3, 'b');

a4arg = a3arg - 1;
y4 = (2 - abs(a4arg)).^3 / 6
plot(a4arg, y4, 'm')
