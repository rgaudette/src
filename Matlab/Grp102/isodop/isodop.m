Re = (4/3)*6370;        % Radius of earth (Km) (including diffraction effects)
h  = 10;                % Height of platform (Km)
v  = 200;               % Velocity of platform (m/s)
xmin = -200;            % Minimum x for plot (Km)
xmax = 200;             % Maximum x for plot (Km)
ymin = -200;            % Minimum y for plot (Km)
ymax = 200;             % Maximum y for plot (Km)
step = 2;		% Step size (Km)
lambda = .7;	        % Radar wavelength (m)
%npulse = 5;            % Number of pulses per CPI;
%prf = 300;             % Pulse repetition frequency (Hz);
prf=input('Enter PRF in Hz:');
cpi=.015;		% Coherent Processing Interval (sec)
npulse=ceil(prf*cpi);	% Number of pulses / doppler bins per CPI
win=input('Enter figure number for plot:');

x = xmin:step:xmax;
nx=length(x);
y = ymin:step:ymax;
ny=length(y);

X=ones(ny,1)*x;
Y=y'*ones(1,nx);
r=sqrt( X.^2 + Y.^2 );
az=atan2(Y,X);


h1=sqrt( Re^2-r.^2 );
h2=h+Re-h1;
el=atan(h2./r);

vmap=v*sin(az).*cos(el);

bin_width = prf / npulse;			% Bin width (Hz)
fd = 2*vmap/lambda;				% Doppler frequency (Hz) of each point
b = fix ( fd / bin_width );
doplr_bin = rem(b,npulse);			% Doppler bin of each point
index=find(doplr_bin<0);
doplr_bin(index)=doplr_bin(index)+npulse;	% Correct negative dopplers

z=doplr_bin( ny:-1:1 , : )+1;			% Reorder for display
yy = y( ny:-1:1 );

figure(win)

axes('Position',[ .1, .1, .6, .8 ])
image(x,y,doplr_bin+1);				% Plot isodoppler contours
xlabel('X (Km)')
ylabel('Y (Km)')
title('Iso-Doppler Contours')
colormap(hsv(npulse+1))

axes('Position', [ .85, .1, .1, .8])
image( (1:npulse)' )
ylabel('Doppler Bin')

figure(win)