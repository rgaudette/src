%RVELBIAS       Velocity estimate bias example
%
%   Recovery velocity bias script.  This script plots the bias of the Mallat
%   wavelet velcoity estimator for a range of velocities for a given wavenumber.
%   For each velocity the temporal profile is plotted producing a waterfall
%   style plot.  The modifiable parameters are in the beginning of the script.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:45 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rvelbias.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:45  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:29:00  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
%%  Modifyable parameters
%%
nSpace = 101;
nTemp = 101;
pulseWidth = 50;
w = (2 * pi) / pulseWidth;

%
%  Kx = 0.1257 gives a period of 50 samples
%
sScale = 2;
tScale = 2;
Thresh = 0.50;
lambda = 1;
%%
%%  Processing flags
%%
flgUseFwdSpatDiff = 1;

%%
%%  Plot flags
%%
flgShowFunc = 1;
flgPlotVelArr = 1;
flgShowTable = 1;
if flgShowTable
    fprintf('Wavefront : Raise Sine Pulse\t Temporal width: %d\n', ...
        pulseWidth);
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
%%  Loop over changing parameter
%%
vel = 0.1:0.1:1.5;

%%
%%  Pre-allocate the result vectors
%%
centerValueBias = zeros(length(vel), 1);
PWDVelBias = zeros(length(vel), 1);
meanVelBias = zeros(length(vel), 1);
medianVelBias = zeros(length(vel), 1);
VelProfiles = zeros(length(vel), length(t));

for iVel = 1:length(vel)
    
    %%
    %%  Compute the argument to the wavefront
    %%
    kx = w / vel(iVel);
    arg = -1 * (kx * xmat - w * tmat);

    %%
    %%  Compute the wavefront
    %%
    f = zeros(size(arg));
    idxPulse = (arg >= -pi/2) & (arg <= 3*pi/2);
    f(idxPulse) = 0.5 * (sin(arg(idxPulse)) + 1);

    
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
    %%  Compute the ratio of the temporal derivative to the spatial derivative
    %%  where the are both above the threshold
    %%
    Vel = zeros(size(df_dt));
    Vel(idxVel) = -1 * df_dt(idxVel) ./ df_dx(idxVel);

    %%
    %%  Fill in the velocity profile array
    %%
    VelProfiles(iVel,:) = Vel(idxSpCenter,:);

    %%
    %%  Center velocity bias value
    %%
    centerValueBias(iVel) = 100 * (Vel(idxSpCenter, idxTmCenter) ...
        - vel(iVel)) / vel(iVel); 

    %%
    %%  Peak weighted derivative index
    %%
    [val idxPeakWD] = max(abs(df_dt(idxSpCenter, :)) + ...
        lambda * abs(df_dx(idxSpCenter, :)));
    PWDVelBias(iVel) = 100 * (Vel(idxSpCenter, idxPeakWD) - vel(iVel)) / ...
        vel(iVel);
    

    %%
    %%  Find the support of the wavefront
    %%
    OnWavefront = Vel(idxSpCenter,:) ~= 0.0;
    
    %%
    %%  Mean stats of the wavefront
    %%
    meanVel = mean(Vel(idxSpCenter, OnWavefront));
    meanPctBias = 100 * (meanVel - vel(iVel)) / vel(iVel);
    meanVelBias(iVel) = meanPctBias;

    %%
    %%  Median stats of the wavefront
    %%
    medianVel = median(Vel(idxSpCenter, OnWavefront));
    medianPctBias = 100 * (medianVel - vel(iVel)) / vel(iVel);
    medianVelBias(iVel) = medianPctBias;
    
    %%
    %%  Show table if requested
    %%
    if flgShowTable
        fprintf('%f\t%f%%\t%f%%\t%f%%\t%f%%\n',...
            vel(iVel), centerValueBias(iVel), PWDVelBias(iVel), ...
            meanPctBias, medianPctBias)
    end
    
end

if flgPlotVelArr
    waterfall(t, vel, VelProfiles)
    xlabel('Time')
    ylabel('Actual Velocity')
    zlabel('Estimated Velocity')
    axis([min(t) max(t) min(vel) max(vel) 0 max(vel)])
end
