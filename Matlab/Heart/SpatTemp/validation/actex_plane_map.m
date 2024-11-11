%ACTEX_PLANE_MAP  2D Activation wavefront velcoity example

%%
%%  Parameters
%%
st = clock;
szArray = [16 16];
Offset = [0 0 10];
strWaveFunction = 'ramp';
strWaveFunction = 'smthstep';
%strWaveFunction = 'sigmoid';
param = 1;
tScale = 2;
sScale = 2;
Thresh = 50;
idxLead = 120;
lambda = 1;

%%
%%  Wavefront parameters
%%
Vang = 37;
tWidth = 10;
w = 1 / (tWidth / 2);

%%
%%  Loop over velocity values
%%
vVel = 0.1:0.2:1.5;
nVel = length(vVel);
tWaveWidth = 1:2:20;
nWidth = length(tWaveWidth);

%%
%% Pre-allocate the resault arrays
PWDVelBias = zeros(nVel, nWidth);
meanVel = zeros(nVel, nWidth);
meanVelBias = zeros(nVel, nWidth);

%%
%%  Loop over tWaveWidth and velocity
%%
for iWave = 1:length(tWaveWidth)
    
    w = 1 / (tWaveWidth(iWave) * 0.5);

    for iVel = 1:nVel
        nTemp = ceil((sqrt(szArray(1)^2 + szArray(2)^2) + 2 * Offset(3)) / ...
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
        [vel grad dfdt] = actvelm2(f, szArray, [tScale sScale sScale], ...
            1, Thresh);

        %%
        %%  Find non-zero velocity estimates for center element
        %%
        VelMag = abs(vel(idxLead, :));
        idxNZ = find(VelMag > 0);

        %%
        %%  Peak weighted derivative index
        %%
        [val idxPeakWD] = max(abs(dfdt(idxLead, :)) + ...
            lambda * abs(grad(idxLead, :)));
        PWDVelBias(iVel, iWave) = 100 * (VelMag(idxPeakWD) - ...
            vVel(iVel)) / vVel(iVel);

        %%
        %%  Compute bias for mean value
        %%
        meanVel(iVel, iWave) = mean(VelMag(idxNZ));
        meanVelBias(iVel, iWave) = 100 * (meanVel(iVel,iWave) - vVel(iVel)) / ...
            vVel(iVel);
    end
end


etime(clock, st)


