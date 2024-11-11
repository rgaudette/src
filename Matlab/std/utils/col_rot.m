%COL_ROT        Rotate the columns of an array.
%
%    Y = col_rot(X, idxStart)
%
%    Y          The resultant array.
%
%    X          The array to be rotated.
%
%    idxStart   The row of X to become the first row of Y.
%
%
%        COL_ROT rotates the each column of X such that the row given by
%    idxStart becomes the first row of Y.
%
%    Calls: none.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:24 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: col_rot.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:24  rickg
%  Matlab Source
%
%  
%     Rev 1.1   22 Mar 1994 10:20:50   rjg
%  Updated help description and renamed variables.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y = col_rot(X, idxStart)

[nRow nCol] = size(X);
Y = X([idxStart:nRow 1:(idxStart-1)],:);
