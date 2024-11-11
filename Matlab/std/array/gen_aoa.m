%GEN_AOA	Generate a matrix in which each row represents a different
%               Angle of Arrival for a given linear array.
%
%    matSignal = gen_aoa(Angles, Freq, nElem, Lambda)
%
%    matSignal  Matrix of phase fronts.
%
%    Angles     The angles to produce phase fronts for [radians].
%
%    Freq       The signal frequency to use [Hertz].
%
%    nElem      [OPTIONAL] The number of elements in the array
%               (default: 14).
%
%    Lambda     [OPTIONAL] The array element spacing [meters]
%               (default: 0.333103 meters).
%
%
%	    GEN_AOA generates a matrix of phase fronts that correspond to a
%    a set of CW sources at the angles given by Angles.  The default values
%    present are applicable to RSTER.
%
%    Calls: none.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:03 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: gen_aoa.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:03  rickg
%  Matlab Source
%
%  
%     Rev 1.1   18 Mar 1994 09:47:22   rjg
%  Corrected default value of Lambda and some comments.
%  
%     Rev 1.0   01 Sep 1993 11:46:24   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function matSignal = gen_aoa(Angles, Freq, nElem, Lambda)

%%
%%    Constants
%%
C = 299792458;

%%
%%    Default values
%%
if nargin < 4,
    Lambda = C / 450e6 / 2;
    if nargin < 3,
        nElem = 14;
    end
end

%%
%%    Make sure Angles is a column vector.
%%
Angles = Angles(:);

%%
%%    Compute delta phase per element for each angle.
%%
dPhase = 2 * pi * Freq * Lambda / C * sin(Angles);

%%
%%    Step each delta phase across the array elements, convert to a complex
%%    signal.
%%
matSignal = exp(j * dPhase * [0:nElem-1]);
