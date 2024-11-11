%HCDET              Threshhold detect a matrix given a noise level for each
%                   element in the matrix.
%
%    mDet = hcdet(mSignal, mNoiseFlr, ThreshDB, NonDetValueDB)
%
%    mDet           The thresholded matrix [magnitude].
%
%    mSignal        The signal matrix to be thresholded [magnitude].
%
%    mNoiseFlr      The noise floor matrix, each element repersents the
%                   noise floor value for the corresponding element in
%                   mSignal [magnitude].
%
%    ThreshDB       The amplitude above the noise floor to threshold the
%                   the signal, in dB.
%
%    NonDetValueDB  [OPTIONAL] The value to set non-detected cells in mDet to
%                   (default: -100 dB).
%
%	    HCDET compares the signal magnitude to the noise floor level
%    for each element in the signal matrix.  If the level not above the noise
%    floor plus the threshold level it is set to the non-detect value.
%    otherwise it is left alone.  mDet, mSignal and mNoiseFlr are expect to be
%    magnitude values, ThreshDB and NonDetValueDB are specified in dB.
%
%    Calls: none
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:30 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: hcdet.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:30  rickg
%  Matlab Source
%
%  
%     Rev 1.0   27 Oct 1993 11:16:00   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mDet = hcdet(mSignal, mNoiseFlr, ThreshDB, NonDetValueDB)

%%
%%    Default input values
%%
if nargin < 4,
    NonDetValueDB = -100;
end

%%
%%    Convert dB values to magnitude
%%
Thresh = 10 .^ (ThreshDB / 10);
NonDet = 10 .^ (NonDetValueDB / 10);

%%
%%    Find elements that are below threshold
%%
idxNoise = find(mSignal < (mNoiseFlr * Thresh));

%%
%%    Set noise values to non-detect level
%%
mDet = mSignal;
mDet(idxNoise) = ones(size(idxNoise)) * NonDet;
