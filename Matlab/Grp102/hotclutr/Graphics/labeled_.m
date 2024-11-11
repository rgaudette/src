shad_plt(xdist, ydist, RSTERVis , MMtn, 3);
axis('image')
xlabel('kilometers')
ylabel('kilometers')
title('RSTER shadow map (dma4)')
plot(0,0,'*')
disp('Select RSTER label')
gtext('RSTER')
disp('Select line point')
[x y] = ginput(1);
plot([x 0], [y 0])
disp('Select MMtn label')
gtext('MMtn')
disp('Select line point')
[x y] = ginput(1);
plot([real(MMtn) x], [imag(MMtn) y])
plot(W14, '*')
disp('Select W14 label')
gtext('W14')
disp('Select line point')
[x y] = ginput(1);
plot([x real(W14)], [y imag(W14)])
plot(SiteB, '*')
disp('Select SiteB label')
gtext('SiteB')
disp('Select line point')
[x y] = ginput(1);
plot([x real(SiteB)], [y imag(SiteB)])
plot(SierraBlanca, '*')
disp('Select SierraBlanca label')
gtext('SierraBlanca')
disp('Select line point')
[x y] = ginput(1);
plot([x real(SierraBlanca)], [y imag(SierraBlanca)])
plot(Salinas, '*')
disp('Select Salinas label')
gtext('Salinas')
disp('Select line point')
[x y] = ginput(1);
plot([x real(Salinas)], [y imag(Salinas)])
print
grid
print
cs = contour(xdist, ydist, dma, [1200:100:3600]);
print