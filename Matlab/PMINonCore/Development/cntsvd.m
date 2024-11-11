%CNTSVD         Column normalized TSVD.
%
%   [xtsvd w Uw Sw Vw] = cntsvd(A, b, Uw, Sw, Vw)
%
%   [xtsvd w Uw Sw Vw] = cntsvd(A, b, r, Uw, Sw, Vw)
%
%   xtsvd       The set of estimates requested
%
%   w           The weight vector calculated from A.
%
%   A,b         The system to be solved
%
%   r           The truncation parameters to use (default: 1:m)
%
%   Uw,Sw,Vw    OPTIONAL: The SVD of the weighted system
%
%
%   CNTSVD computes the column normalized TSVD for the given truncation
%   parameters.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:27:27 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: cntsvd.m,v $
%  Revision 1.1.1.1  2004/01/03 08:27:27  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xtsvd, w, Uw, Sw, Vw] = cntsvd(A, b, arg3, arg4, arg5, arg6)

[m n] = size(A);

switch nargin
case 2
    flgNeedSVD = 1;
    r = 1:m;
case 3
    flgNeedSVD = 1;
    r = arg3(:)';
case 5
    flgNeedSVD = 0;
    r = 1:m;
    Uw = arg3;
    Sw = arg4;
    Vw = arg5;
case 6
    flgNeedSVD = 0;
    r = arg3(:)';
    Uw = arg4;
    Sw = arg5;
    Vw = arg6;
otherwise
    error(['Incorrect number of input arguments ' int2str(nargin)]);
end


%%
%%  Compute the weights from the column 2-norms
%%
w = sqrt(sum(A .* A)) .^-1.0;
%w = max(abs(A)) .^-1;
%w = sum(abs(A)) .^-1;
if flgNeedSVD
    Aw = A * diag(w);
    [Vw Sw Uw] = svd(Aw', 0);
end

xtsvd = zeros(n, length(r));
for idxr = 1:length(r)
    ir = r(idxr);
    qtsvd = Vw(:,1:ir) * (diag(Sw(1:ir,1:ir)).^-1 .* ((Uw(:,1:ir))' * b));
    xtsvd(:, idxr) = w' .* qtsvd;
end
