%APP_EQAP           Apply equalization and amplitude and phase coeffiecients
%                   to CPIs in current workspace.
%
%  OUTPUT VARIABLES:
%    cpi[1-N]       The equalized and calibrated data.
%
%    calflg         Calibration flag, set to 1.
%
%    flgError       Set if there is an error in processing.
% 
%  INPUT VARIABLES:
%    cpi[1-N]       The unequalized and calibrated CPIs.
%
%    fxmit          The transmit frequency for each CPI [Hertz].
%
%    npulses        The number of pulse in each CPI.
%
%    heq            OPTIONAL: The equalization coefficient matrix.
%
%    apcal          OPTIONAL: The amplitude and phase calibration coefficient
%                   matrix.
%
%    fcal           OPTIONAL: The frequencies at which apcal was computed.
%
%    flgRound       OPTIONAL: Round the equalized and calibrated data to the
%                   nearest integer.  This halves the amount of space
%                   necessary to store the output file (default: 1).
%
%    Calls: convmpmc.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:25 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: app_eqap.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:25  rickg
%  Matlab Source
%
%  
%     Rev 1.2   02 Feb 1994 10:05:58   rjg
%  fcal is now only required if a calibration is to be performed.
%  flgError is now left in the workspace for the calling program to read.
%  
%     Rev 1.1   19 Jan 1994 17:10:36   rjg
%  Added optional rounding of ouput matricies (CPIs) and allowed for either
%  equalization or calibration or both instead of always both.
%  
%     Rev 1.0   06 Jan 1994 17:27:52   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%    Default parameters
%%
if ~(exist('flgRound') == 1),
    flgRound = 1;
end

%%
%%    Initialization
%%
flgChopTrans  = 1;
flgError      = 0;
calflg        = 0;
flgEqualize   = 0;
flgCalibrate  = 0;

if (exist('heq') == 1),
    flgEqualize = 1;
end

if (exist('apcal') == 1) & (exist('fcal') == 1),
    flgCalibrate = 1;
end

%%
%%    Compute the number of CPIs to be processed.
%%
nCPI = length(fxmit);

%%
%%    Check that there are amplitude and phase calibration coefficients
%%    available for each frequency.
%%
if flgCalibrate,
    for CurrFreq = fxmit(:).' ,
        if ~any(CurrFreq == fcal),
            disp([ ...
                'Amplitude and phase calibration coefficients not available for ' ...
                num2str(CurrFreq / 1e6) ' MHz.']);
            flgError = 1;
        end
    end
end

if flgError == 1,
    error('APP_EQAP: Missing AP cal frequency.')
end

%%
%%    Get the size of the equlization filter, this is the starting point 
%%    of the equalized filter
%%
if flgEqualize,
    [nEQFilt nChan] = size(heq);
end


%%
%%    Loop over each CPI equalizing and calibrating if required
%%
for idxCPI = 1:nCPI

    %%
    %%    Generate the name of the current CPI
    %%
    strCurrCPI = ['cpi' int2str(idxCPI)];
    CPI = eval(strCurrCPI);
    %%
    %%    Equalize the CPI
    %%
    if flgEqualize,
        disp(['Equalizing : ' strCurrCPI ' ...']);
        CPI = convmpmc(CPI, heq, npulses(idxCPI), flgChopTrans);
    end

    %%
    %%    Amplitude and phase calibrate the CPI
    %%
    if flgCalibrate,
	disp(['Calibrating : ' strCurrCPI ' ...']);
        idxAP = find(fxmit(idxCPI) == fcal);
        [nRowsCPI nColsCPI] = size(CPI);
        CPI = CPI .* (ones(nRowsCPI,1) * apcal(:, idxAP).');
    end

    %%
    %%    Copy corrected CPI back into current CPI.
    %%
    if flgRound,
        eval([strCurrCPI '=round(CPI);']);
    else
        eval([strCurrCPI '=CPI;']);
    end
end
calflg = 1;

clear CPI CurrFreq flgChopTrans idxAP idxCPI nCPI nChan nColsCPI nEQFilt
clear nRowsCPI strCurrCPI flgRound flgEqualize flgCalibrate
