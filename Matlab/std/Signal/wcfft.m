%WCFTT          Windowed column fft.
%
%    Y = wcfft(X, nFFT, Window, SLL)
%
%    Y          The transformed matrix.
%
%    X          The matrix to be transformed, transforms occur along columns.
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
%    Calls: windfn
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
%  $Log: wcfft.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:20  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:12:50  rjg
%  Initial revision
%
%  
%     Rev 1.0   03 May 1994 14:48:18   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y = wcfft(X, nFFT, Window, SLL)

[nRow nCol] = size(X);

%%
%%    Generate a data window matrix
%%
if nargin > 3
    mWin = windfn(nRow, Window, SLL) * ones(1, nCol);
else
    mWin = windfn(nRow, Window) * ones(1, nCol);
end

%%
%%    Compute the windowed FFT.
%%
Y = fft(X .* mWin, nFFT);
