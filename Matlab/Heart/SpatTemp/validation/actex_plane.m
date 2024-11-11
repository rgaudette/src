%ACTEX_PLANE         2D Activation wavefront velcoity example

%%
%%  Parameters
%%
st = clock;
szArray = [16 16];
Offset = [0 0 10];
strWaveFunction = 'ramp';
strWaveFunction = 'smthstep';
strWaveFunction = 'sigmoid';
param = 1;
tScale = 2;
sScale = 2;
Thresh = 50;
idxLead = 120;

%%
%%  Wavefront parameters
%%
Vang = 37;
tWidth = 10;
w = 1 / (tWidth / 2);


%%
%%  Loop over velocity values
%%
vVel = 0.1:0.1:1.5;
nVel = length(vVel);
meanVel = zeros(nVel, 1);
meanVelBias = zeros(nVel, 1);

for iVel = 1:nVel
    nTemp = ceil((sqrt(szArray(1)^2 + szArray(2)^2) + 4 * Offset(3)) / ...
        vVel(iVel))

    Kmag = w / vVel(iVel);
    
    %%
    %%  Generate waveform
    %%
    Kx = Kmag * cos(Vang * pi / 180);
    Ky = Kmag * sin(Vang * pi / 180);
    f = plane_2d(szArray, nTemp, Offset, Kx, Ky, w, strWaveFunction, param);

    %%
    %%  Compute the activation velocity
    %%
    [vel grad dfdt] = actvelm2(f, szArray, [tScale sScale sScale], 1, Thresh);

    %%
    %%  Find non-zero velocity estimates for center element
    %%
    VelMag = abs(vel(idxLead, :));
    idxNZ = find(VelMag > 0);

    %%
    %%  Compute bias for mean value
    %%
    meanVel(iVel) = mean(VelMag(idxNZ));
    meanVelBias(iVel) = 100 * (meanVel(iVel) - vVel(iVel)) / vVel(iVel);
end

etime(clock, st)


