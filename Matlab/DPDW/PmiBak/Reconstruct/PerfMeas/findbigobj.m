%FINDBIGOBJ     Find the indices of the biggest object.
%
%  [idx binobjfct]= findbigobj(objfct, nDomain, thresh);
function [idx, binobjfct]= findbigobj(objfct, nDomain, thresh);

%%
%%  Find the peak value of the object
%%
[idxStart peakval] = findobjpeak(objfct, nDomain);
thresh = thresh * peakval;
%%
%%  Find the boundaries of the object
%%
objlist = findobjlist(objfct, nDomain, idxStart, thresh);

%%
%%  Convert the subscripted indices into a linear vector index.
%%
idx = sub2ind(nDomain, objlist(:,1), objlist(:,2), objlist(:,3));

if nargout > 1
    binobjfct = zeros(size(objfct));
    binobjfct(idx) = 1;
end
