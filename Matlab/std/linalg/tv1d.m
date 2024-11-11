function tv = tv1d(x);

cdiff = (x(3:end) - x(1:end-2)) ./ 2;
dx = [x(2)-x(1); cdiff; x(end)-x(end-1)];
tv = sum(abs(dx));