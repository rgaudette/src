%FINDOBJECT     Find the indices of the specified object.
%
%   [idx binobjfct] = findobject(objfct, nDomain, idxStart, Thresh)
%
%   idx         The indices of the detected object.
%
%   binobjfct   A binary object function indicating where the object was
%               detected.
%
%   objfct      The object function to analyze.
%
%   nDomain
%
%   idxStart
%
%   Thresh
%
%   FINDOBJECT returns the indices of the object detected by starting at
%   idxStart and serching connected voxels for values above Thresh.
%
%   Calls: findobjlist
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
%  $Log: findobject.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:38  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [idx, binobjfct] = findobject(objfct, nDomain, idxStart, Thresh)

%%
%%  Find the boundaries of the object
%%
objlist = findobjlist(objfct, nDomain, idxStart, Thresh);

%%
%%  Convert the subscripted indices into a linear vector index.
%%

idx = sub2ind(nDomain, objlist(:,1), objlist(:,2), objlist(:,3));

if nargout > 1
    binobjfct = zeros(size(objfct));
    binobjfct(idx) = 1;
end
