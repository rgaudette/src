%OBSRVSO        Convert a single output system to observable canonical form.
%
%   [Ao Bo Co Do Po] = obsrvso(A, B, C, D)
%
%   Note: currently does not work yet!!!!

function [Ao, Bo, Co, Do, Po] = obsrvso(A, B, C, D)

%%
%%  Check to make sure this is a single outut system.
%%
[r n] = size(C);

if r > 1,
    error('This algorithm only works for single output systems.');
end

%%
%%  Generate the observability matrix Ro
%%
[rRo, Ro] = obsvblty(A, C);

if rRo ~= n,
    error('The system is not observable');
end

%%
%%  Find the transformation matrix Po
%%
invRo = inv(Ro);
Po = zeros(n);
Aprod = eye(n);
for i = 1:n,
    Po(:,i) = Aprod * invRo(:,n);
    Aprod = Aprod * A;
end

invPo = inv(Po);

%%
%%  Transform the system into controllable form
%%
Ao = Po * A * invPo;
Bo = Po * B;
Co = C * invPo;
Do = D;

