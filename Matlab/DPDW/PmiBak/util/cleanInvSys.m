%cleanInvSys    Delete the forward system matrix from the PMI data structure.
%
%   ds = cleanInvSys(ds);
%
%   ds          The PMI data structure to operate upon.
%
%
%   cleanInvSys sets the inverse system to matrix to empty to conserve memory.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:45 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: cleanInvSys.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:45  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ds = cleanInvSys(ds);
ds.Inv.A =[];
