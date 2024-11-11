%FFTSWAP        Swap the halves of each column of an array.
%
%    y = fftswap(x)
%
%    y		Swapped matrix.
%
%    x		Input matrix.
%
%        FFSWAP swaps the first and second halves of all columns in x.  This
%    function is provided because FFTSHIFT swaps quadrants when passed a
%    matrix.  This is useful when using FFT on column data in a matrix.
%
%    Calls: none
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:19 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: fftswap.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:19  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:11:39  rjg
%  Initial revision
%
%  
%     Rev 1.1   21 Mar 1994 17:43:32   rjg
%  Added comments and help descriptions.
%  
%     Rev 1.0   17 Mar 1993 16:11:54   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = fftswap(x)

%%
%%    Find the middle row of x
%%
[rows cols] = size(x);
MidRow = ceil(rows / 2);

%%
%%    Swap the top and bottom halves of the array.
%%
y = x([MidRow+1:rows 1:MidRow], :);

