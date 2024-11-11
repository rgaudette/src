%####################################################################
%
%                 ===>>>  APCMP.M  <<<===
%____________________________________________________________________
%
% Programmer:  Jim Ward
%
% Date Code:   10 May 92
% Update Code: 30 June 92
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
% USAGE:  apcal = apcmp(z,thcal,f0)
%____________________________________________________________________
%
% INPUTS: z     -- data matrix (nsamp x nch) from which to compute cals
%         thcal -- angle of calibration source:
%                  e.g. 0 degrees if Assateague or Mt. Wachusett
%                       0 degrees if injected at ACAL port
%         f0    -- Center frequency of calibration signal (in Hz).
%____________________________________________________________________
%
% OUTPUTS: apcal -- a vector of complex weights (amplitude and phase
%                   corrections) that line up the signals.
%____________________________________________________________________
%
% FUNCTION CALLS:   cancel
%
% MODIFICATIONS:
%    08-SEP-93 rjg
%        Changed the reference channel to 8 from 1 because some of the
%        Hot Clutter measurements have a dipole and different receiver
%        in channel 1, also there is no acal switch for channel 1 when
%        using the dipole.
%####################################################################

function apcal=apcmp(z,thcal,f0)

%%
%%    Initialization
%%
iref = 8;
%%
%%    Get frequency ratio and signal strucure size.
%%
frat = f0 / 450e6;
[nsampz nch] = size(z);


%%
%%    Inter inter-row phase shift from a source at elevation angle thcal
%%    (including the correct tilt compensation cables)
%%
thtilt = 10;
dtr = pi / 180;
gamma = pi * frat * (sin((thcal - thtilt) * dtr) + sin(thtilt * dtr));


%%
%%    Preallocate correction vector and cancelation ratio
%%
apcal=ones(nch,1);
crdb=zeros(nch,1);

%%
%%    Loop over each channel
%%
for ich=1:nch,
    %%
    %%    Correct channel for different receiver cable lengths.
    %%
    z0 = exp(j * (ich - iref) * gamma);

    %%
    %%    If not the reference channel compute the amplitude & phase cal.
    %%
    if ich ~= iref,
         [crdb(ich) resdb apcal(ich)] = cancel(z(:,iref) * z0, z(:,ich));
    end
end

return
