%CGCOMP     Compare the convergence of a number of regularized CG seqs.
%
%   hPlt = cgcomp(A, b, J, Lambdas, LCLambdas, x0)

function hPlt = cgcomp(A, b, J, Lambdas, LCLambdas, x0)
clf
%%
%%  First compute the L-Curve so that we know our goals
%%
lcurve1(A, b, LCLambdas, J);

%%
%%  Compute the CG steps for each lambda and plot
%%
[nR nC] = size(A);
for iLambda = 1:length(Lambdas)
    
    %%
    %%  Create the regularized problem
    %%
    A_prime = [A; sqrt(Lambdas(iLambda))*J];
    b_prime = [b; zeros(nC, 1)];

    %%
    %%  Make it symmetric and find the conjugate gradient steps
    %%
    X = conjgrad(A_prime' * A_prime, A_prime' * b_prime, x0, nR);

    residplt(A, b, X, J);
end

xlabel('Cost: ||Jx||^2');
ylabel('Residual: ||Ax - b||^2');