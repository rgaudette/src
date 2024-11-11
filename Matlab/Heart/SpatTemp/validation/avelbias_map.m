%AVELBIAS_MAP   Activation velocity estimate bias map
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:45 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: avelbias_map.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:45  rickg
%  Matlab Source
%
%  Revision 1.1  1997/08/14 21:03:06  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
%%  Modifyable parameters
%%
nSpace = 25;
nTemp = 25;

%%
%%  Processing flags
%%
%strWavefront = 'step';
strWavefront = 'ramp';
%strWavefront = 'smoothed ramp';
%strWavefront = 'sigmoid';
sScale = 2;
tScale = 2;
flgUseFwdSpatDiff = 1;
Thresh = 0.50;
lambda = 1;

%%
%%  Plot flags
%%
flgShowFunc = 0;
flgPlotVelArr = 0;
flgShowTable = 0;
if flgShowTable
    fprintf('Velocity\tCenter Value\tWghted Deriv.\tMean\t\tMedian\n');
end

%%
%%  Create the spatial and temporal coordinates
%%
t = linspace(-1*floor(nTemp/2), floor(nTemp/2), nTemp);
tmat = repmat(t, nSpace, 1);
x = linspace(-1*floor(nSpace/2), floor(nSpace/2), nSpace)';
xmat = repmat(x, 1, nTemp);
idxSpCenter = ceil(nSpace/2);
idxTmCenter = ceil(nTemp/2);

%%
%%  Free parameter vectors
%%
vel = 0.1:0.1:1.5;
tWaveWidth = 1:20;

%%
%%  Pre-allocate the result arrays
%%
VelProfile = zeros(length(vel), length(t));
centerValueBias = zeros(length(vel), length(tWaveWidth));
PWDVelBias = zeros(length(vel), length(tWaveWidth));
meanBias = zeros(length(vel), length(tWaveWidth));
medianBias = zeros(length(vel), length(tWaveWidth));

%%
%%  Loop over tWaveWidth and velocity
%%
for iWave = 1:length(tWaveWidth)
    
    w = 1 / (tWaveWidth(iWave) * 0.5);

    for iVel = 1:length(vel)
    
        %%
        %%  Compute the argument to the wavefront
        %%
        kx = w /  vel(iVel);
        arg = kx * xmat - w * tmat;

        %%
        %%  Compute the wavefront, select the wave
        %%
        if strcmp(strWavefront, 'step')
            f = stepfct(arg);
        elseif strcmp(strWavefront, 'ramp')
            f = ramp(arg, 1);
        elseif strcmp(strWavefront, 'smoothed ramp')
            f = smthstep(arg, 1);
        elseif strcmp(strWavefront, 'sigmoid')
            f = sigmoid(arg, 1);
        elseif strcmp(strWavefront, 'raised sine')
            f = zeros(size(arg));
            idxPulse = (arg >= -pi/2) & (arg <= 3*pi/2);
            f(idxPulse) = sin(arg(idxPulse)) + 1;
        end
    
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
        dtPeak = min(df_dt')';
        detT = zeros(size(df_dt));
        for iSpace = 1:nSpace,
            detT(iSpace, :) = df_dt(iSpace, :) < Thresh * dtPeak(iSpace);
        end

        dxPeak = max(df_dx')';
        detX = zeros(size(df_dx));
        for iSpace = 1:nSpace,
            detX(iSpace, :) = df_dx(iSpace, :) > Thresh * dxPeak(iSpace);
        end
        idxVel = detX & detT;

        %%
        %%  Compute the ratio of the temporal derivative to the spatial
        %%  derivative where the are both above the threshold
        %%
        Vel = zeros(size(df_dt));
        Vel(idxVel) = -1 * df_dt(idxVel) ./ df_dx(idxVel);

        %%
        %%  Fill in the velocity profile array
        %%
        VelProfile(iVel,:) = Vel(idxSpCenter,:);

        %%
        %%  Center velocity bias value
        %%
        centerValueBias(iVel, iWave) = 100 * (Vel(idxSpCenter, idxTmCenter) ...
            - vel(iVel)) / vel(iVel); 

        %%
        %%  Peak weighted derivative index
        %%
        [val idxPeakWD] = max(abs(df_dt(idxSpCenter, :)) + ...
            lambda * abs(df_dx(idxSpCenter, :)));
        PWDVelBias(iVel, iWave) = 100 * (Vel(idxSpCenter, idxPeakWD) - ...
            vel(iVel)) / vel(iVel);

        %%
        %%  Find the support of the wavefront
        %%
        OnWavefront = Vel(idxSpCenter,:) ~= 0.0;

        %%
        %%  Mean stats of the wavefront
        %%
        meanVel = mean(Vel(idxSpCenter, OnWavefront));
        meanBias(iVel, iWave) =  100 * (meanVel - vel(iVel)) / vel(iVel);
        
        %%
        %%  Median stats of the wavefront
        %%
        medianVel = median(Vel(idxSpCenter, OnWavefront));
        medianBias(iVel, iWave) =  100 * (medianVel - vel(iVel)) / vel(iVel);
        
       
        %%
        %%  Show table if requested
        %%
        if flgShowTable
            fprintf('%f\t%f%%\t%f%%\t%f%%\t%f%%\n',...
                vel(iVel), ...
                centerValueBias(iVel, iWave), PWDVelBias(iVel, iWave), ...
                meanBias(iVel, iWave), medianPctBias(iVel, iWave));

        end
    end

    if flgPlotVelArr
        waterfall(t, vel, VelProfile)
        xlabel('Time')
        ylabel('Actual Velocity')
        zlabel('Estimated Velocity')
        axis([min(t) max(t) min(vel) max(vel) 0 max(vel)])
    end
end

