function [Q, R] = qrgivens(A)

[m n] = size(A);
Q = eye(m);
R = A;
for iCol = 1:n
    for iRow = m:-1:(iCol+1)
        [c s] = givens1(R(iRow-1,iCol),R(iRow,iCol));
        R([iRow-1 iRow], iCol:n) = grot_row(R([iRow-1 iRow], iCol:n), c, s);
        Q([iRow-1 iRow], :) = [c -s; s c] * Q([iRow-1 iRow], :);
    end
end
Q = Q';

