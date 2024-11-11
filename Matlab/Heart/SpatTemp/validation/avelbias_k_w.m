%AVELBIAS_K_W   Activation velocity estimate bias map
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:45 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: avelbias_k_w.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:45  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%  Modifyable parameters
%%
nSpace = 25;
nTemp = 25;
sScale = 2;
tScale = 2;
Thresh = 0.50;

%%
%%  Processing flags
%%
%strWavefront = 'step';
strWavefront = 'ramp';
%strWavefront = 'smoothed ramp';
%strWavefront = 'sigmoid';
flgUseFwdSpatDiff = 1;

%%
%%  Plot flags
%%
flgShowFunc = 0;
flgPlotVelArr = 0;
flgShowTable = 0;

%%
%%  Create the spatial and temporal coordinates.  The spatial dimension
%%  varies with row index, the temporal dimension varies with column index.
%%
t = linspace(-1*floor(nTemp/2), floor(nTemp/2), nTemp);
tmat = repmat(t, nSpace, 1);
x = linspace(-1*floor(nSpace/2), floor(nSpace/2), nSpace)';
xmat = repmat(x, 1, nTemp);
idxSpCenter = ceil(nSpace/2);

%%
%%  Spatial and temporal wavenumbers to loop over
%%
vecK = 0.1:0.1:1.0;
vecW = 0.1:0.1:1.5;

%%
%%  Preallocations
%%
centerValueBias = zeros(length(vecK), length(vecW));
BestEstimate = zeros(length(vecK), length(vecW));
meanError = zeros(length(vecK), length(vecW));
meanBias = zeros(length(vecK), length(vecW));
medianError = zeros(length(vecK), length(vecW));
medianBias = zeros(length(vecK), length(vecW));


%%
%%  Loop over wavelength and velocity
%%

for iW = 1:length(vecW)
    w = vecW(iW);
    for iK = 1:length(vecK)
    
        %%
        %%  Compute the argument to the wavefront
        %%
        kx = vecK(iK);
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
        for iSpace = 1:nSpace
            detT(iSpace, :) = df_dt(iSpace, :) < Thresh * dtPeak(iSpace);
        end

        dxPeak = max(df_dx')';
        detX = zeros(size(df_dx));
        for iSpace = 1:nSpace
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
        %%  Find the non-zero elements of the wavefront for the central 
        %%  spatial element
        %%
        OnWavefront = Vel(idxSpCenter,:) ~= 0.0;
        TrueVel = w / kx;
        
        %%
        %%  Center velocity bias value
        %%
        centerValueBias(iK, iW) = 100 * (Vel(idxSpCenter,ceil(nTemp/2)) ...
            - TrueVel) / TrueVel; 

        %%
        %%  Best estimate on the wavefront
        %%
        MinError = min(abs(Vel(idxSpCenter,OnWavefront) - TrueVel));
        BestEstimate(iK, iW) = 100 * MinError ./ TrueVel;
        
        %%
        %%  Mean stats of the wavefront
        %%
        meanVel = mean(Vel(idxSpCenter, OnWavefront));
        meanError(iK, iW) = meanVel - TrueVel;
        meanBias(iK, iW) =  100 * meanError(iK, iW) / TrueVel;

        %%
        %%  Median stats of the wavefront
        %%
        medianVel = median(Vel(idxSpCenter, OnWavefront));
        medianError(iK, iW) = medianVel - TrueVel;
        medianBias(iK, iW) =  100 * medianError(iK, iW) / TrueVel;

        %%
        %%  Show table if requested
        %%
        if flgShowTable
            fprintf('%f\t%f\t%f%%\t%f\t%f%%\n',...
                vel(iVel), meanVel, meanBias(iK, iW), medianVel, ...
                medianBias(iK, iW));
        end
        
        %%
        %%  The various estimates produced vs. the true velocity
        %%
        plot(t, repmat(TrueVel, 1, length(t)), 'r');
        hold on
        plot(t, df_dx(idxSpCenter, :), 'm-^');
        plot(t, df_dt(idxSpCenter, :), 'y-v');
        plot(t, Vel(idxSpCenter, :), 'b-o');
        plot(t, f(idxSpCenter,:), 'g');
        plot(x, f(:, ceil(nTemp/2)), 'g--');
        plot(t, repmat(meanVel, 1, length(t)), 'c')

        grid on
        ylabel('Velocity')
        xlabel('Time')
        title(['Kx = ' num2str(kx) '  w = ' num2str(w)]);
        set(gca, 'xlim', [min(t) max(t)]);
        hold off
        drawnow
    end
end
