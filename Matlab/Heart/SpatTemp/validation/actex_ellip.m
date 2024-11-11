%ACTEX_ELLIP    2D Elliptical activation wavefront velcoity example

%%
%%  Parameters
%%
st = clock;
szArray = [31 31];
Offset = [szArray(1)/2 szArray(2)/2 10];
strWaveFunction = 'ramp';
%strWaveFunction = 'smthstep';
%strWaveFunction = 'sigmoid';
param = 1.0;
tScale = 2;
sScale = 2;
Thresh = 50;
idxLeadMaj = 729;
idxLeadMin = 472;

VelRatio = 2;
Rotation = 0;
tWidth = 10;
w = 1 / (tWidth / 2);

%%
%%  Loop over velocity values
%%
MajVel = 0.1:0.1:1.5;
nVel = length(MajVel);
meanMajVel = zeros(nVel, 1);
meanMajVelBias = zeros(nVel, 1);
meanMinVel = zeros(nVel, 1);
meanMinVelBias = zeros(nVel, 1);

for iVel = 1:nVel

    vMaj = MajVel(iVel);
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
    [vel grad dfdt] = actvelm2(f, szArray, [tScale sScale sScale], 1, Thresh);

    %%
    %%  Find non-zero velocity estimates for center element
    %%
    MajVelMag = abs(vel(idxLeadMaj, :));
    idxMajNZ = find(MajVelMag > 0);
    MinVelMag = abs(vel(idxLeadMin, :));
    idxMinNZ = find(MinVelMag > 0);

    %%
    %%  Compute bias for mean value
    %%
    meanMajVel(iVel) = mean(MajVelMag(idxMajNZ));
    meanMajVelBias(iVel) = 100 * (meanMajVel(iVel) - vMaj) / vMaj;
    meanMinVel(iVel) = mean(MinVelMag(idxMinNZ));
    meanMinVelBias(iVel) =  100 * (meanMinVel(iVel) - vMin) / vMin;

end

etime(clock, st)


