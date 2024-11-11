%FOCUSS2        FOCal Underdetermined System Solver using the L-curve.
%
%   [xf q] = focuss(A, b, nIter, xprev)
%
%   xf          The FOCUSS solution
%
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none.
%
%   Bugs: none known.
%
%   Ref: Gorodnitsky

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:31 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: focuss2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:31  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xf, q] = focuss2(A, b, nIter, xprev)

%%
%%  Weight the system to normalize the columns
%%
w = sqrt(sum(A .* A)) .^-0.5;
A = A * diag(w);

%%
%%  If xinit is not present then compute the min. norm solution
%%
if nargin < 4
    xprev = lctsvd(A, b);
end

for i = 1:nIter
    Aw = A * diag(xprev);
    q = lctsvd(Aw, b);
    xf = diag(xprev) * q;
    xpref = xf;
end

%%
%% return the unweighted estimate
%%
xf = w' .* xf;

function xest = lctsvd(A, b)

%%
%%  Compute the TSVD for all truncation parameters and plot the L-curve
%%  letting the user manualy select the truncation point.
%%
[m n] = size(A);
xtsvd = fattsvdall(A, b);
clf
[reg_c manualc] = plcurve(xtsvd(:,1:m-10), A, b, 1:m-10, 1);
manualc
xest = xtsvd(:, manualc);

