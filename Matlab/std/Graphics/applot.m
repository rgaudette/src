%APPLOT         Plot the amplitude and phase of a complex sequence.
%
%   [hAmp hPhase] = applot(Z, flgdB, flgDegrees)
%
%   hAmp        The handle to the Amplitude plot axes object.
%
%   hPhase      The handle to the Phae plot axes object.
%
%   Z           The complex sequence to plot.
%
%   flgdB       [OPTIONAL] Amplitude scale (0: Linear,  1: dB10,  2: dB20)
%               (default: dB20).
%
%   flgDegrees  [OPTIONAL] If true then plot phase in degrees (default: 1).
%
%	APPLOT display the amplitude and phase of the seqeunce Z.
%
%   Calls: none. 
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:05 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: applot.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:05  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/15 22:42:32  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [hAmp, hPhase] = applot(Z, flgdB, flgDegrees)

%%
%%    Default parameters
%%
if nargin < 3,
    flgDegrees = 1;
    if nargin < 2,
        flgdB = 2;
    end
end

clf

%%
%%    Create an axes object for the Amplitude plot.
%%
hAmp = axes('Position', [0.18 0.6 0.7 0.27]);
set(hAmp, 'box', 'on');

%%
%%    Select amplitude plot
%%
if flgdB == 0,
    plot(abs(Z));
elseif flgdB == 1,
    plot(db(abs(Z)));
elseif flgdB == 2,
    plot(db(v2p(Z)))
end

%%
%%    Create an axes object for the Phase plot.
%%
hPhase = axes('Position', [0.18 0.15 0.7 0.27]);
set(hPhase, 'box', 'on');

%%
%%    Select phase plot
%%
if flgDegrees,
    plot(angle(Z) * 180 / pi);
else
    plot(angle(Z));
end