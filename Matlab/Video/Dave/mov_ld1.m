
load jt400.mat
load jt401.mat
load jt402.mat
load jt403.mat
load jt404.mat
load jt405.mat
load jt406.mat
load jt407.mat
load jt408.mat
load jt409.mat

image(jt400)
lim=axis;
M=moviein(10);

image(jt400)
axis(lim);
M(:,1) = getframe;

image(jt401)
axis(lim)
M(:,2) = getframe;

image(jt402)
axis(lim)
M(:,3) = getframe;

image(jt403)
axis(lim)
M(:,4) = getframe;

image(jt404)
axis(lim)
M(:,5) = getframe;

image(jt405)
axis(lim)
M(:,6) = getframe;

image(jt406)
axis(lim)
M(:,7) = getframe;

image(jt407)
axis(lim)
M(:,8) = getframe;

image(jt408)
axis(lim)
M(:,9) = getframe;

image(jt409)
axis(lim)
M(:,10) = getframe;
