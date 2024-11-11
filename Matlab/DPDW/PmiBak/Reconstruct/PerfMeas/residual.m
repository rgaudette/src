%RESIDUAL       Residual error 2-norm calculation
%
%   err = residual(data, A, est)
%
%   err         The residual error 2-norm as a function the estimate index.
%
%   data        The measured data vector.
%
%   A           The forward model of the system.
%
%   est         The set of estimates of the vector, each estimate is a
%               seperate column in this matrix.
%
%
%   RESIDUAL calculates the 2-norm of the residual error for a number of
%   estimates.
%
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:39 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: residual.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:39  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function err = residual(data, A, est)

nEst = size(est,2);
err = zeros(nEst, 1);
estdata = A * est;

for i = 1:nEst
    err(i) = norm(data - estdata(:,i));
end
