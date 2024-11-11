%ACT_EX         2D Activation wavefront velcoity example
%%
%%  Parameters
%%
st = clock;
szArray = [16 16];
nTemp = 100;
Offset = [0 0 10];
Kmag = 0.5;
Kang = 45;
Vel = 0.2;
w = Vel * Kmag;
strWaveFunction = 'sigmoid';
param = 1;
tScale = 2;
sScale = 2;
Thresh = 50;

%%
%%  Generate waveform
%%
Kx = Kmag * cos(Kang * pi / 180);
Ky = Kmag * sin(Kang * pi / 180);
f = plane_2d(szArray, nTemp, Offset, Kx, Ky, w, strWaveFunction, param);

%%
%%  Compute the activation velocity
%%
[vel grad dfdt] = actvelm2(f, szArray, [tScale sScale sScale], 1, Thresh);

%%
%%  Find non-zero velocity estimates for center element
%%
etime(clock, st)


