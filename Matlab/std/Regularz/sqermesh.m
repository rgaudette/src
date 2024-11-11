%SQERMESH       Plot the residual square error of a 2-D system
%
%   hSurf = sqermesh(A, b, Range, nPts)
%
%   A           The operator matrix
%
%   b           The right hand side of the equation Ax=b
%
%   Range       The range of x1 and x2 to calculate [x1min x1max x2min x2max]
%
%   nPts        The number of points in each dimension to calculate [nX1 nX1]

function hSurf = sqermesh(A, b, Range, nPts)

%%
%%  Generate the domain of the surface
%%
x1Dom = linspace(Range(1), Range(2), nPts(1));
x2Dom = linspace(Range(3), Range(4), nPts(2));
[X1 X2] = meshgrid(x1Dom, x2Dom);

%%
%%  Evalate the error at each X1,X2 pair
%%
ErrVec = A * [X1(:)'; X2(:)'] - b * ones(1, prod(nPts));
SqErr = sum(ErrVec .^2);

SqErr = reshape(SqErr, nPts(2), nPts(1));

meshc(X1, X2, sqrt(SqErr));
xlabel('X1');
ylabel('X2');
zlabel('||Ax - b||')
grid
title('Residual Error')
