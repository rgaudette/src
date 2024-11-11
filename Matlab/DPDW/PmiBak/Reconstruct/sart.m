%SART           Simultaneuous ART
%
%   x = sart(A, b, xo, nIter)
%
%   x           The estimate of the x vector.
%
%   A           The forward matrix.
%
%   b           The measured data.
%
%   xinit       OPTIONAL: An initial guess, if not supplied then 0 will be
%               used.
%
%   nIter       OPTIONAL: The maximum number of iterations to compute
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none.
%
%   Bugs: DOESN'T WORK AT THIS POINT, NEED TO GET THE KAK ARTICLE.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:37 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: sart.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:37  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = sart(A, b, xo, nIter)

%%
%%  Precompute the row and columns sums
%%
cs = sum(A)';
rs = sum(A')';

%%
%%  Loop over the the requested number of iteration
%%
x = xo;

for i = 1:nIter
    sr = (b - A * x) ./ rs;
    delx = (A' * sr) ./ cs;
    x = x + delx;
end
