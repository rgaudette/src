%WTVTDET        Wavelet transform VT detector
%
%   [objDetOut MeanBeat] = wtvtdet(EGStruct, EGtrain, MeanBeat = [])
%   
%   objDetOut   A structure containing the detection sequence as well as
%               some statistical info.
%
%   MeanBeat    The updated Meanbeat object.  If not supplied a Meanbeat
%               object will be created using the default parameters.
%
%
%   Calls: Meanbeat.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:01 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: wtvtdet.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:01  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [objDetOut, MeanBeat] = wtvtdet(EGStruct, EGtrain, MeanBeat)

%%
%%  Default parameters
%%
nMinConsec = 5;
CCThresh = 0.95;                        % min CC value for a good beat
wdBeat = 0.3;                           % defines the template length
wdQRS = 0.180;                          % for R-wave detection
nBeats = 10;                            % the number of beats in the mean beat
Wavelet = 'Mallat';
iScale = 2;
flgDebug = 0;
flgStats = 0;
idxAlign = 0;
flgFixMeanBeat = 0;

%%
%%  Compute the wavelet transform of the electrogram sequence
%%
switch Wavelet
    case {'d4', 'd6', 'd8', 'd10', 'd12', 'd14', 'haar', 'hat'}
        [hApp hDet] = feval(['wfc_' Wavelet]);
        nSamps = floor(length(EGStruct.Seq) / (2^iScale)) * 2^iScale;
        [w scmap] = dwtz(EGStruct.Seq(1:nSamps), hApp, hDet, iScale);
        idxScStart = cumsum([1; scmap]);
        idxScStop = cumsum(scmap);
        WTEGStruct.Seq = w(idxScart(iScale):idxScStop(iScale));
        FSfactor  = 2^iScale;
        WTEGStruct.FSamp = EGStruct.FSamp / FSfactor;;
        WTEGStruct.Units = EGStruct.Units;
    
    case 'Mallat'
        WTEGStruct.Seq = mallat1s(EGStruct.Seq, iScale);
        FSfactor = 1;
        WTEGStruct.FSamp = EGStruct.FSamp;
        WTEGStruct.Units = EGStruct.Units;
        if nargin > 1
            WTTrain.Seq = mallat1s(EGtrain.Seq, iScale);
            WTTrain.FSamp = EGStruct.FSamp;
            WTTrain.Units = EGStruct.Units;
        end
            
    case 'none'
        WTEGStruct = EGStruct;
        if nargin > 1
            WTTrain = EGtrain;
        end
        
        FSfactor = 1;
    
    otherwise
        error(['Unknown wavelet: ' Wavelet]);
end        
    

if flgDebug
    figure(1)
    clf
    subplot(2,1,1)
    EGTime = [0:length(EGStruct.Seq)-1] ./ EGStruct.FSamp;
    plot(EGTime, EGStruct.Seq);
    title('Orginal electrogram')
    
    subplot(2,1,2);
    WTTime = [0:length(WTEGStruct.Seq)-1] ./ WTEGStruct.FSamp;
    plot(WTTime, WTEGStruct.Seq);
    title([Wavelet ' wavelet transform']);
end

%%
%%  Create and initialize a mean beat structure if not supplied
%%
if nargin > 1
    if(nargin < 3)
        disp('Calculating meanbeat from training data..')
        MeanBeat = meanbeat(WTTrain, wdQRS, wdBeat, 10, CCThresh);
    end

else    
    %%
    %%  Create a Meanbeat object using the default parameters
    %%
    MeanBeat = meanbeat(WTEGStruct, wdQRS, wdBeat, 10, CCThres);
end


%%
%%  Detect the R waves in the electrogram 
%%
idxRwaveSeq = rwavedet(EGStruct);
if flgDebug
    subplot(2,1,1);
    hold on
    for iRwave = 1:length(idxRwaveSeq)
        plot(idxRwaveSeq(iRwave) ./ EGStruct.FSamp * [1 1], [-100 100], ...
            'r--');
    end
    hold off
end

idxRwaveSeq = floor(idxRwaveSeq / FSfactor);

objDetOut.BadBeatDet = zeros(size(WTEGStruct.Seq));
objDetOut.VTDet = zeros(size(WTEGStruct.Seq));

Template = beat(MeanBeat);

%%
%%  Loop over detected R waves
%%
nBeats = length(idxRwaveSeq);

nConsecBad = 0;
CCbad = [];
CCgood = [];

Template = beat(MeanBeat);
for iBeat = 1:nBeats
    
    idxStart = idxRwaveSeq(iBeat) + idxAlign - idxrwave(MeanBeat) + 1;
    if(idxStart > 0),
        idxStop = idxStart + length(Template) - 1;
        if idxStop > length(WTEGStruct.Seq)
            break;
        end

        %%
        %%  Possibly update meanbeat object and get new template
        %%
        if(~flgFixMeanBeat)
            [MeanBeat flgUpdate CC] = update(MeanBeat, WTEGStruct, ...
                idxRwaveSeq(iBeat) + idxAlign);
            if flgUpdate
                Template = beat(MeanBeat);
                if flgDebug & flgUpdate
                    fprintf('Beat %d added to Meanbeat object\n', iBeat);
                end
            end
        end
        
        %%
        %%  Cross correlate template and current beat
        %%
        CurrentBeat = WTEGStruct.Seq(idxStart:idxStop);
    
        CC = CurrentBeat' * Template / ...
            (sqrt(CurrentBeat' * CurrentBeat) * sqrt(Template' * Template));

        
        if flgDebug
            %%
            %%  Plot template and test beat
            %%
            figure(2)
            plot(CurrentBeat)
            hold on
            plot(Template, 'r')
            plot([idxrwave(MeanBeat) idxrwave(MeanBeat)], [-300 300], 'g--');
            hold off
            title(['Beat #' int2str(iBeat)]);
            legend(['Test - CC: 'num2str(CC)], 'Template');
            pause
            figure(1)
            
        end

        %%
        %%  Increment counter if CC is below threshold
        %%  other reset counter
        %%
        if CC < CCThresh
            nConsecBad = nConsecBad + 1;
            objDetOut.BadBeatDet(idxStart:idxStop) = 1;

            if nConsecBad >= nMinConsec
                objDetOut.VTDet(idxStart:idxStop) = 1;
            end
        
        else
            nConsecBad = 0;
        end
        if flgStats
            if CC < CCThresh
                CCbad = [CCbad CC];
            else
                CCgood = [CCgood CC];
            end
        end
    end
end

if flgDebug
    subplot(4,1,3)
    plot(WTTime, objDetOut.BadBeatDet);
    set(gca, 'ylim', [-.25 1.25])
    subplot(4,1,4)
    plot(WTTime, objDetOut.VTDet);
    set(gca, 'ylim', [-.25 1.25])
end

if flgStats
    fprintf('Good  #: %d  mean CC: %f  std CC: %f\n', length(CCgood), ...
        mean(CCgood), std(CCgood));

    fprintf('Bad   #: %d  mean CC: %f  std CC: %f\n', length(CCbad), ...
        mean(CCbad), std(CCbad));
end
