%CALCERR        Calculate the 2-norm of the error of a number of estimates.
%
%   err = calcerr(true, est)
%
%   err         The error as a function the estimate index.
%
%   true        The true value of the vector.
%
%   est         The set of estimates of the vector, each estimate is a
%               seperate column in this matrix.
%
%
%   CALCERR computes the 2-norm of the difference between the given vector and
%   a number of estimates.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:38 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: calcerr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:38  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function err = calcerr(true, est)

objnorm = norm(true);
nEst = size(est,2);
err = zeros(nEst, 1);

for i = 1:nEst
    err(i) = norm(true - est(:,i))/objnorm;
end
