%mergePMIStr    Merge 2 PMI structures
%
%   pmi = mergePMIStr(pmi1, pmi2)
%
%   pmi         The resultant structure.
%
%   pmi1        The subordinate structure
%
%   pmi2        The superior structure.
%
%
%   mergePMIStr merges two PMI structures with any top level fields in pmi2
%   replacing all top level fields in pmi1 with those that exist in pmi2.
%
%   Calls: none.
%
%   Bugs: this function should really only replace data fields that exist in
%   pmi2.  This needs to be done recursively with isstruct and fieldnames.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:45 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mergePMIStr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:45  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pmi = mergePMIStr(pmi1, pmi2)

pmi = pmi1;

TopFields = fieldnames(pmi2);

for iField = 1:length(TopFields)
    pmi = setfield(pmi, TopFields{iField}, getfield(pmi2, TopFields{iField}));
end
