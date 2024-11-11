%LCURVE1
%
%   [Cost, Resid] = lcurve1(A,b, Lambdas, J)
%

function [Cost, Resid] = lcurve1(A,b, Lambdas, J)

nPts = length(Lambdas);
Resid = zeros(nPts, 1);
Cost = zeros(nPts, 1);
for i = 1:nPts
    x = inv(A' * A + Lambdas(i) * J) * A' * b;
    Resid(i) = sum((A * x - b) .^ 2);
    Cost(i) = sum((J * x) .^ 2);
end

hold on
plot(Cost, Resid, 'r');
hold off