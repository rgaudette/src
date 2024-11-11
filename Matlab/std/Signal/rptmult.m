%RPTMULT        Multiply a vector repeatedly over a matrix.
%
%    Y = rptmult(X, v);
%
%    Y          The output matrix.
%
%    X          The input matrix.
%
%    v          The vector to multiply by the matrix.
%
%
%        RPTMULT will multiply the given matrix repeatedly by the given vector.
%    If v is a row vector it will element by element multiply v by each row of
%    of X.  In this case v must have the same number of columns as X. If v is
%    a column vector it will element by element multiply v by each column of X.
%    For this case v must have the same number of rows as X.
%
%    Calls: none.
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
%  $Log: rptmult.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:20  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:12:02  rjg
%  Initial revision
%
%  
%     Rev 1.0   10 Apr 1994 17:33:50   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y = rptmult(X, v)

%%
%%    Findout whether v is a row or column vector.
%%
[nVrow nVcol] = size(v);
[nXrow nXcol] = size(X);

%%
%%    Perform the appropriate multiplication.
%%
if nVrow == 1,
    Y = X .* (ones(nXrow, 1) * v);

elseif nVcol == 1,
    Y = X .* (v * ones(1, nXcol));

else
    error('v must be a vector');
end
