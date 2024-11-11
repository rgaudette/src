%RECOBJSRCH     Recursive object search.
%
%   objlist = recobjsrch(objfct, nDomain, idxSearch, idxKnown, Thresh)
%
%   objlist     A three column matrix containing the list voxels
%               associated with the object.
%
%   objfct      The object function to be analyzed. 
%
%   NDomain     The number of elements in each domain [nX nY nZ].
%
%   idxSearch   The voxels to evaluate, a Nx3 matrix, each row specifies
%               a voxel to examine.
%
%
%   RECOBJSRCH examines the object function at each voxel specified by
%   checking each of its six nearest neighboors if they are above the
%   threshold.  First they are examined to see if they are already on the
%   known list.  If they are not on the known list and above the
%   threshold they are added to the search list at the next level and the
%   curent known list.  A call with an empty search terminated the
%   recursion by copying the known list to objlist.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:39 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: recobjsrch.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:39  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function objlist = recobjsrch(objfct, nDomain, idxSearch, idxKnown, Thresh)

nSrchVoxels = size(idxSearch,1);

%%
%%  Copy known list to objlist
%%
if nSrchVoxels == 0
    objlist = idxKnown;
    return
end
mOffset = [ 1  0  0
           -1  0  0
            0  1  0
            0 -1  0
            0  0  1
            0  0 -1];
idxNewSearch = [];
for i = 1:nSrchVoxels
    %%
    %%  Create a matrix of the six surrounding voxels
    %%
    connected = repmat(idxSearch(i,:),6,1) + mOffset;
    
    %%
    %%  Remove any not in the domain
    %%
    idxInDom = (connected(:,1) >= 1) & (connected(:,1) <= nDomain(1)) & ...
        (connected(:,2) >= 1) & (connected(:,2) <= nDomain(2)) & ...
        (connected(:,3) >= 1) & (connected(:,3) <= nDomain(3));
    connected = connected(idxInDom, :);
    
    %%
    %%  Remove any already on the known list
    %%
    nConnected = size(connected,1);
    if nConnected > 0
        if size(idxKnown, 1) > 0
            connected = remknown(connected, idxKnown);
        end
    end
    
    %%
    %%  Find any left that are greater than the threshold and place them
    %%  on the idxKnonw and idxNewSearch lists
    %%
    nConnected = size(connected,1);
    if nConnected > 0
        for i = 1:nConnected
            if objfct(connected(i,1), connected(i,2), connected(i,3)) > Thresh
                idxKnown = [idxKnown; connected(i,:)];
                idxNewSearch = [idxNewSearch; connected(i,:)];
            end
        end
    end
end

%%
%%  Call this function again to evaluate the search idices
%%
objlist = recobjsrch(objfct, nDomain, idxNewSearch, idxKnown, Thresh);
return

function connected = remknown(connected, idxKnown)

nSrch = size(connected, 1);
iKeep = [];
for i = 1:nSrch
    if ~any((connected(i,1) == idxKnown(:,1)) & ...
            (connected(i,2) == idxKnown(:,2)) & ...
            (connected(i,3) == idxKnown(:,3)))
         
        iKeep = [iKeep; i];
    end
end

connected = connected(iKeep,:);
