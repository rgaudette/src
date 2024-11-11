%OBJECT_ERR     Calculate the relative 2-norm of the error over the object.
%
%   objerr = object_err(true, est)
%
%   objerr      The error as a function the estimate index.
%
%   true        The true value of the vector.
%
%   est         The set of estimates of the vector, each estimate is a
%               seperate column in this matrix.
%
%
%   OBJECT_ERR calculates the error of a number of estimates over the
%   non-zero region of the object function.  The error measure calculated
%   is the 2-norm of the difference over the object divided by the the
%   2-norm of the object.
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
%  $Log: object_err.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:38  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function err = object_err(true, est)

objnorm  = norm(true);
nEst = size(est,2);
err = zeros(nEst, 1);

%%
%%  Find where the object function is non-zero.
%%
idx = (true ~= 0);

for i = 1:nEst
    err(i) = norm(true(idx) - est(idx,i)) / objnorm;
end
