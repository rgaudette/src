%GIVENS2        Generate a Givens rotation matrix.
%
%   [c s] = givens(a, b)
%
%   c           The cosine or diagonal term of the Givens matrix.
%
%   s           The sine or anti-diagonal term.
%
%   a           The vector element to preserve.
%
%   b           The vector element to anihilate.
%
%
%   GIVENS returns the paramters of a matrix that will zero out the specified
%   element of a vector.  Specifically,
%
%   | c -s| |a|   |r|
%   | s  c| |b| = |0|
%
%
%   Reference: Matrix Computations, Golub & VanLoan, pp 202.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:08 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: givens2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [c, s] = givens2(a, b)

if b == 0
    c = 1;
    s = 0;
else
    den = sqrt(a^2 + b^2);
    c = a / den;
    s = -b / den;
end

