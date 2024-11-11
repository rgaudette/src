%APC_REF            Generate amplitude and phase coefficients using the given
%                   channel for a reference.
%
%####################################################################
%
%                 ===>>>  APC_REF.M  <<<===
%____________________________________________________________________
%
% Programmer:  Jim Ward
%
% Date Code:   10 May 92
% Update Code: 30 June 92
%              05 Jan 94 rjg
%              Modified code to allow for selection of reference channel
%              Changed name from apcmp to apc_ref
%              Placed into my config control
%____________________________________________________________________
%
% Description: a function that computes amplitude and phase corrections
%              to align multichannel data, for the RSTER with the correct
%              tilt compensation cables. This routine can be used for
%              a crude equalization of RSTER data.
%
%              This routine is used for ACAL and Assateague calibrations
%
%              A simple least squares complex weight to match each
%              channel with channel 1 of the data is determined and
%              taken to be the amplitude and phase correction.
%____________________________________________________________________
%
% USAGE:  apcal = apc_ref(z, f0, thcal, thtilt, iref)
%____________________________________________________________________
%
% INPUTS: z     -- data matrix (nsamp x nch) from which to compute cals
%         f0    -- Center frequency of calibration signal (in Hz).
%         thcal -- angle of calibration source:
%                  e.g. 0 degrees if Assateague or Mt. Wachusett
%                       0 degrees if injected at ACAL port
%         thtilt-- OPTIONAL: Tilt angle of the array, 10 for RSTER, 0 for
%                  RSTER-90 (default: 10).
%         iref  -- OPTIONAL: the chanel to use as the reference channel
%                  1 => nch (default: 1)
%____________________________________________________________________
%
% OUTPUTS: apcal -- a vector of complex weights (amplitude and phase
%                   corrections) that line up the signals.
%____________________________________________________________________
%
% FUNCTION CALLS:   cancel
%
%####################################################################

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:25 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: apc_ref.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:25  rickg
%  Matlab Source
%
%  
%     Rev 1.1   06 Jan 1994 09:32:48   rjg
%  Added optional tilt parameter to account for both RSTER and RSTER-90.
%  
%     Rev 1.0   05 Jan 1994 13:59:34   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function apcal = apc_ref(z, f0, thcal, thtilt, iref)

%%
%%    Default arguments
%%
if nargin < 5,
    iref = 1;
    if nargin < 4,
        thtilt = 10;
    end
end

frat = f0/450e6;
[nsampz nch] = size(z);

%%
%%    Inter inter-row phase shift from a source at elevation angle thcal
%%    (including the correct tilt compensation cables)
%%
dtr = pi / 180;
gamma = pi * frat * (sin((thcal - thtilt) * dtr) + sin(thtilt * dtr)) ;

%%
%%    Compute amplitude and phase corrections
%%
apcal = ones(nch, 1);
crdb = zeros(nch, 1);

for ich = 1:nch,
    z0 = exp(j * (ich - iref) * gamma);
    if ich ~= iref,
        [crdb(ich) resdb apcal(ich)] = cancel(z(:,iref) * z0, z(:,ich));
    end
end

return
