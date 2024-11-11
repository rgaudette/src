%UPDATE         Update the mean beat with a new sample beat
%
%   [MeanBeat flg CC] = update(MeanBeat, EGStruct, idxRwave)
%
%   flg         True if the beat is used to update the mean beat. False if
%               the cross-correlation coefficient .
%
%   MeanBeat    The MeanBeat object to update.
%
%   EGStruct    The Electrogram structure containing the beat to include.
%
%   idxRwave    The index of the R wave in the electrogram sequence of the
%               beat to include.
%
%
%   UPDATE attempts to add a new beat to the beats used in computing a mean
%   beat.  The cross-corrleation coefficient (CC) between the current mean beat
%   and the prospective beat must be above the minimum CC for the beat to be
%   included in the mean.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:02 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: update.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:02  rickg
%  Matlab Source
%
%  Revision 1.1  1997/11/12 16:52:17  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [MeanBeat, flg, CC] = update(MeanBeat, EGStruct, idxRwave)

%%
%%  Extract the prospective beat from the Electrogram structure
%%
idxStart = idxRwave - MeanBeat.idxRwave + 1;
idxStop = idxStart + length(MeanBeat.Beat) - 1;
if (idxStart < 1) | (idxStop > length(EGStruct.Seq))
    flg = 0;
    return
end
PBeat = EGStruct.Seq(idxStart:idxStop);

%%
%%  Compute the cross-correlation coefficient between the prospective beat
%%  and the current mean beat
%%
CC = PBeat' * MeanBeat.Beat / ...
    (sqrt(PBeat' * PBeat) * sqrt(MeanBeat.Beat' * MeanBeat.Beat));

%%
%%  If the CC is greater than the minimum CC replace the oldest beat in the ...
%%  matrix and recompute the mean beat.
%%
if CC >= MeanBeat.MinCC
    MeanBeat.BeatMatrix(:, MeanBeat.NextBeat) = PBeat;
    MeanBeat.NextBeat = rem(MeanBeat.NextBeat, MeanBeat.nBeats) + 1;
    MeanBeat.Beat = sum(MeanBeat.BeatMatrix')' ./ MeanBeat.nBeats;
    flg = 1;
else
    flg = 0;
end
