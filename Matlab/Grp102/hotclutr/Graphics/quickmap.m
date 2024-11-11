axis([min(xdist) max(xdist) min(ydist) max(ydist)])

xlabel('kilometers')

ylabel('kilometers')

title('M Mountain : RSTER Shadow Map')

print CombShadMapS2

cs = contour(xdist, ydist, dma, [1000:100:3200]);

print CombShadMapS2NC

gtext('RSTER')

[x y ] = ginput(1)

plot([0 x], [0 y])

gtext('TX')   

[x y ] = ginput(1)

plot([real(TxPos) x], [imag(TxPos) y])

plot(0, '*')                   

plot(TxPos, '*')               

print CombShadMapS2CNL