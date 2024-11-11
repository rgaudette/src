%CONJGRAD       Conjugate gradient solution to Ax=b
%
%

function X = conjgrad(A, b, x0, nMax)


%%
%%  Initializations
%%
[nR nC] = size(A);
X = zeros(nC, nMax+1);
X(:, 1) = x0;
nIter = 0;
Residual = b - A * x0;
Direction = Residual;
DeltaNew =  Residual' * Residual;
DeltaZero = DeltaNew;

%%
%%  Loop until close enough or max number of iterations is reached
while (nIter < nMax) & DeltaNew > (eps^2 * DeltaZero)
    q = A * Direction;
    alpha = DeltaNew / (Direction' * q);
    X(:, nIter+2) = X(:, nIter+1) + alpha * Direction;

    Residual = Residual - alpha * q;
    DeltaOld = DeltaNew;
    DeltaNew = Residual' * Residual;
    Beta = DeltaNew / DeltaOld;
    Direction = Residual + Beta * Direction;
    nIter = nIter + 1;
end

X = X(:,1:nIter+1);
  