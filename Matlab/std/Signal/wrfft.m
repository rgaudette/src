%WRFTT          Windowed row fft.
%
%    Y = wrfft(X, nFFT, Window, SLL)
%
%    Y          The transformed matrix.
%
%    X          The matrix to be transformed, transforms occur along rows.
%
%    nFFT       The number of points to compute for each transform.
%
%    Window     The data window to apply to each row.
%                   0 - Uniform
%                   1 - Hamming
%                   2 - Hanning
%                   3 - Chebyshev
%                   4 - Kaiser-Bessel
%                   5 - Binomial
%
%    SLL        OPTIONAL: The sidelobe parameter of the window, nce
%
%
%
%    Calls: wcfft.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:20 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: wrfft.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:20  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:12:57  rjg
%  Initial revision
%
%  
%     Rev 1.0   03 May 1994 14:48:30   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y = wrfft(X, nFFT, Window, SLL)

if nargin > 3
    Y = (wcfft(X.', nFFT, Window, SLL)).';
else
    Y = (wcfft(X.', nFFT, Window)).';
end