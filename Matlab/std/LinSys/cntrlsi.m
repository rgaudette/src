%CNTRLSI       Convert a single input system to controllable form.
%
%   [Ac Bc Cc Dc Pc] = cntrlsi(A, B, C, D)
%

function [Ac, Bc, Cc, Dc, Pc] = cntrlsi(A, B, C, D)

%%
%%  Check to make sure this is a single input system.
%%
[n m] = size(B);

if m > 1,
    error('This algorithm only works for single input systems.');
end

%%
%%  Generate the controllability matrix Rc
%%
[rRc, Rc] = cntrblty(A, B);

if rRc ~= n,
    error('The system is not controllable');
end

%%
%%  Find the transformation matrix Pc
%%
invRc = inv(Rc);
Pc = zeros(n);
Aprod = eye(n);
for i = 1:n,
    Pc(i,:) = invRc(n,:) * Aprod;
    Aprod = Aprod * A;
end

invPc = inv(Pc);

%%
%%  Transform the system into controllable form
%%
Ac = Pc * A * invPc;
Bc = Pc * B;
Cc = C * invPc;
Dc = D;

