%MKEGSTRCT      Create an electrogram structure from the given input arguments.
%
%   EGStruct = mkegstrct(Seq, Fs, Units)
%
%   EGStruct    The resultant electrogram structure.
%
%   Seq         The electrogram seqeunce.
%
%   Fs          [OPTIONAL] The sampling rate (default: 250 Sa/s).
%
%   Units       [OPTIONAL] Amplitude units of the electrogram sequence
%               (default: 'Unknown').
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
%  $Log: mkegstrct.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:01  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function EGStruct = mkegstrct(Seq, Fs, Units)


%%
%%  Make sure that Seq is a column vector
%%
Seq = Seq(:);

EGStruct.Seq = Seq;

if nargin > 2
    EGStruct.Units = Units;
    EGStruct.FSamp = Fs;
elseif nargin > 1
    EGStruct.FSamp = Fs;
    EGStruct.Units = 'Unknown';
else
    EGStruct.FSamp = 250;
    EGStruct.Units = 'Unknown';
end
