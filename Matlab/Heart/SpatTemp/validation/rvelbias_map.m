%RVELBIAS_MAP   Activation velocity estimate bias map
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:45 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rvelbias_map.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:45  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
%%  Modifyable parameters
%%
nSpace = 101;
nTemp = 101;
sScale = 2;
tScale = 2;
Thresh = 0.50;

%%
%%  Processing flags
%%
%strWavefront = 'step';
%strWavefront = 'ramp';
strWavefront = 'smoothed ramp';
%strWavefront = 'sigmoid';
flgUseFwdSpatDiff = 1;

%%
%%  Plot flags
%%
flgShowFunc = 0;
flgPlotVelArr = 0;
flgShowTable = 0;

%%
%%  Create the spatial and temporal coordinates
%%
t = linspace(-1*floor(nTemp/2), floor(nTemp/2), nTemp);
tmat = repmat(t, nSpace, 1);
x = linspace(-1*floor(nSpace/2), floor(nSpace/2), nSpace)';
xmat = repmat(x, 1, nTemp);

vel = 0.1:0.1:1.5;
WaveLength = 20:80;
VelArray = zeros(length(vel), length(t));
meanBias = zeros(length(vel), length(WaveLength));
medianBias = zeros(length(vel), length(WaveLength));

%%
%%  Loop over wavelength and velocity
%%

for iWave = 1:length(WaveLength)
    
    w = (2 * pi) / WaveLength(iWave);

    for iVel = 1:length(vel)
    
        %%
        %%  Compute the argument to the wavefront
        %%
        kx = w /  vel(iVel);
        arg = -1 * (kx * xmat - w * tmat);

        f = zeros(size(arg));
        idxPulse = (arg >= -pi/2) & (arg <= 3*pi/2);
        f(idxPulse) = sin(arg(idxPulse)) + 1;
    
        if flgShowFunc
            pcolor(t, x, f);
            colorbar
            drawnow
        end
    
        %%
        %%  Compute the Mallat decomposition at the specified scale
        %%
        if flgUseFwdSpatDiff
            df_dx = flipud(-1 * mallat1s(flipud(f), sScale));
        else
            df_dx = mallat1s(f, sScale);
        end
    
        df_dt = mallat1s(f', tScale)';

        %%
        %%  Threshold detect both derivatives
        %%
        dtPeak = max(df_dt')';
        detT = zeros(size(df_dt));
        for iSpace = 1:nSpace,
            detT(iSpace, :) = df_dt(iSpace, :) > Thresh * dtPeak(iSpace);
        end

        dxPeak = min(df_dx')';
        detX = zeros(size(df_dx));
        for iSpace = 1:nSpace,
            detX(iSpace, :) = df_dx(iSpace, :) < Thresh * dxPeak(iSpace);
        end
        idxVel = detX & detT;

        %%
        %%  Compute the ratio of the temporal derivative to the spatial
        %%  derivative where the are both above the threshold
        %%
        Vel = zeros(size(df_dt));
        Vel(idxVel) = -1 * df_dt(idxVel) ./ df_dx(idxVel);

        %%
        %%  Compute the mean and median of the detected velocities estimates
        %%
        OnWavefront = Vel(ceil(nSpace/2),:) ~= 0.0;
        meanVel = mean(Vel(ceil(nSpace/2), OnWavefront));
        medianVel = median(Vel(ceil(nSpace/2), OnWavefront));
        
        %%
        %%  Fill in the mean and median percentage bias arrays
        meanBias(iVel, iWave) =  100 * (meanVel - vel(iVel)) / vel(iVel);
        medianBias(iVel, iWave) =  100 * (medianVel - vel(iVel)) / vel(iVel);

        
        %%
        %%  Fill in the velocity array
        %%
        VelArray(iVel,:) = Vel(ceil(nSpace/2),:);

        %%
        %%  Show table if requested
        %%
        if flgShowTable
            fprintf('%f\t%f\t%f%%\t%f\t%f%%\n',...
                vel(iVel), meanVel, meanBias(iVel, iWave), medianVel, ...
                medianBias(iVel, iWave));
        end
    end

    if flgPlotVelArr
        waterfall(t, vel, VelArray)
        xlabel('Time')
        ylabel('Actual Velocity')
        zlabel('Estimated Velocity')
        axis([min(t) max(t) min(vel) max(vel) 0 max(vel)])
    end
end

