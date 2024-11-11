%=============================================================================
%
%                          ===>>>  GETSNAP.M  <<<===
%_____________________________________________________________________________
%
%   PROGRAMMER : Jim Ward
%
%   DATE   CODE: 25 August 91
%   UPDATE CODE: 25 August 91
%_____________________________________________________________________________
%
%   DESCRIPTION: A function that returns a matrix of random snapshots
%                for a linear array, for a given size array, and a
%                given signal scenario (aoas, snrs).
%_____________________________________________________________________________
%
%   USAGE: x=getsnap(aoa,snrdb,nel,nsnap)
%_____________________________________________________________________________
%
%   INPUTS : aoa     : a ROW vector of signal arrival angles (degrees).
%            snrdb   : a vector of signal SNRs (dB) -- same size as aoa
%            nel     : number of array elements
%            nsnap   : number or snapshots to
%
%   OUTPUTS: x       : an nel x nsnap matrix whose columns are
%                       independent snapshots of simulated array data.
%_____________________________________________________________________________
%
%   CALLED BY   :
%
%   CALLS TO    : NONE
%
%=============================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:37 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: getsnap.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:37  rickg
%  Matlab Source
%
%  
%     Rev 1.0   18 Feb 1993 10:29:18   root
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x] = getsnap(aoa,snrdb,nel,nsnap)

%---> Gaussian noise samples.

xn = 1 / sqrt(2) * (randn(nel,nsnap)+j*randn(nel,nsnap)) ; % noise samples

%---> Signal samples.

[nr,nsig] = size(aoa) ;
u    = svlin(nel,aoa) ;
snr  = (10 * ones(nr,nsig)).^(0.1*snrdb) ;
samp = sqrt(snr) ;

%    uniform phase noise.
ss = diag(samp) * exp(j*2*pi*rand(nsig,nsnap)) ;
xs = u * ss ;

%---> Form snapshots -- signal plus noise.

x = xs + xn ;

return
