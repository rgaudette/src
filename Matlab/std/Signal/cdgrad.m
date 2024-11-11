%CDGRAD         Compute gradient of a 2-D signal using a central difference 
%               approximation.
%
%    Y = cdgrad(X).
%
%    Y          The gradient estimate using complex notation (M-2 x N-2).
%
%    X          The signal to be measured (M x N).
%
%    NOTE: X must be a square matrix so that the row and column operations can
%         be  recombined.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:18 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: cdgrad.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:18  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:04:20  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y = cdgrad(X)

[M N] = size(X);

%%
%%    Compute the central difference along the columns.  The partial derivative
%%    estimate is the negative of this since it is computed down the columns 
%%    whereas the origin is assumed to be the lower left of the matrix.
%%
dY = -1/2 * centdiff(X);

%%
%%    Compute the central difference along the rows.
%%
dX = 1/2 * centdiff(X');

Y = dX(:,2:N-1)' + j * dY(:, 2:M-1);