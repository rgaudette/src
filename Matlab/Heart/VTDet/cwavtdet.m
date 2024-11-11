%CWAVTDET       Correlation waveform analysis VT detector
%
%   [DetStruct MeanBeat] = cwavtdet(EGStruct, MeanBeat = [])
%   
%   DetStruct   A structure containing the detection sequence as well as
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
%  $Log: cwavtdet.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:01  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [DetStruct, MeanBeat] = cwavtdet(EGStruct, MeanBeat)

%%
%%  Default parameters
%%
nMinConsec = 5;
CCThresh = 0.9;

if nargin < 2

    %%
    %%  Create a Meanbeat object using the default parameters
    %%
    MeanBeat = meanbeat(EGStruct);
end


%%
%%  Detect the R waves in the electrogram 
%%
idxRwaveSeq = rwavedet(EGStruct);
DetStruct.BadBeatDet = zeros(size(EGStruct.Seq));
DetStruct.VTDet = zeros(size(EGStruct.Seq));

Template = beat(MeanBeat);
PreRSamps = ceil(0.3 * length(Template));

%%
%%  Loop over detected R waves
%%
nBeats = length(idxRwaveSeq)

nConsecBad = 0;
Template = beat(MeanBeat);
for iBeat = 1:nBeats
    idxStart = idxRwaveSeq(iBeat) - PreRSamps;
    idxStop = idxStart + length(Template) - 1;
    if((idxStart > 0) & (idxStop <= length(EGStruct.Seq)))
 
        %%
        %%  Possibly update meanbeat object
        %%
        [MeanBeat flg] = update(MeanBeat, EGStruct, idxRwaveSeq(iBeat));
        if flg
            fprintf('Beat %d added to Meanbeat object\n', iBeat);
        end
    
        %%
        %%  Cross correlate template and current beat
        %%
        Template = beat(MeanBeat);
        CurrentBeat = EGStruct.Seq(idxStart:idxStop);
        CC = CurrentBeat' * Template / ...
            (sqrt(CurrentBeat' * CurrentBeat) * sqrt(Template' * Template));
    
        %%
        %%  Increment counter if CC is below threshold, else reset counter
        %%
        if CC < CCThresh
            nConsecBad = nConsecBad + 1;
            DetStruct.BadBeatDet(idxStart:idxStop) = 1;
        
            if nConsecBad >= nMinConsec
                DetStruct.VTDet(idxStart:idxStop) = 1;
            end
        
        else
            nConsecBad = 0;
        end
    end
end
    
    
