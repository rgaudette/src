%CRANDN         Generate a complex normal "Gaussian" random sequence with 
%               independent I and Q signals.
%
%    Z = crandn(N)
%    Z = crandn(M, N)
%
%    Z          The complex random vector or matrix. 
%
%    M,N        The size of the vector or matrix to generate.
%
%	    CRANDN generate a complex normal vector or matrix.  I and Q are
%    independent with zero mean and a variance of 1/2 for each channel (this
%    gives a total power of 1).
%
%    Calls: none.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:19 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: crandn.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:19  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:10:29  rjg
%  Initial revision
%
%  
%     Rev 1.1   22 Mar 1994 09:41:20   rjg
%  A little help description editing.
%  
%     Rev 1.0   04 Jan 1994 16:08:52   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z = crandn(arg1, arg2)

%%
%%    Matrix or vector?
%%
if nargin < 2,
    z = (randn(arg1) + j * randn(arg1)) / sqrt(2);
else
    z = (randn(arg1, arg2) + j * randn(arg1, arg2)) / sqrt(2);
end

