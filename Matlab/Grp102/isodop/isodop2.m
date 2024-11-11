function DopplerBin = isodop2(Heading, Velocity, PRF, Npulses, SampInterval)
%%
%%    Constants
%%
earth_radius = 4/3 * 6370;	% 4/3 earth model, kilometers.
platform_el = 1.219;		% 1.219 Km. 4000 ft above surrounding terrain
C = 3e8;
Freq = 435e6;
lambda = C /Freq;

%%
%%    X Y grid (kilometers)
x = [-152.75:SampInterval:36.01];
y = [40.24:-SampInterval:-71.29];
ymat = y' * ones(1,length(x));
xmat = ones(length(y),1) * x;
pos = xmat + j*ymat;
aspect = angle(pos);
range = abs(pos);

%%
%%  Aspect angle is with respect east, shift to appearent heading.
%%
shift = (Heading + 90) * pi / 180;
aspect = aspect + shift;

%%
%%    Compute relative elevation.
%%
h1 = sqrt(earth_radius ^ 2 - range .^ 2);	% depression due to range
h2 = platform_el + earth_radius - h1;		% appearent elevation
elev_angle = atan(h2 ./ range);

%%
%%    Compute radial velocity of each point.
%%
rad_vel = -Velocity * cos(aspect) .* cos(elev_angle);

%%
%%    Doppler frequency computation
%%
DopplerRes = PRF / Npulses;
DopplerFreq = 2 / lambda * rad_vel;
DopplerBin = fix(DopplerFreq /DopplerRes);

DopplerBin = rem(DopplerBin, Npulses);

%%
%%    Graphics control
%%
clg

%%
%%    Axes for photograph
%%
axes('position', [1.36/11 1.94/8.5 8.02/11 4.74/8.5], 'XTick', [], ...
'YTick', [], 'Box', 'on')                                             

orient landscape

c_struct = contour(x,y,DopplerBin,[-Npulses/2:1:Npulses/2-1]);
clabel(c_struct, [-Npulses/2:1:Npulses/2-1]);
