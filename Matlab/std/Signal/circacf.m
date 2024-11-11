%CIRCACF        Compute the circular auto-correlation function of a sequence.
%
%    CACF = circacf(Seq)
%
%    CACF	Circular auto-correlation sequence.
%
%    Seq	The sequence to be auto-correlated.
%
%        CIRCACF generates the circular auto-correlation of the given sequence
%    by FFT'ing the sequence (without zero padding), multiplying the result by
%    it's conjugate and then inverse transforming the result.
%
%    Calls: none

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:18 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: circacf.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:18  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:10:12  rjg
%  Initial revision
%
%  
%     Rev 1.1   21 Mar 1994 17:18:48   rjg
%  Help description modifications.
%  
%     Rev 1.0   25 Feb 1993 10:25:40   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function CACF = circacf(Seq)
SEQ = fft(Seq);
CACF = ifft(SEQ .* conj(SEQ));
