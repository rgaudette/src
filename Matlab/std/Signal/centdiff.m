%CENTDIFF       Compute the central difference of a sequence.
%
%    Y = centdiff(X)
%
%    Y          Central difference matrix (M-2 x N).
%
%    X          Input matrix of signal, each comlumn is considered a signal.
%
%        CENTDIFF compute the central difference along the columns of X.
%    The sequence(s) returned are 2 elements shorter due difference equation,
%
%        y(n) = x(n+1) - x(n-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:18 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: centdiff.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:18  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:05:08  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y = centdiff(X)

[M N] = size(X);

Y = X(3:M,:) - X(1:M-2,:);