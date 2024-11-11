%ROWSCALE       Scale the rows of a matrix or array.
%
%   As = rowscale(A, c)
%
%   As          The row scaled array.
%
%   A           The input array.
%
%   c           The scaling coefficients.  This have same number of rows as
%               A and either one column or the same number of columns as the
%               third dimension of A.
%
%
%
%   Calls: none.
%
%   Bugs: only handles arrays upto 3 dimension.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:44 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rowscale.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:44  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function As = rowscale(A, c)

[m n p] = size(A);
[cm cn] = size(c);

if cm ~= m
    error('A and c must have the same number of rows')
end
if cn ~= p & cn ~= 1
    error(['c must have the same number of columns as the planes in A or a' ...
        single column']);
end
if p > 1 & cn == 1
    c = repmat(c, 1, p);
end

As = zeros(size(A));
for ip = 1:p
    for ir = 1:m
        As(ir, :, ip) = A(ir,:,ip) * c(ir, ip);
    end
end
