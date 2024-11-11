%VTCCSTAT       Compute some statistics of a mean beat CC VT detection.
%
%  [matCC PeakCC ShiftPeakCC] = vtccstat(MeanBeat, EG, CCRange)
%
%   matCC       The matrix of cross-correlation coefficients.
%
%   PeakCC      The peak values of the cross-correlation coefficient for
%               each beat.
%
%   ShiftPeakCC The shift, in samples, of the peak CC value w.r.t. R-wave
%               alignment between the template.
%
%   MeanBeat    The MeanBeat object to use as the template for the cross-
%               correlation.
%
%   EG          The electrogram to analyze.
%
%   CCRange     The number of samples to search over to find the peak cross-
%               correlation value between the template and the electrogram
%               beats.  Each beat of the electrogram will be shifted plus
%               and minus this many samples.
%
%
%   Calls: none.
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
%  $Log: vtccstat.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:01  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [matCC, PeakCC, ShiftPeakCC]= vtccstat(MeanBeat, EG, CCrange)

if nargin < 3
    CCrange = 3;
end


%%
%%  Find the R waves in the electrogram of interest
%%
nSaEG = length(EG);
idxRwave = rwavedet(mkegstrct(EG));
nBeats = length(idxRwave);
matCC = zeros(nBeats, 2 * CCrange + 1);

%%
%%  Compute the cross correlation coefficients of the electrogram
%%
idxR = idxrwave(MeanBeat);
template = beat(MeanBeat);
nSaBeat = length(template);
vShift = -1*CCrange:CCrange;
for iBeat = 1:nBeats
    for iShift = vShift
        idxStart = idxRwave(iBeat) - idxR + iShift + 1;
        idxStop = idxStart + nSaBeat - 1;
        if (idxStart >= 1) & (idxStop <= nSaEG)
            EGbeat = EG(idxStart:idxStop);
            matCC(iBeat, iShift + CCrange + 1) = template' * ...
                EGbeat / (sqrt(template' * template) * sqrt(EGbeat' * ...
                EGbeat));
        end
    end
end

%%
%%  Find the peak CC shift w.r.t. the R wave
%%
[PeakCC idxPeakCC] = max(matCC');
ShiftPeakCC = vShift(idxPeakCC);
