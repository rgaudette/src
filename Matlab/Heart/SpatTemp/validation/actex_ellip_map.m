%ACTEX_ELLIP_MAP  2D Elliptical activation wavefront velcoity example

%%
%%  Parameters
%%
st = clock;
szArray = [21 21];
Offset = [0 ceil(szArray(2)/2) 10];
strWaveFunction = 'ramp';
%strWaveFunction = 'smthstep';
strWaveFunction = 'sigmoid';
param = 1.0;
tScale = 2;
sScale = 2;
Thresh = 50;
idxLead = 221;
VelRatio = 2;
Rotation = 0;

%%
%%  Loop over velocity values
%%
MajVel = 0.1:0.1:1.5;
nVel = length(MajVel);
tWaveWidth = 1:2:20;
nWidth = length(tWaveWidth);

%%
%% Pre-allocate the resault arrays
%%
meanMajVel = zeros(nVel, nWidth);
meanMajVelBias = zeros(nVel, nWidth);

for iWave = 1:nWidth
    w = 1 / (tWaveWidth(iWave) * 0.5)

    for iVel = 1:nVel

        vMaj = MajVel(iVel)
        vMin = vMaj / VelRatio;
    
        nTemp = ceil((sqrt((szArray(1)/2)^2 + (szArray(2)/2)^2) ./ vMin) ...
            + 4 * Offset(3));

        %%
        %%  Generate waveform
        %%
        f = ellip_2dm4(szArray, nTemp, Offset, w, [vMaj vMin], Rotation, ...
            strWaveFunction, param);

        %%
        %%  Compute the activation velocity
        %%
        [vel grad dfdt] = actvelm2(f, szArray, [tScale sScale sScale], 1,...
            Thresh);

        %%
        %%  Find non-zero velocity estimates for center element
        %%
        MajVelMag = abs(vel(idxLead, :));
        idxMajNZ = find(MajVelMag > 0);

        %%
        %%  Compute bias for mean value
        %%
        meanMajVel(iVel, iWave) = mean(MajVelMag(idxMajNZ));
        meanMajVelBias(iVel, iWave) = 100 * (meanMajVel(iVel, iWave) - vMaj) / vMaj;
    end
end

etime(clock, st)


