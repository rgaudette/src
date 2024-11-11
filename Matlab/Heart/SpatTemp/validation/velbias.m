%VELBIAS        Velocity estimate bias example

%%
%%  Create the spatial and temporal coordinates
%%
nSpace = 51;
nTemp = 51;
t = linspace(-1*floor(nTemp/2), floor(nTemp/2), nTemp);
tmat = repmat(t, nSpace, 1);
x = linspace(-1*floor(nSpace/2), floor(nSpace/2), nSpace)';
xmat = repmat(x, 1, nTemp);

%%
%%  Loop over changing parameter
%%
vel = 0.05:0.05:1.5;

VelArray = zeros(length(vel), length(t));
for iVel = 1:length(vel)
    
    %%
    %%  Compute the wavefront
    %%
    kx = .05;
    w = kx * vel(iVel);
    arg = -1*(kx * xmat - w * tmat);
    f = zeros(size(arg));
    idxPulse = (arg >= -pi/2) & (arg <= 3*pi/2);
    f(idxPulse) = sin(arg(idxPulse)) + 1;
    
    %%
    %%  Compute the Mallat decomposition at the specified scale
    %%
    Scale = 2;
    [df_dx Filter] = mallat1s(f, Scale);
    df_dt = mallat1s(f', Scale)';

    %%
    %%  Threshold detect both derivatives
    %%
    Thresh = 0.50;
    dtPeak = max(df_dt')';
    detT = zeros(size(df_dt));
    for iSpace = 1:nSpace,
        detT(iSpace, :) = df_dt(iSpace, :) > Thresh * dtPeak(iSpace);
    end

    dxPeak = max(df_dx')';
    detX = zeros(size(df_dx));
    for iSpace = 1:nSpace,
        detX(iSpace, :) = abs(df_dx(iSpace, :)) > Thresh * dxPeak(iSpace);
    end
    idxVel = detX & detT;

    %%
    %%  Compute the ratio of the temporal derivative to the spatial derivative
    %%  where the are both above the threshold
    %%
    Vel = zeros(size(df_dt));
    Vel(idxVel) = -1 * df_dt(idxVel) ./ df_dx(idxVel);

    %%
    %%  Fill in the velocity array
    %%
    VelArray(iVel,:) = Vel(ceil(nSpace/2),:);
end
