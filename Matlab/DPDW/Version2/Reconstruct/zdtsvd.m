%ZDTSVD         Z Depedent TSVD estimate.
%
%   [xtsvd U S V]= zdtsvd(A, b, CompVol, r, U, S, V)
%
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:08 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: zdtsvd.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xtsvd, U, S, V] = zdtsvd(A, b, CompVol, r, U, S, V)

%%
%%  Compute the economy SVD of the tall problem if necessary
%%
if nargin < 6
    [V S U] = svd(A', 0);
end

%%
%%  Compute the range of TSVD reconstruction for each layer
%%
[X Y Z] = meshgrid(CompVol.X, CompVol.Y, CompVol.Z);
nZ = length(CompVol.Z);
Z = Z(:);
xtsvd = zeros(size(Z));
for i = 1:nZ
    idxDepth = (Z == CompVol.Z(i));
    temp = V(:,1:r(i)) * (diag(S(1:r(i),1:r(i))).^-1 .* ((U(:,1:r(i)))' * b));
    xtsvd(idxDepth) = temp(idxDepth);
end

