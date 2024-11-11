%FDWTTIME1D     1st order forward-time finite difference ODE
%
%    [U, t] = fwdtime(a, b, Uo, dt, n)

function [U, t]= fwdtime1d(a, b, Uo, dt, n)

%%
%%  Check for stability & pre-allocate the output 
%%
if dt > 2 * a / b
    disp('Time step too large, equation is unstable');
end

U = zeros(n+1,1);
U(1) = Uo;

du = 1 - b * dt / a

for i = 1:n
    U(i+1) = U(i) * du;
end

t = [0:n] * dt;


