%VAL_BF        Validation system beamformer
%
%    CPIrp = val_bf(CPImc, nPulses, FXmit, FCntrArray, Config, Angle, ...
%                   Window, SLL)
%
%    CPIrp      The range-pulse CPI output.  
%
%    CPImc      The RSTER multi-channel PCI to process.
%
%    nPulses    The number of pulses present in CPImc.
%
%    FXmit      The transmitter frequency [Hertz].
%
%    FCntrArray The array center frequency [Hertz].
%
%    Config     The array configuration.  This should be one of the following
%               strings (not case sensitive),
%                       'rster'
%                       'rster-90'
%                       'e2c'
%
%    Angle      The angle off boresight at which to point the peak response of
%               the beamformer coefficients [degrees].
%
%    Window     The window function to apply to the data identified by the code
%               below,
%                       0 - Uniform
%                       1 - Hamming
%                       2 - Hanning
%                       3 - Chebyshev
%                       4 - Kaiser-Bessl
%
%    SLL        The data window sidelobe level.  If the selected window does
%               not require a parameter this value is ignored.
%
%
%    Calls: svrster, svrst90.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:26 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: val_bf.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:26  rickg
%  Matlab Source
%
%  
%     Rev 1.0   02 May 1994 20:19:24   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function CPIrp = val_bf(CPImc, nPulses, FXmit, FCntrArray, Config, Angle, ...
                        Window, SLL)

%%
%%    Extract structure sizes
%%
[nSamp nCh] = size(CPImc);
nRangeGates = nSamp / nPulses;

%%
%%    Generate beamformer coefficients
%%
if strcmp(lower(deblank(Config)), 'rster'),
    W = svrster(nCh, Angle, FXmit / FCntrArray, Window, SLL);
end
if strcmp(deblank(lower(Config)), 'rster-90'),
    W = svrst90(nCh, Angle, FXmit / FCntrArray, Window, SLL);
end

%%
%%    Apply beamformer to multi-channel CPI and reshape to a range-pulse CPI.
%%
CPIrp = CPImc * conj(W);

CPIrp = reshape(CPIrp, nRangeGates, nPulses);
