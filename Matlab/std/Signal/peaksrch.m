%PEAKSRCH       Simple algorithm to find the local maxima of a vector.
%
%    [values index] = peak_srch(vector, flgEndPoints)
%
%    values         The values of the peaks found.
%
%    index          The corresponding indicies of each peak.
%
%    vector         The vector to search.
%
%    flgEndPoints   OPTIONAL: if non-zero the end points of the vector
%                   will also be compared against their available
%                   neighbor.
%
%        PEAKSRCH compares each interior element against it's nearest
%    neighbors, if it is greater than both the point is considered a local
%    maxima.  If the optional parameter flgEndPoints is non-zero each
%    end point is also compared against it's sole neighbor.
%
%    Calls: none
%
%    See also: DIPSRCH
%
%    Bugs:  If there is a local maximum of 2 identically valued samples it
%           will not be detected by this algorithm!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:19 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: peaksrch.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:19  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:07:40  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [values, iLocalMax] = peak_srch(vector, flgEndPoints)

%%
%%    Do not include endpoints in search by default.
%%
if nargin < 2,
    flgEndPoints = 0;
end

%%
%%    Convert input to a row vector (for handling endpoints)
%%
vector = vector(:).';

nVec = length(vector);

%%
%%   Compare each point with it's neighbors.
%%
iLocalMax = find([flgEndPoints vector(2:nVec) > vector(1:nVec-1)] & ...
    [vector(1:nVec-1) > vector(2:nVec) flgEndPoints]) ;
values = vector(iLocalMax);
return