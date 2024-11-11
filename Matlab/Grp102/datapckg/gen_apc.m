%GEN_APC 	    Amplitude & phase coefficient generation script.
%
%  OUTPUT VARIABLES:
%    apcal          Matrix of amplitude & phase coefficients, this is a
%                   nChannel x nFreq matrix.
%
%    fcal           The frequencies corresponding to each column of apcal [Hz].
%
%  INPUT VARIABLES:
%    RefChan        The index of the reference channel.
%
%    cpi1-N         The CPI to be used to generate the coefficients.
%
%    fxmit          The transmit frequency of each pulse in the CPI [Hz].
%
%    npulses        The number of pulses per CPI for each CPI present.
% 
%    wrecord        The number of range samples per pulse in the CPI.
%
%
%    heq            OPTIONAL: If present these equalization coefficients
%                   will be applied to the calibration signal before computing
%                   the amplitude and phase calibration coefficients.
%
%    ThetaTilt      OPTIONAL: Tilt angle of the array, 10 for RSTER, 0 for
%                   RSTER-90 [degrees] (default: 10).
%
%    ThetaCal       OPTIONAL: Angle of the calibration source [degrees]
%                   (default: 0).
%
%        GEN_APC computes the amplitude and phase calibration coefficeints
%    using the CPI data available in the global workspace.  A coefficient
%    vector is produced for each unique frequency specified in fxmit.  The
%    input CPIs may be either ADC or BQS data.  If they are ADC data they
%    will be transformed to baseband before processing.  If equalization data
%    is present the CPIs will also be equalized.  The routine selects the
%    largest contiguous region of the signal that is 90% of the peak to use
%    for coefficient generation, thus this routine expects pulsed data.
%
%    Calls: dbqs, equalize, det_srch, apc_ref.
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
%  $Log: gen_apc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:26  rickg
%  Matlab Source
%
%  
%     Rev 1.3   06 Jan 1994 10:44:28   rjg
%  Fixed bug to suppress output of Peak and Range values.
%  
%     Rev 1.2   06 Jan 1994 09:37:52   rjg
%  Added optional antenna tilt angle to compensate for both RSTER and RSTER-90.
%  
%     Rev 1.1   06 Jan 1994 09:18:32   rjg
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%    Initialization parameters
%%
nDBQSTransient = 20;

if ~exist('ThetaCal') == 1,
    ThetaCal = 0;
end

if ~exist('ThetaTilt') == 1,
    ThetaTilt = 10;
end

%%
%%    Compute the number of unique frequencies in fxmit, this assumes
%%    that the CPIs cycle through the frequencies in a repeating pattern.
%%
idxFirstFreq = find(fxmit == fxmit(1));

if length(idxFirstFreq) > 1,
    nFreqs = idxFirstFreq(2) - 1;
else
    nFreqs = 1;
end

fcal = fxmit(1:nFreqs);

%%
%%    Compute the number of pulses in the CPI
%%
[nSampTot nChannels] = size(cpi1);
apcal = zeros(nChannels, nFreqs);

%%
%%    For each unique frequency present compute a set of coefficients.
%%

for idxCPI = 1:nFreqs,

    %%
    %%    Generate name of current CPI and extract a single pulse
    %%
    strCurrCPI = ['cpi' int2str(idxCPI)];
    [nSampTot nChannels] = size(eval(strCurrCPI));
    nRangeGates = nSampTot / npulses(idxCPI);
    cpi = eval([strCurrCPI '(1:' int2str(nRangeGates) ',:)' ]);

    %%
    %%    Baseband Quadrature Demodulate the CPI if necessary
    %%
    if muxtype == 1,
        cpi = dbqs(cpi);
	[nSampTot nChannels] = size(cpi);
        cpi = cpi(1+nDBQSTransient:nSampTot-nDBQSTransient,:);
    end

    %%
    %%    If the equalization coefficeint matrix exists equalize the
    %%    the data.
    %%
    if exist('heq') == 1,
        cpi = equalize(cpi, heq);
    end

    %%
    %%    Select the region of the pulse to use for coefficient generation,
    %%    using the reference channel.
    %%        - find the peak of the pusle
    %%        - find largest region > 90% of the peak
    %%
    Peak = max(abs(cpi(:,RefChan)));
    Range = det_srch(cpi(:, RefChan), 0.9 * Peak);

    %%
    %%   Compute amplitude and phase coefficients.
    %%
    apcal(:, idxCPI) = ...
        apc_ref(cpi(Range(1):Range(2), :), fxmit(idxCPI), ...
            ThetaCal, ThetaTilt, RefChan);
end

clear Peak Range cpi idxCPI idxFirstFreq nChannels nDBQSTransient
clear nFreqs nRangeGates nSampTot strCurrCPI 