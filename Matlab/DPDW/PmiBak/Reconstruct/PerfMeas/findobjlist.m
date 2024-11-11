%FINDOBJLIST    Find the object voxel list.
%
%   objlist = findobjlist(objfct, NDomain, idxStart, Thresh)
%
%   objlist     A three column matrix containing the list voxels
%               associated with the object.
%
%   objfct      The object function to be analyzed. 
%
%   NDomain     The number of elements in each domain [nX nY nZ].
%
%   idxStart    The initial element from which to start the search.
%               [iX iY iZ].
%
%   Thresh      The absolute theshold value to distinguish between a zero
%               and non-zero voxel.
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: recobjsrch
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
%  $Log: findobjlist.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:38  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function objlist = findobjlist(objfct, nDomain, idxStart, Thresh)

%%
%%  Reshape the object function
%%
objfct = reshape(objfct, nDomain(1), nDomain(2), nDomain(3));

%%
%%  Recursively call the object search function.
%%
objlist = recobjsrch(objfct, nDomain, idxStart, idxStart, Thresh);

