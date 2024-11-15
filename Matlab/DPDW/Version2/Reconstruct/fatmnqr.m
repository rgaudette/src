%FATMNQR        Minimum norm solution to a fat system using QR factoriztion.
%
%   xmn = fatmnqr(A, b)
%
%   xmn         The minimum norm solution.
%
%   A           The under-determined matrix (short and fat, m > n).
%
%   b           The measurement vector.
%
%
%   FATMNQR computes the minimum norm solution using a QR factorization of
%   A'.
%
%   Reference: Matrix Computations,  Golub & Van Loan, 2nd Ed. pg 257-258.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:08 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: fatmnqr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:08  rickg
%  Matlab Source
%
%  Revision 1.1  1998/06/03 16:09:20  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function xmn = fatmnqr(A, b)
[m n] = size(A);
[Q R] = qr(A', 0);
z = R' \ b;
xmn = Q * z;
