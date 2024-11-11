%OPAPSC         Optimum a priori scaling coeffiecient
%
%   alpha = opapsc(XTrue, XEst);
%
%   alpha       The optimum scaling coefficient.
%
%   XTrue       The true vector.
%
%   XEst        The estimated vector
%
%
%   OPAPSC solves the minimimzation problem
%
%       alpha = argmin(||XTrue - alpha*XEst||)
%
%
%   Calls: none.
%
%   Bugs: Seems to work for complex vector but I only worked it out in terms of
%   the SVD.  I am not sure that this holds in all complex cases.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:38 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: opapsc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:38  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function alpha = opapsc(XTrue, XEst);

alpha = (XEst' * XTrue) / (XEst' * XEst);

