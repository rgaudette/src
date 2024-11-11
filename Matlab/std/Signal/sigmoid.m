%SIGMOID        Sigmoid function.
%
%   y = sigmoid(x, alpha)
%
%   y           Sigmoidal signal.
%
%   x           Function argument.
%
%   alpha       Rate parameter.
%
%
%   SIGMOID computes a sigmoidal function of the free variable x.  The
%   function is computed by
%
%           (1-exp(-alpha x))
%   f(x) = -------------------  = tanh(alpha x / 2).
%           (1+exp(-alpha x))
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:20 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: sigmoid.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:20  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:01:57  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = sigmoid(x, alpha)

y = tanh(alpha / 2  * x);
