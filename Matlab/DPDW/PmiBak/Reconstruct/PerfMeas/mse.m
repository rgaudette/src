%MSE            Mean Square Error
%
%   err = mse(true, est)
%
%   err         The error as a function the estimate index.
%
%   true        The true value of the vector.
%
%   est         The set of estimates of the vector, each estimate is a
%               seperate column in this matrix.
%
%
%   MSE calculates the mean square error on a per voxel basis for each
%   estimate present in est.
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
%  $Log: mse.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:38  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function err = mse(true, est)

nEst = size(est,2);
err = zeros(nEst, 1);

for i = 1:nEst
    err(i) = mean((true - est(:,i)).^2);
end
