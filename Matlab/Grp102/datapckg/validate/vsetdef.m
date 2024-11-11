%VSETDEF        Set the defaults for a validation suite.
%
%    vsetdef
%
%    Input variables:
%        nCPI       The number of CPIs present in the workspace.
%
%    Output variables:
%        Uniform
%        Hamming
%        Hanning
%        Chebyshev
%        Kaiser
%        lstCPI     The list of CPI numbers to validate.
%        lstPulse   The list of pulse numbers to validate.
%        strcRSDS   The RSTER Signal Data structure.
%        FcntrArray The center frequency of the array Hertz].
%        calflag
%    Calls: none.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:27 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: vsetdef.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:27  rickg
%  Matlab Source
%
%  
%     Rev 1.0   03 May 1994 16:55:52   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lstRG = [134 600];

%%
%%    Data window definitions
%%
Uniform = 0;
Hamming = 1;
Hanning = 2;
Chebyshev = 3;
Kaiser = 4;

%%
%%    Default CPIs and pulses to validate
%%        - the first and last CPI with the first and last pulse respectively.
%%
if exist('lstCPI') ~= 1,
    if nCPI > 1,
        lstCPI = [1 nCPI];
    else
        lstCPI = 1;
    end
end

if exist('lstPulse') ~=  1,
    if npulses(nCPI) > 1,
        lstPulse = [1 npulses(nCPI)];
    else
	lstPulse = 1;
    end
end

%%
%%    Construct the RSTER Signal Data Structure
%%

if exist('calflag') ~= 1,
    calflag = 0;
end

strcRSDS = con_rsds(ant_tilt, azxmit, calflag, cpiidx, cpitime, ...
                   cpitype, elxmit, fxmit, muxtype, npulses, pri, scanidx, ...
                   tpulse, trecord, wrecord);

%%
%%    Set the center frequency of the array
%%
if exist('FCntrArray') ~= 1,
    FCntrArray = 450E6;
end
   
%%
%%    Define a base filename for the output plots.
%%
if exist('PrintFile') ~= 1,
    PrintFile = 'val';
end

%%
%%    Default Validation parameters
%%
if exist('bfAngle') ~= 1,
    bfAngle = 0;
end

if exist('bfWindow') ~= 1,
    bfWindow = Chebyshev;
end

if exist('bfSLL') ~= 1,
    bfSLL = 30;
end

if exist('nFFT') ~= 1,
    nFFT = 32;
end

if exist('fftWindow') ~= 1,
    fftWindow = Chebyshev;
end

if exist('fftSLL') ~= 1,
    fftSLL = 30;
end

if exist('az_nFFT') ~= 1,
    az_nFFT = 32;
end

if exist('azWindow') ~= 1,
    azWindow = Chebyshev;
end

if exist('azSLL') ~= 1,
    azSLL = 30;
end
