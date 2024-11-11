%AIR_PROC           Generate range-doppler maps and sigma0 information
%                   from raw Hot Clutter aircraft data.
%
%    Input variables:
%
%    Output variables:
%        see hcproc & air_sig0
%
%    Calls: chebwgt, hcproc, air_sig0
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:28 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: air_proc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:28  rickg
%  Matlab Source
%
%  
%     Rev 1.1   27 Oct 1993 11:28:34   rjg
%  Correction to description.
%  
%     Rev 1.0   28 Sep 1993 09:33:20   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%    Constant parameters
%%
Freq = 435e6;
TxPow = 59.5;
elev = 0;
dop_win = chebwgt(64, 60);
MFC = conj(fft(ones(13,1), 1651));

%%
%%    Load required data and aircraft information
%%
load r1191433v1
load learGPS240

%%
%%    Perform range-doppler processing and range alignment
%%
hcproc

clear cpi1 cpi2 cpi3 cpi4

%%
%%    Extract Sigma0 from range doppler information
%%
air_sig0
