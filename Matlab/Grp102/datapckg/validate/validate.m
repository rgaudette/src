%VALIDATE       This script runs a validation suite on the currently loaded data.
%
%    validate
%
%    Input variables:
%        A complete RSTER Matlab file.
%        MissID
%        MissFile
%
%
%    Output variables:
%
%
%    Calls: vsetdef, rawchplt, val_cbs, val_cas.
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
%  $Log: validate.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:26  rickg
%  Matlab Source
%
%  
%     Rev 1.1   04 May 1994 16:07:34   rjg
%  
%     Rev 1.0   03 May 1994 16:55:42   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
%%    Initialization
%%
flgError = 0;
nCPI = length(npulses);
Config = info(2,:);

MissDate = [int2str(cpitime(1, 2)) '/' int2str(cpitime(1,3)) '/' ...
            int2str(cpitime(1,1) - 1900)];


%%
%%    Create a Mission Description from the Miss info given.
%%
MissDesc = [ MissID ' ' MissDate ' ' MissFile];


%%
%%    Setup defaults for anything that does not exist.
%%
vsetdef;


%%
%%    Scale data to SNR level for CPIs to be validated.
%%    If the data is in ADC format BQS all of the CPIs to be validated
%%
disp('Scaling data to SNR level...')
if muxtype == 1,
    disp('ADC data, don''t know what the scale factor is yet');
    error('Error: Not yet ready to handle ADC data need tp put in dbqs filter');
elseif muxtype == 2,
    disp('    Scaling BQS data to SNR level');
    AmplitudeOffset = 47.4;
    ScaleFctr = 1 / 10 ^ (AmplitudeOffset / 20);

    for idxCPI = lstCPI
        strCPI = ['cpi' int2str(idxCPI)];
        eval([strCPI ' = ' strCPI ' * ScaleFctr ; ']);
    end

elseif muxtype == 3,
    disp('EQU data, don''t know what the scale factor is yet');

else
    disp(['Error: Unknown muxtype for data, muxtype = ' num2str(muxtype)])
    flgError = 1;
    return;
end


%%
%%    Plot the raw channel response for each pulse of each selected CPI. 
%%
for idxPlot = 1:length(lstCPI)

    idxCPI = lstCPI(idxPlot);
    idxPulse = lstPulse(idxPlot);
    strCPI = ['cpi' int2str(idxCPI)];
    strMissDesc = [MissDesc '  CPI #' int2str(idxCPI)];
    strPrintFile = [MissFile '_CPI' int2str(idxCPI)];

    rawchplt(eval(strCPI), npulses(idxCPI), idxPulse, trecord, strMissDesc, ...
        strPrintFile);
end


%%
%%    Call conventional beamspace validation processing for each CPI
%%
disp('Conventional beam-space processing ...');
for idxCPI = lstCPI,
    CPImc = eval(['cpi' num2str(idxCPI)]);
    strMissDesc = [MissDesc '  CPI # ' int2str(idxCPI)];
    strPrintFile = [MissFile '_CPI' int2str(idxCPI)];
    val_cbs(CPImc, strcRSDS, lstPulse, bfAngle, bfWindow, bfSLL, nFFT, fftWindow, ...
        fftSLL, strMissDesc, FCntrArray, Config, strPrintFile)
end


%%
%%    Call conventional azimuth space validation processing for each CPI
%%
disp('Conventional Azimuth-space processing ...');
for idxCPI = lstCPI,
    CPImc = eval(['cpi' num2str(idxCPI)]);
    strMissDesc = [MissDesc '  CPI # ' int2str(idxCPI)];
    strPrintFile = [MissFile '_CPI' int2str(idxCPI)];

    val_cas(CPImc, strcRSDS, lstPulse, lstRG, ...
            az_nFFT, azWindow, azSLL, ...
            nFFT, fftWindow, fftSLL, ...
            strMissDesc, strPrintFile);
end
