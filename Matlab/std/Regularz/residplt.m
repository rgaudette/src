%RESIDPLT       Plots the residual(s)

function hPlt = residplt(A, b, X, J)

Resid = A * X - b * ones(1,size(X, 2));
SqErr = sum(Resid .^ 2);
Cost = sum((J*X) .^ 2);

hold on
plot(Cost, SqErr, 'g');
plot(Cost, SqErr, 'xg');
hold off