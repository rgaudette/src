%GIVENS         Generate a Givens rotation matrix.
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
%  $Log: givens.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [c s] = givens(a, b)

if b == 0
    c = 1;
    s = 0;
else
    if abs(b) > abs(a)
        tau = -a/b;
        s = 1/sqrt(1 + tau^2);
        c = tau * s;
    else
        tau = -b/a;
        c = 1/sqrt(1 + tau^2);
        s = tau * c;
    end
end

