%FOCUSS1        FOCal Underdetermined System Solver.
%
%   [xf q] = focuss(A, b, nIter, xprev)
%
%   xf          The FOCUSS solution
%
%   q           The column selection vector
%
%   Optional    OPTIONAL: This parameter is optional (default: value).
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none.
%
%   Bugs: none known.
%
%   Ref: Gorodnitsky

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:31 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: focuss1.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:31  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xf, q] = focuss(A, b, nIter, xprev)

%%
%%  If xinit is not present then compute the min. norm solution
%%
if nargin < 4
    xprev = fatmn(A, b);
end

for i = 1:nIter
    Aw = A * diag(xprev);
    q = fatmn(Aw, b);
    xf = diag(xprev) * q;
    xpref = xf;
end

