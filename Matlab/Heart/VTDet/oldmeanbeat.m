%MEANBEAT       Compute a mean beat from a electrogram channel.
%
%   [beat idxRwave] = meanbeat(EGStruct, QRSWidth, flgDebug)
%
%   beat        The mean beat structure.
%
%   idxRwave    The indicies of the R waves used for the mean beat calculation.
%
%   EGStruct    The electrogram structure to analyze.
%
%   QRSWidth    [OPTIONAL] The QRS complex width in seconds to use in the search
%               for independent peaks (default: 0.180 seconds).
%
%   flgDebug    [OPTIONAL] Plot the detected beats in the electrogram
%               (default: 0).
%
%
%   MEANBEAT computes a mean beat aligning R waves of consecutive beats.
%
%   Calls: rwavedet.
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
%  $Log: oldmeanbeat.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:01  rickg
%  Matlab Source
%
%  Revision 1.1  1997/11/10 20:45:50  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [beat, idxRwave] = meanbeat(EGStruct, QRSWidth, flgDebug)

%%
%%  Default QRS complex width is a 180 ms.
%%
if nargin < 3
    flgDebug = 0;
    if nargin < 2;
        QRSWidth = 0.180;
    end
end

    
%%
%%  Static parameters
%%
wdTemplate = 0.9;
PreRData = 0.3;

%%
%%  Find the indices of the R waves in the electrogram 
%%
switch nargin 
    case 1,
        idxRwave = rwavedet(EGStruct);

    case 2,
        idxRwave = rwavedet(EGStruct, QRSWidth);
    
    otherwise,
        idxRwave = rwavedet(EGStruct, QRSWidth, flgDebug);
end
   
%%
%%  Compute the minimum R-to-R period, this is used to define the size of
%%  the template.
%%
seqRtoR = diff(idxRwave);
RtoRmin = min(seqRtoR);
nTemplate = floor(wdTemplate * RtoRmin);


%%
%% Sum all of the R wave alligned beats
%%
beat = zeros(nTemplate,1);
matBeat = zeros(nTemplate, length(idxRwave));
nBeats = 0;
for iRwave = 1:length(idxRwave)
    idxStart = floor(idxRwave(iRwave) - PreRData * nTemplate);
    idxStop = idxStart + nTemplate - 1;
    if (idxStart > 0) & (idxStop <= length(EGStruct.Seq))
        beat = beat + EGStruct.Seq(idxStart:idxStop);
        nBeats = nBeats + 1;
        matBeat(:, nBeats) = EGStruct.Seq(idxStart:idxStop);
    end
end
beat = beat ./ nBeats;

if flgDebug
    fprintf('Number of beats used: %d\n', nBeats);
    figure(3)
    waterfall(matBeat')
end
