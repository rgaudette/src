%CON_RVDS       Construct a RSTER Validation Data Structure.
%
%    strcRVDS = con_rvds(lstCPI, lstPulse, ...
%        bfAngle, bfWindow, bfSLL, ...
%        nFFT, fftWindow, fftSLL)
%
%    strcRVDS   The RSTER Validation Data Structure
%
%    
%
%    
%
%
%        TEMPLATE Describe function, it's methods and results.
%
%    Calls: none.
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
%  $Log: con_rvds.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:26  rickg
%  Matlab Source
%
%  
%     Rev 1.0   02 May 1994 14:56:56   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function strcRVDS = con_rvds(lstCPI, lstPulse, bfAngle, bfWindow, bfSLL, ...
                             nFFT, fftWindow, fftSLL)

%%
%%    Compute the size of the structure
%%
nInfo = 3;
nScalars = 6;
nStructLen = nInfo + nScalars + length(lstCPI) + length(lstPulse);

strcRVDS = zeros(1,nStructLen);

%%
%%    Create the data structure
%%
strcRVDS(1) = 1.0;
strcRVDS(2) = length(lstCPI);
strcRVDS(3) = length(lstPulse);
strcRVDS(4) = bfAngle;
strcRVDS(5) = bfWindow;
strcRVDS(6) = bfSLL;
strcRVDS(7) = nFFT;
strcRVDS(8) = fftWindow;
strcRVDS(9) = fftSLL;

strtLstCPI = 10;
idxLstCPI = [strtLstCPI:strtLstCPI+length(lstCPI)-1];
strcRVDS(idxLstCPI) = lstCPI(:).';

strtLstPulse = max(idxLstCPI) + 1;
idxLstPulse = [strtLstPulse:strtLstPulse+length(lstPulse)-1];
strcRVDS(idxLstPulse) = lstPulse(:).';
