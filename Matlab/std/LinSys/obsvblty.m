%OBSVBLTY       Compute the observability matrix of the pair {A,C}.
%
%   [rRo, Ro] = obsvblty(a,c)

function [rRo, Ro] = obsvblty(a,c)

[n m] = size(a);

%%
%%  Compute the observability matrix
%%
Ro = zeros(n);
aprod = eye(n);
for i = 1:n,
    Ro(i,:) = c * aprod;
    aprod = aprod * a;
end

%%
%%  Compute the rank
%%
rRo = rank(Ro);
