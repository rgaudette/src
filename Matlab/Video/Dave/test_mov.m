z=peaks;
surf(z)
lim = axis;
M=moviein(20);
for j= 1:20
	surf(sin(2*pi*j/20)*z,z);
	axis(lim);
	M(:,j)=getframe;
end;
