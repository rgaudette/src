%cleanFwdSys    Delete the forward system matrix from the PMI data structure.
%
%   ds = cleanFwdSys(ds);
%
%   ds          The PMI data structure to operate upon.
%
%
%   cleanFwdSys sets the forward system to matrix to empty to conserve memory.
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
%  $Log: cleanFwdSys.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:45  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ds = cleanFwdSys(ds);
ds.Fwd.A =[];
