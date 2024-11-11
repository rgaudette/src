%GEN_EQAP           Generate the equalization and amplitude and phase
%                   calibration coefficeints.
%
%    [heq apcal fcal] = gen_eqap(fnRCAL, fnACAL, ...
%        RefChan, ThetaTilt, ThetaCal, fnCoef)
%
%    heq            The equalization coefficient matrix.
%
%    apcal          The amplitude and phase calibration coefficient matrix.
%
%    fcal           The frequencies for which amplitude and phase coefficients
%                   were generated [Hertz].
%
%    fnRCAL         The filename for the raw RCAL signals.
%
%    fnACAL         The filename for the raw ACAL signals.
%
%    RefChan        OPTIONAL: The channel to use as a reference channel (all
%                   of the ohter channels will be matched to this one).
%
%    ThetaTilt      OPTIONAL: Tilt angle of the array, 10 for RSTER, 0 for
%                   RSTER-90 [degrees] (default: 10).
%
%    ThetaCal       OPTIONAL: Angle of the calibration source [degrees]
%                   (default: 0).
%
%    fnCoef         OPTIONAL: Output filename for calibration coefficients.
%
%
%    Calls: geteqtd, gen_apc.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:26 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: gen_eqap.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:26  rickg
%  Matlab Source
%
%  
%     Rev 1.1   06 Jan 1994 17:20:28   rjg
%  Updated "calls" description.
%  
%     Rev 1.0   06 Jan 1994 10:45:36   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [heq, apcal, fcal] = gen_eqap(fnRCAL, fnACAL, ...
                                       RefChan, ThetaTilt, ThetaCal, fnCoef)

%%
%%    Default parameters
%%
if nargin < 5,
    ThetaCal = 0;
    if nargin < 4,
        ThetaTilt = 10;
        if nargin < 3,
            RefChan = 1;
        end
    end
end

%%
%%    Initialization
%%
nFIR_EQ = 31;

%%
%%    Generate equalization coeffiecients.
%%
load(fnRCAL)

disp('Generating equalization coefficients ...')
heq = geteqtd(cpi1, RefChan, nFIR_EQ);

%%
%%    Generate amplitude and phase coefficients.
%%
load (fnACAL)
disp('Generating amplitude and phase coefficients ...')
gen_apc

if nargin > 5,
    disp('Saving calibration coefficients ...')
    save(fnCoef, 'apcal', 'fcal', 'heq');
end
