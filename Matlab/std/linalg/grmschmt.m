%GRMSCHMT       Perform Gram-Schmidt orthonormalization on a matrix.
%
%    [Y N] = grmschmt(X)
%
%  NOTE: Currently works for a R^2
function [Y] = grmschmt(X)

%%
%%    get the length and number of vetcors to normalize
%%
[Lx Nx] = size(X); 

%%
%%    Compute the natural norm (2-norm) of the first vector
%%
n1 = norm(X(:,1));

%%
%%    Normalize the first vector
%%
m1 = X(:,1) / n1;

%%
%% m2_prime is equal to the x2 minus the inner product of x2 with
%%     m1 times m1
%%
%%  m2_prime = x2 - <x2,m1>m1
m2_prime = X(:,2) - X(:,2).' * conj(m1) * m1;

%%
%%   m2 = m2_prime / norm(m2_prime) 
m2 = m2_prime / norm(m2_prime);

Y = [m1 m2]

plot = 1
if plot & Lx == 2,
    compass(X(1,:).', X(2,:).', 'r');
    hold on
    compass(Y(1,:).', Y(2,:).', 'g');
    hold off
    title('Red - original basis,  Green - orthonormal basis')
end

