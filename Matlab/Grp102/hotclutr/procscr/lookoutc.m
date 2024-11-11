 cs = contour(xdist, ydist, dma, [1000:100:3600]);
 axis('image')
 xlabel('kilometers')
 ylabel('kilometers')
 hold on
 plot(0,0, '*')
 gtext('RSTER')
 W14 = -34.82-j*10.65;
 SiteB = -34.73-j*42.89;
 plot(W14, '*')
 gtext('W14')
 plot(SiteB, '*')
 gtext('Site B')
 plot(Lookout, '*')
 gtext('Lookout Mountain')
