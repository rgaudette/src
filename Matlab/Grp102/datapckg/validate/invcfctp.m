%INVCFCTP       Invoke the calibration factor plotting function.
%
%    invcfctp
%
%
%        INVCFCTP invokes the function CFCTRPLT with the appropriate arguments
%    depending upon the variable available in the workspace.  It first looks to
%    see if the following variables exist in the workspace,
%
%        apcal      - the amplitude and phase calibration matrix.
%        fcal       - the frequency corresponding to each column of apcal.
%        heq        - the time domain channel equalization coefficients.
%        MissDesc   - a text string placed in the title of the plots.
%        PrintFile  - the filename to save the various EPS files to.
%
%    All of the variables are optional with the stipulation that fcal be present
%    if apcal exists.  If PrintFile does not exist in the workspace the default
%    behavior is to set PrintFile to 'val'.  It the invokes CFCTPLT with the
%    correct parameters.
%
%    Calls: cfctrplt
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
%  $Log: invcfctp.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:26  rickg
%  Matlab Source
%
%  
%     Rev 1.1   03 May 1994 11:13:46   rjg
%  EPS file automatic printing removed.
%  
%     Rev 1.0   02 May 1994 14:57:30   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flgError = 0;
flgForcePrint = 0;

%%
%%    Check to see if MissDesc exists
%%
if ~(exist('MissDesc') == 1),
    MissDesc = '';
end

%%
%%    Check if PrintFile exists
%%
if ~(exist('PrintFile') == 1),
    flgForcePrint = 1;
    PrintFile = 'val';
end


%%
%%    Check to make sure the necessary variables exists
%%
if ~(exist('apcal') == 1),
    flgError = 1;
    disp('Did not find variable: apcal')
end

if ~(exist('fcal') == 1),
    flgError = 1;
    disp('Did not find variable: fcal')
end

if ~(exist('heq') == 1),
    flgError = 1;
    disp('Did not find variable: heq')
end

%%
%%    Invoke calibration factor plotting function.
%%
cfctrplt(apcal, fcal, heq, MissDesc, PrintFile);
